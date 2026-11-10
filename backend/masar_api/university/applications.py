from flask import jsonify, request, current_app

from . import university_bp
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest


# These are the application states that the university admin is allowed
# to decide. Company-review states are intentionally excluded.
UNIVERSITY_REVIEWABLE_STATUSES = {
    # These are the only pending application values allowed by
    # CK_APPLICATIONS_STATUS in the current Oracle schema.
    "SUBMITTED",
    "UNDER_REVIEW",
}


ACCEPTED_STATUSES = {
    "ACCEPTED",
    "APPROVED",
    "SELECTED",
    "ACCEPTED_BY_COMPANY",
    "APPROVED_BY_COMPANY",
    "ACCEPTED_BY_UNIVERSITY",
    "APPROVED_BY_UNIVERSITY",
}


REJECTED_STATUSES = {
    "REJECTED",
    "DECLINED",
    "REJECTED_BY_COMPANY",
    "REJECTED_BY_UNIVERSITY",
}


PENDING_STATUSES = UNIVERSITY_REVIEWABLE_STATUSES | {
    "WAITING_COMPANY_REVIEW",
    "WAITING_FOR_COMPANY_REVIEW",
}


def _get_bearer_token():
    authorization = request.headers.get("Authorization", "")
    parts = authorization.split(" ", 1)

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    token = parts[1].strip()
    return token or None


def _error_response(code, message, status_code):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status_code


def _normalize_status(status):
    value = str(status or "").strip().upper()
    return value.replace("-", "_").replace(" ", "_")


def _application_status(status):
    value = _normalize_status(status)

    if value in PENDING_STATUSES:
        return "قيد المراجعة"

    if value in ACCEPTED_STATUSES:
        return "مقبول"

    if value in REJECTED_STATUSES:
        return "مرفوض"

    if value == "WITHDRAWN":
        return "منسحب"

    if value in {"CANCELLED", "CANCELED"}:
        return "ملغي"

    return str(status or "غير محددة")


def _can_university_decide(status):
    return _normalize_status(status) in UNIVERSITY_REVIEWABLE_STATUSES


def _university_admin_is_valid(cursor, token):
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

    return cursor.fetchone() is not None


def _open_authorized_connection(token):
    """Open a DB connection and verify the current university admin session."""
    connection = get_connection()
    cursor = connection.cursor()

    try:
        if not _university_admin_is_valid(cursor, token):
            cursor.close()
            connection.close()
            return None, None

        return connection, cursor
    except Exception:
        cursor.close()
        connection.close()
        raise


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
        connection, cursor = _open_authorized_connection(token)

        if connection is None:
            return _error_response(
                "invalid_session",
                "سجّلي الدخول أولًا.",
                401,
            )

        cursor.execute("""
            SELECT
                ia.application_id,
                s.student_number,
                u.full_name,
                s.major,
                c.company_name,
                COALESCE(o.title, tt.track_name) AS training_title,
                TO_CHAR(ia.submitted_at, 'DD/MM/YYYY') AS application_date,
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
            ORDER BY ia.submitted_at DESC, ia.application_id DESC
        """, university_id=WISE_UNIVERSITY_ID)

        rows = cursor.fetchall()
        applications = []
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
            raw_status = _normalize_status(row[7])
            status = _application_status(raw_status)
            document_count = int(row[8] or 0)

            documents = (
                "لا توجد وثائق مرفقة"
                if document_count == 0
                else f"{document_count} وثيقة مرفقة"
            )

            if status == "قيد المراجعة":
                pending_count += 1
            elif status == "مقبول":
                accepted_count += 1
            elif status == "مرفوض":
                rejected_count += 1

            if raw_status in {"WAITING_COMPANY_REVIEW", "WAITING_FOR_COMPANY_REVIEW"}:
                review_note = "بانتظار مراجعة الشركة"
            elif _can_university_decide(raw_status):
                review_note = ""
            else:
                review_note = "لا يتطلب إجراءً من الجامعة"

            applications.append({
                "applicationId": str(application_id),
                "name": student_name,
                "id": str(student_number),
                "major": major,
                "company": company_name,
                "training": training_title,
                "date": application_date,
                "status": status,
                "statusCode": raw_status,
                "canReview": _can_university_decide(raw_status),
                "reviewNote": review_note,
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


@university_bp.patch("/applications/<int:application_id>/decision")
def decide_application(application_id):
    """Accept or reject one application belonging to the signed-in university."""
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return _error_response(
            "invalid_request",
            "بيانات القرار غير صالحة.",
            400,
        )

    decision = str(payload.get("decision", "")).strip().upper()

    if decision not in {"ACCEPT", "REJECT"}:
        return _error_response(
            "invalid_decision",
            "اختاري قبول الطلب أو رفضه.",
            400,
        )

    # CK_APPLICATIONS_STATUS only allows ACCEPTED / REJECTED.
    # Do not use ACCEPTED_BY_UNIVERSITY or REJECTED_BY_UNIVERSITY;
    # Oracle will reject those values with a check-constraint violation.
    new_status = "ACCEPTED" if decision == "ACCEPT" else "REJECTED"
    arabic_status = "مقبول" if decision == "ACCEPT" else "مرفوض"

    connection = None
    cursor = None

    try:
        connection, cursor = _open_authorized_connection(token)

        if connection is None:
            return _error_response(
                "invalid_session",
                "سجّلي الدخول أولًا.",
                401,
            )

        # Lock this application row so two admins cannot decide it at the same time.
        # The university filter prevents one university from deciding another's request.
        cursor.execute("""
            SELECT ia.application_status
            FROM internship_applications ia
            JOIN students s
                ON s.student_id = ia.student_id
            WHERE ia.application_id = :application_id
              AND s.university_id = :university_id
            FOR UPDATE OF ia.application_status
        """,
            application_id=application_id,
            university_id=WISE_UNIVERSITY_ID,
        )

        application_row = cursor.fetchone()

        if application_row is None:
            connection.rollback()
            return _error_response(
                "application_not_found",
                "طلب التدريب غير موجود أو لا يتبع لهذه الجامعة.",
                404,
            )

        current_status = _normalize_status(application_row[0])

        if not _can_university_decide(current_status):
            connection.rollback()
            return _error_response(
                "application_not_reviewable",
                "هذا الطلب ليس بانتظار قرار الجامعة أو سبق اتخاذ قرار بشأنه.",
                409,
            )

        cursor.execute("""
            UPDATE internship_applications
            SET application_status = :new_status,
                updated_at = LOCALTIMESTAMP
            WHERE application_id = :application_id
              AND application_status = :current_status
              AND student_id IN (
                    SELECT student_id
                    FROM students
                    WHERE university_id = :university_id
              )
        """,
            new_status=new_status,
            application_id=application_id,
            current_status=application_row[0],
            university_id=WISE_UNIVERSITY_ID,
        )

        if cursor.rowcount != 1:
            connection.rollback()
            return _error_response(
                "application_update_conflict",
                "تم تحديث هذا الطلب من مكان آخر. حدّثي القائمة وحاولي مرة أخرى.",
                409,
            )

        connection.commit()

        return jsonify({
            "data": {
                "applicationId": str(application_id),
                "status": arabic_status,
                "statusCode": new_status,
                "canReview": False,
            }
        }), 200

    except Exception:
        if connection is not None:
            connection.rollback()

        current_app.logger.exception(
            "Failed to decide university application %s",
            application_id,
        )

        return _error_response(
            "server_error",
            "حدث خطأ أثناء تحديث حالة طلب التدريب.",
            500,
        )

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None:
            connection.close()
