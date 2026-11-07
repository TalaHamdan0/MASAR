from flask import jsonify, request, current_app

from . import university_bp
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest


def _get_bearer_token():
    authorization = request.headers.get("Authorization", "")
    parts = authorization.split(" ", 1)

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    return parts[1].strip()


def _error_response(code, message, status_code):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status_code


def _application_status(status):
    value = str(status or "").strip().upper()
    value = value.replace("-", "_").replace(" ", "_")

    pending_statuses = {
        "PENDING",
        "SUBMITTED",
        "UNDER_REVIEW",
        "PENDING_REVIEW",
        "IN_REVIEW",
        "REVIEWING",
        "WAITING_FOR_REVIEW",
        "WAITING_COMPANY_REVIEW",
        "WAITING_UNIVERSITY_REVIEW",
    }

    accepted_statuses = {
        "ACCEPTED",
        "APPROVED",
        "SELECTED",
        "ACCEPTED_BY_COMPANY",
        "APPROVED_BY_COMPANY",
    }

    rejected_statuses = {
        "REJECTED",
        "DECLINED",
        "REJECTED_BY_COMPANY",
        "REJECTED_BY_UNIVERSITY",
    }

    if value in pending_statuses:
        return "قيد المراجعة"

    if value in accepted_statuses:
        return "مقبول"

    if value in rejected_statuses:
        return "مرفوض"

    if value in {"WITHDRAWN"}:
        return "منسحب"

    if value in {"CANCELLED", "CANCELED"}:
        return "ملغي"

    return str(status or "غير محددة")


@university_bp.get("/applications")
def get_applications():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        # التحقق من جلسة دخول مسؤول الجامعة
        cursor.execute("""
            SELECT 1
            FROM auth_sessions a
            JOIN users u
                ON u.user_id = a.user_id
            JOIN roles r
                ON r.role_id = u.role_id
            JOIN university_staff us
                ON us.user_id = u.user_id
            JOIN universities un
                ON un.university_id = us.university_id
            WHERE a.token_hash = :token_hash
              AND a.revoked_at IS NULL
              AND a.expires_at > LOCALTIMESTAMP
              AND u.account_status = 'ACTIVE'
              AND r.role_code = 'UNIVERSITY_ADMIN'
              AND us.staff_role = 'ADMIN'
              AND us.is_active = 1
              AND us.university_id = :university_id
              AND un.is_active = 1
        """,
            token_hash=token_digest(token),
            university_id=WISE_UNIVERSITY_ID,
        )

        if cursor.fetchone() is None:
            return _error_response(
                "invalid_session",
                "سجّلي الدخول أولًا.",
                401,
            )

        # جلب طلبات طلاب الجامعة
        cursor.execute("""
            SELECT
                ia.application_id,
                s.student_number,
                u.full_name,
                s.major,
                c.company_name,
                COALESCE(o.title, tt.track_name) AS training_title,
                TO_CHAR(
                    ia.submitted_at,
                    'DD/MM/YYYY'
                ) AS application_date,
                ia.application_status,

                (
                    SELECT COUNT(*)
                    FROM application_attachments aa
                    WHERE aa.application_id = ia.application_id
                ) AS document_count

            FROM internship_applications ia

            JOIN students s
                ON s.student_id = ia.student_id

            JOIN users u
                ON u.user_id = s.user_id

            JOIN internship_offers o
                ON o.offer_id = ia.offer_id

            JOIN companies c
                ON c.company_id = o.company_id

            LEFT JOIN training_tracks tt
                ON tt.training_track_id = o.training_track_id

            WHERE s.university_id = :university_id

            ORDER BY
                ia.submitted_at DESC,
                ia.application_id DESC
        """, university_id=WISE_UNIVERSITY_ID)

        rows = cursor.fetchall()

        applications = []

        # تجهيز الطلبات وإحصائيات الحالات
        pending_count = 0
        accepted_count = 0
        rejected_count = 0

        for row in rows:
            application_id = int(row[0])
            student_number = row[1] or "—"
            student_name = row[2] or "غير محدد"
            major = row[3] or "غير محدد"
            company_name = row[4] or "غير محدد"
            training_title = row[5] or "غير محدد"
            application_date = row[6] or "—"

            status = _application_status(row[7])

            document_count = int(row[8] or 0)

            if document_count == 0:
                documents = "لا توجد وثائق مرفقة"
            else:
                documents = f"{document_count} وثيقة مرفقة"

            if status == "قيد المراجعة":
                pending_count += 1
            elif status == "مقبول":
                accepted_count += 1
            elif status == "مرفوض":
                rejected_count += 1

            applications.append({
                "applicationId": str(application_id),
                "name": student_name,
                "id": str(student_number),
                "major": major,
                "company": company_name,
                "training": training_title,
                "date": application_date,
                "status": status,
                "documents": documents,
                "gpa": "—",
            })

        statistics = {
            "totalApplications": len(applications),
            "pendingApplications": pending_count,
            "acceptedApplications": accepted_count,
            "rejectedApplications": rejected_count,
        }

        return jsonify({
            "data": {
                "statistics": statistics,
                "applications": applications,
            }
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university applications"
        )

        return _error_response(
            "server_error",
            "حدث خطأ أثناء تحميل طلبات التدريب.",
            500,
        )

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None:
            connection.close()