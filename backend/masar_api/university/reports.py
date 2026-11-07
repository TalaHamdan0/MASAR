
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


@university_bp.get("/reports")
def get_university_reports():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "UNAUTHORIZED",
            "Authentication token is required.",
            401,
        )

    # Selected period
    period = request.args.get("period", "this_month")

    # Semester start date based on the academic calendar.
    semester_start = """
        CASE
            WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) >= 9
                THEN ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 8)
            WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) >= 2
                THEN ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 1)
            ELSE ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), -4)
        END
    """

    # Date conditions for each period.
    period_conditions = {
        "this_week": """
            i.planned_start_date < TRUNC(SYSDATE, 'IW') + 7
            AND i.planned_end_date >= TRUNC(SYSDATE, 'IW')
        """,

        "this_month": """
            i.planned_start_date < ADD_MONTHS(
                TRUNC(SYSDATE, 'MM'), 1
            )
            AND i.planned_end_date >= TRUNC(SYSDATE, 'MM')
        """,

        "this_semester": f"""
            i.planned_start_date < ADD_MONTHS(
                ({semester_start}), 5
            )
            AND i.planned_end_date >= ({semester_start})
        """,

        "this_year": """
            i.planned_start_date < ADD_MONTHS(
                TRUNC(SYSDATE, 'YYYY'), 12
            )
            AND i.planned_end_date >= TRUNC(SYSDATE, 'YYYY')
        """,
    }

    # Use this month if the received period is not recognized.
    date_condition = period_conditions.get(
        period,
        period_conditions["this_month"],
    )

    connection = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        # 1. Verify the university administrator session.
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

        # Common query used by the reports below.
        # It includes only internships belonging to this university
        # and overlapping with the selected period.
        base_filter = f"""
            FROM internships i

            JOIN students s
                ON s.student_id = i.student_id

            JOIN companies c
                ON c.company_id = i.company_id

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

              AND {date_condition}
        """

        # 2. Main statistics.
        cursor.execute(f"""
            SELECT
                COUNT(DISTINCT i.student_id),

                ROUND(
                    NVL(
                        AVG(
                            NVL(
                                hs.completion_percentage,
                                CASE
                                    WHEN i.required_hours > 0
                                    THEN LEAST(
                                        (
                                            NVL(hs.completed_hours, 0)
                                            / i.required_hours
                                        ) * 100,
                                        100
                                    )
                                    ELSE 0
                                END
                            )
                        ),
                        0
                    )
                ),

                COUNT(
                    DISTINCT CASE
                        WHEN NVL(hs.completed_hours, 0) >= 280
                        THEN i.student_id
                    END
                ),

                ROUND(
                    NVL(
                        AVG(NVL(hs.completed_hours, 0)),
                        0
                    )
                )

            {base_filter}
        """,
            university_id=WISE_UNIVERSITY_ID,
        )

        stats_row = cursor.fetchone()

        total_students = int(stats_row[0] or 0)
        completion_rate = int(stats_row[1] or 0)
        completed_280_hours = int(stats_row[2] or 0)
        average_hours = int(stats_row[3] or 0)

        # 3. Students grouped by completed training hours.
        cursor.execute(f"""
            SELECT
                COUNT(
                    DISTINCT CASE
                        WHEN NVL(hs.completed_hours, 0) < 100
                        THEN i.student_id
                    END
                ),

                COUNT(
                    DISTINCT CASE
                        WHEN NVL(hs.completed_hours, 0) >= 100
                         AND NVL(hs.completed_hours, 0) < 200
                        THEN i.student_id
                    END
                ),

                COUNT(
                    DISTINCT CASE
                        WHEN NVL(hs.completed_hours, 0) >= 200
                         AND NVL(hs.completed_hours, 0) < 280
                        THEN i.student_id
                    END
                ),

                COUNT(
                    DISTINCT CASE
                        WHEN NVL(hs.completed_hours, 0) >= 280
                        THEN i.student_id
                    END
                )

            {base_filter}
        """,
            university_id=WISE_UNIVERSITY_ID,
        )

        hours_row = cursor.fetchone()

        hour_categories = [
            ("أقل من 100 ساعة", int(hours_row[0] or 0)),
            ("100 - 200 ساعة", int(hours_row[1] or 0)),
            ("200 - 279 ساعة", int(hours_row[2] or 0)),
            ("280 ساعة أو أكثر", int(hours_row[3] or 0)),
        ]

        hours_overview = []

        for label, count in hour_categories:
            ratio = (
                count / total_students
                if total_students > 0
                else 0
            )

            hours_overview.append({
                "title": label,
                "count": count,
                "ratio": round(ratio, 4),
            })

        # 4. Top four companies by number of trainees.
        cursor.execute(f"""
            SELECT
                c.company_name,
                COUNT(DISTINCT i.student_id) AS trainee_count

            {base_filter}

            GROUP BY
                c.company_id,
                c.company_name

            ORDER BY
                trainee_count DESC,
                c.company_name

            FETCH FIRST 4 ROWS ONLY
        """,
            university_id=WISE_UNIVERSITY_ID,
        )

        company_rows = cursor.fetchall()

        company_report = []

        for row in company_rows:
            trainee_count = int(row[1] or 0)

            ratio = (
                trainee_count / total_students
                if total_students > 0
                else 0
            )

            company_report.append({
                "name": row[0],
                "students": trainee_count,
                "ratio": round(ratio, 4),
            })

        cursor.close()

        # 5. Return all report data.
        return jsonify({
            "success": True,
            "data": {
                "statistics": {
                    "studentsInTraining": total_students,
                    "completionRate": completion_rate,
                    "completed280Hours": completed_280_hours,
                    "averageHours": average_hours,
                },

                "hoursOverview": hours_overview,

                "companyReport": company_report,
            }
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university reports."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to load reports.",
            500,
        )

    finally:
        if connection:
            connection.close()
