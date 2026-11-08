from flask import jsonify, request, current_app

from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest
from . import university_bp


def _get_bearer_token():
    authorization = request.headers.get("Authorization", "")
    parts = authorization.split()

    if len(parts) == 2 and parts[0].lower() == "bearer":
        return parts[1]

    return None


def _error_response(code, message, status_code):
    return jsonify({
        "success": False,
        "error": {
            "code": code,
            "message": message,
        }
    }), status_code


def _to_int(value):
    if value is None:
        return 0

    return int(round(float(value)))


@university_bp.get("/current-trainings")
def get_current_trainings():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "UNAUTHORIZED",
            "Authentication token is required.",
            401,
        )

    connection = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        # 1. Verify that the user is an active university administrator.
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
            cursor.close()
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        # 2. Get internships and their related information.
        cursor.execute("""
            SELECT
                i.internship_id,
                s.student_number,
                u.full_name,
                s.major,
                c.company_name,
                COALESCE(
                    tt.track_name,
                    cp.path_name,
                    o.title,
                    '—'
                ) AS career_path,

                TO_CHAR(
                    i.planned_start_date,
                    'DD/MM/YYYY'
                ) AS start_date,

                TO_CHAR(
                    i.planned_end_date,
                    'DD/MM/YYYY'
                ) AS end_date,

                ROUND(
                    NVL(hs.completed_hours, 0)
                ) AS completed_hours,

                i.required_hours,

                CASE
                    WHEN UPPER(TRIM(i.internship_status))
                         IN ('COMPLETED', 'FINISHED', 'CLOSED')
                         OR NVL(hs.completed_hours, 0)
                            >= i.required_hours
                    THEN 'COMPLETED'

                    WHEN i.planned_end_date < TRUNC(SYSDATE)
                    THEN 'LATE'

                    WHEN NVL(hs.completed_hours, 0)
                         >= i.required_hours * 0.8
                    THEN 'NEAR_COMPLETION'

                    ELSE 'ONGOING'
                END AS calculated_status,

                i.cev_submitted_at,

                ROUND(
                    (
                        NVL(i.cev_commitment_score, 0)
                        + NVL(i.cev_attendance_score, 0)
                        + NVL(i.cev_technical_skills_score, 0)
                        + NVL(i.cev_communication_score, 0)
                        + NVL(i.cev_teamwork_score, 0)
                        + NVL(i.cev_work_quality_score, 0)
                    )
                    /
                    NULLIF(
                        (CASE WHEN i.cev_commitment_score IS NOT NULL THEN 1 ELSE 0 END)
                        + (CASE WHEN i.cev_attendance_score IS NOT NULL THEN 1 ELSE 0 END)
                        + (CASE WHEN i.cev_technical_skills_score IS NOT NULL THEN 1 ELSE 0 END)
                        + (CASE WHEN i.cev_communication_score IS NOT NULL THEN 1 ELSE 0 END)
                        + (CASE WHEN i.cev_teamwork_score IS NOT NULL THEN 1 ELSE 0 END)
                        + (CASE WHEN i.cev_work_quality_score IS NOT NULL THEN 1 ELSE 0 END),
                        0
                    )
                ) AS overall_rating,

                i.cev_commitment_score,

                i.cev_notes,

                TO_CHAR(
                    i.cev_submitted_at,
                    'DD/MM/YYYY'
                ) AS evaluation_date

            FROM internships i

            JOIN students s
                ON s.student_id = i.student_id

            JOIN users u
                ON u.user_id = s.user_id

            JOIN companies c
                ON c.company_id = i.company_id

            JOIN internship_offers o
                ON o.offer_id = i.offer_id

            LEFT JOIN training_tracks tt
                ON tt.training_track_id = o.training_track_id

            LEFT JOIN career_paths cp
                ON cp.career_path_id = s.career_path_id

            LEFT JOIN internship_hours_summary hs
                ON hs.internship_id = i.internship_id

            WHERE i.university_id = :university_id
              AND s.university_id = :university_id
              AND UPPER(TRIM(i.internship_status))
                  NOT IN (
                      'CANCELLED',
                      'CANCELED',
                      'WITHDRAWN',
                      'TERMINATED',
                      'REVOKED'
                  )

            ORDER BY i.planned_start_date DESC
        """, university_id=WISE_UNIVERSITY_ID)

        rows = cursor.fetchall()
        cursor.close()

        trainings = []

        for row in rows:
            status_map = {
                "ONGOING": "مستمر",
                "NEAR_COMPLETION": "قريب من الإنجاز",
                "COMPLETED": "مكتمل",
                "LATE": "متأخر",
            }

            raw_status = row[10]
            status = status_map.get(raw_status, "مستمر")

            evaluation_received = row[11] is not None

            trainings.append({
                "internshipId": str(row[0]),
                "studentId": row[1],
                "studentName": row[2] or "—",
                "major": row[3] or "—",
                "company": row[4] or "—",
                "careerPath": row[5] or "—",
                "startDate": row[6] or "—",
                "endDate": row[7] or "—",
                "hours": _to_int(row[8]),
                "totalHours": _to_int(row[9]),
                "status": status,
                "evaluation": {
                    "status": "وصل" if evaluation_received else "لم يصل",
                    "overallRating": _to_int(row[12]),
                    "commitmentRating": _to_int(row[13]),
                    "notes": row[14] or "",
                    "date": row[15] or "",
                },
            })

        # 3. Calculate the four statistics.
        statistics = {
            "totalTrainings": len(trainings),
            "ongoingTrainings": sum(
                1 for t in trainings if t["status"] == "مستمر"
            ),
            "nearCompletionTrainings": sum(
                1 for t in trainings if t["status"] == "قريب من الإنجاز"
            ),
            "completedTrainings": sum(
                1 for t in trainings if t["status"] == "مكتمل"
            ),
        }

        return jsonify({
            "success": True,
            "data": {
                "statistics": statistics,
                "trainings": trainings,
            }
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university current trainings."
        )
        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to load current trainings.",
            500,
        )

    finally:
        if connection:
            connection.close()