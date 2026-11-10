
from flask import jsonify, request

from . import university_bp
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest


TRAINING_TERM_LABEL = "الفصل التدريبي 2026 / 2027"


def _error_response(code, message, status):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status


def _get_bearer_token():
    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    if not 20 <= len(parts[1]) <= 200:
        return None

    return parts[1]


def _get_university_admin(cursor, token):
    cursor.execute("""
        SELECT
            u.user_id,
            u.full_name,
            us.university_id,
            un.university_name,
            us.employee_number
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

    return cursor.fetchone()


@university_bp.get("/home")
def university_home():

    # 1. Check the login token
    token = _get_bearer_token()

    if token is None:
        return _error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:

            # 2. Verify the university administrator
            admin = _get_university_admin(cursor, token)

            if admin is None:
                return _error_response(
                    "invalid_session",
                    "انتهت الجلسة أو الحساب غير صالح.",
                    401,
                )

            university_id = int(admin[2])

            # 3. Main statistics
            cursor.execute("""
                SELECT
                    (
                        SELECT COUNT(*)
                        FROM students
                        WHERE university_id = :university_id
                    ) AS total_students,

                    (
                        SELECT COUNT(*)
                        FROM companies
                    ) AS registered_companies,

                    (
                        SELECT COUNT(DISTINCT student_id)
                        FROM internships
                        WHERE university_id = :university_id
                          AND internship_status = 'ACTIVE'
                    ) AS students_in_training,

                    (
                        SELECT COUNT(*)
                        FROM internship_applications ia
                        JOIN students s
                            ON s.student_id = ia.student_id
                        WHERE s.university_id = :university_id
                          AND ia.application_status = 'SUBMITTED'
                    ) AS new_applications

                FROM dual
            """, university_id=university_id)

            statistics_row = cursor.fetchone()

            statistics = {
                "totalStudents": int(statistics_row[0]),
                "registeredCompanies": int(statistics_row[1]),
                "studentsInTraining": int(statistics_row[2]),
                "newApplications": int(statistics_row[3]),
            }

            # 4. Students by major
            cursor.execute("""
                SELECT
                    NVL(major, 'غير محدد') AS major,
                    COUNT(*) AS students_count
                FROM students
                WHERE university_id = :university_id
                GROUP BY NVL(major, 'غير محدد')
                ORDER BY students_count DESC, major
                FETCH FIRST 5 ROWS ONLY
            """, university_id=university_id)

            students_by_major = [
                {
                    "major": row[0],
                    "count": int(row[1]),
                }
                for row in cursor.fetchall()
            ]

            # 5. Internship status counts
            cursor.execute("""
                SELECT
                    SUM(
                        CASE
                            WHEN internship_status = 'ACTIVE'
                            THEN 1 ELSE 0
                        END
                    ) AS active_count,

                    SUM(
                        CASE
                            WHEN internship_status = 'COMPLETED'
                            THEN 1 ELSE 0
                        END
                    ) AS completed_count,

                    SUM(
                        CASE
                            WHEN internship_status = 'SELECTED'
                            THEN 1 ELSE 0
                        END
                    ) AS selected_count,

                    SUM(
                        CASE
                            WHEN internship_status <> 'CANCELLED'
                            THEN 1 ELSE 0
                        END
                    ) AS total_count

                FROM internships
                WHERE university_id = :university_id
            """, university_id=university_id)

            status_row = cursor.fetchone()

            active_count = int(status_row[0] or 0)
            completed_count = int(status_row[1] or 0)
            selected_count = int(status_row[2] or 0)
            total_count = int(status_row[3] or 0)

            completion_percentage = (
                round((completed_count / total_count) * 100, 1)
                if total_count > 0
                else 0
            )

            internship_status_counts = [
                {
                    "status": "ACTIVE",
                    "count": active_count,
                },
                {
                    "status": "COMPLETED",
                    "count": completed_count,
                },
                {
                    "status": "SELECTED",
                    "count": selected_count,
                },
            ]

            # 6. Latest training applications
            cursor.execute("""
                SELECT
                    u.full_name,
                    c.company_name,
                    o.title,
                    ia.submitted_at,
                    ia.application_status
                FROM internship_applications ia
                JOIN students s
                    ON s.student_id = ia.student_id
                JOIN users u
                    ON u.user_id = s.user_id
                JOIN internship_offers o
                    ON o.offer_id = ia.offer_id
                JOIN companies c
                    ON c.company_id = o.company_id
                WHERE s.university_id = :university_id
                ORDER BY ia.submitted_at DESC
                FETCH FIRST 5 ROWS ONLY
            """, university_id=university_id)

            status_labels = {
                "SUBMITTED": "جديد",
                "UNDER_REVIEW": "قيد المراجعة",
                "ACCEPTED": "مقبول",
                "REJECTED": "مرفوض",
                "WITHDRAWN": "مسحوب",
                "NOT_SELECTED": "غير مختار",
            }

            latest_applications = []

            for row in cursor.fetchall():
                submitted_at = row[3]

                latest_applications.append({
                    "studentName": row[0],
                    "companyName": row[1],
                    "trainingTitle": row[2],
                    "submittedAt": (
                        submitted_at.strftime("%Y-%m-%d")
                        if submitted_at is not None
                        else None
                    ),
                    "status": status_labels.get(row[4], row[4]),
                })

            # 7. Weekly reports waiting for review
            cursor.execute("""
                SELECT COUNT(*)
                FROM weekly_reports wr
                JOIN internships i
                    ON i.internship_id = wr.internship_id
                WHERE i.university_id = :university_id
                  AND wr.report_status = 'SUBMITTED'
            """, university_id=university_id)

            reports_to_review = int(cursor.fetchone()[0])

            # 8. Students who completed at least 80% of required hours
            # Only APPROVED + PRESENT attendance minutes are credited.
            cursor.execute("""
                SELECT COUNT(DISTINCT training.student_id)
                FROM (
                    SELECT
                        i.student_id,
                        i.internship_id,
                        i.required_hours,
                        NVL(SUM(ar.credited_minutes), 0) AS credited_minutes
                    FROM internships i
                    LEFT JOIN attendance_records ar
                        ON ar.internship_id = i.internship_id
                       AND ar.company_id = i.company_id
                       AND ar.approval_status = 'APPROVED'
                       AND ar.attendance_status = 'PRESENT'
                    WHERE i.university_id = :university_id
                      AND i.internship_status = 'ACTIVE'
                    GROUP BY
                        i.student_id,
                        i.internship_id,
                        i.required_hours
                    HAVING NVL(SUM(ar.credited_minutes), 0)
                        >= i.required_hours * 60 * 0.80
                ) training
            """, university_id=university_id)

            students_near_completion = int(cursor.fetchone()[0])

            # 9. Trainings completed during the current week
            cursor.execute("""
                SELECT COUNT(*)
                FROM internships
                WHERE university_id = :university_id
                  AND internship_status = 'COMPLETED'
                  AND actual_end_date >= TRUNC(SYSDATE, 'IW')
                  AND actual_end_date < TRUNC(SYSDATE) + 1
            """, university_id=university_id)

            completed_this_week = int(cursor.fetchone()[0])

    # 10. Build the response
    return jsonify({
        "data": {
            "staff": {
                "userId": str(admin[0]),
                "name": admin[1],
                "employeeNumber": admin[4],
            },
            "university": {
                "id": str(admin[2]),
                "name": admin[3],
            },
            "trainingTermLabel": TRAINING_TERM_LABEL,
            "statistics": statistics,
            "studentsByMajor": students_by_major,
            "internshipStatusCounts": internship_status_counts,
            "completionPercentage": completion_percentage,
            "latestApplications": latest_applications,
            "alerts": {
                "newApplications": statistics["newApplications"],
                "reportsToReview": reports_to_review,
                "studentsNearCompletion": students_near_completion,
                "completedThisWeek": completed_this_week,
            },
        }
    })
