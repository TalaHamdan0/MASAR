from flask import jsonify, request

from . import university_bp
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest


def _bearer_token():
    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    if not 20 <= len(parts[1]) <= 200:
        return None

    return parts[1]


def _error_response(code, message, status):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status


def _number_text(value):
    if value is None:
        return "0"

    number = float(value)

    if number.is_integer():
        return str(int(number))

    return f"{number:g}"


def _training_status(status):
    if status == "ACTIVE":
        return "مستمر"

    if status == "COMPLETED":
        return "مكتمل"

    if status == "CANCELLED":
        return "ملغي"

    if status == "LATE":
        return "متأخر"

    return "لم يبدأ"


def _account_status(status):
    statuses = {
        "ACTIVE": "نشط",
        "PENDING": "قيد التفعيل",
        "SUSPENDED": "موقوف",
        "INACTIVE": "غير نشط",
    }

    return statuses.get(status, status or "غير معروف")


@university_bp.get("/students")
def get_students():

    token = _bearer_token()

    if token is None:
        return _error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:

            # 1. Verify the university administrator session.
            cursor.execute("""
                SELECT us.university_staff_id
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

            admin_row = cursor.fetchone()

            if admin_row is None:
                return _error_response(
                    "invalid_session",
                    "انتهت الجلسة أو لم تعد صالحة. سجّلي الدخول مجددًا.",
                    401,
                )

            # 2. Get students with their latest internship.
            cursor.execute("""
                WITH ranked_internships AS (
                    SELECT
                        i.*,
                        ROW_NUMBER() OVER (
                            PARTITION BY i.student_id
                            ORDER BY
                                i.selected_at DESC,
                                i.internship_id DESC
                        ) AS rn
                    FROM internships i
                    WHERE i.university_id = :university_id
                ),
                latest_internship AS (
                    SELECT *
                    FROM ranked_internships
                    WHERE rn = 1
                )
                SELECT
                    s.student_id,
                    s.student_number,
                    u.full_name,
                    u.email,
                    u.phone_number,
                    u.account_status,
                    s.major,
                    cp.path_name,
                    li.internship_id,

                    CASE
                        WHEN li.internship_status = 'ACTIVE'
                         AND li.planned_end_date < TRUNC(SYSDATE)
                         AND NVL(ihs.completed_hours, 0) <
                             NVL(
                                 ihs.required_hours,
                                 NVL(
                                     li.required_hours,
                                     up.required_training_hours
                                 )
                             )
                        THEN 'LATE'

                        WHEN li.internship_status IS NOT NULL
                        THEN li.internship_status

                        ELSE 'NOT_STARTED'
                    END AS training_status,

                    NVL(ihs.completed_hours, 0) AS completed_hours,

                    NVL(
                        ihs.required_hours,
                        NVL(
                            li.required_hours,
                            up.required_training_hours
                        )
                    ) AS required_hours

                FROM students s

                JOIN users u
                    ON u.user_id = s.user_id

                LEFT JOIN career_paths cp
                    ON cp.career_path_id = s.career_path_id

                LEFT JOIN university_programs up
                    ON up.program_id = s.program_id
                   AND up.university_id = s.university_id

                LEFT JOIN latest_internship li
                    ON li.student_id = s.student_id

                LEFT JOIN internship_hours_summary ihs
                    ON ihs.internship_id = li.internship_id
                   AND ihs.student_id = s.student_id
                   AND ihs.university_id = s.university_id

                WHERE s.university_id = :university_id

                ORDER BY u.full_name
            """, university_id=WISE_UNIVERSITY_ID)

            student_rows = cursor.fetchall()

            students = []
            students_by_id = {}

            for row in student_rows:
                student_id = int(row[0])
                training_status_value = row[9]
                completed_hours = row[10] or 0
                required_hours = row[11] or 0

                student = {
                    "id": row[1],
                    "studentId": str(student_id),
                    "name": row[2],
                    "major": row[6] or "غير محدد",
                    "careerPath": row[7] or "غير محدد",
                    "trainingStatus": _training_status(training_status_value),
                    "hours": (
                        f"{_number_text(completed_hours)}/"
                        f"{_number_text(required_hours)}"
                    ),
                    "completedHours": float(completed_hours),
                    "requiredHours": float(required_hours),
                    "accountStatus": _account_status(row[5]),
                    "gpa": "—",
                    "email": row[3],
                    "phone": row[4] or "—",
                    "skills": [],
                    "certificates": [],
                    "projects": [],
                    "reports": 0,
                    "studentNumber": row[1],
                }

                students.append(student)
                students_by_id[student_id] = student

            # 3. Get student skills.
            cursor.execute("""
                SELECT
                    ss.student_id,
                    sk.skill_name
                FROM student_skills ss
                JOIN skills sk
                    ON sk.skill_id = ss.skill_id
                JOIN students s
                    ON s.student_id = ss.student_id
                WHERE s.university_id = :university_id
                ORDER BY ss.student_id, sk.skill_name
            """, university_id=WISE_UNIVERSITY_ID)

            for student_id, skill_name in cursor.fetchall():
                student = students_by_id.get(int(student_id))

                if student is not None:
                    student["skills"].append(skill_name)

            # 4. Get student certificates.
            cursor.execute("""
                SELECT
                    c.student_id,
                    c.certificate_title
                FROM certificates c
                JOIN students s
                    ON s.student_id = c.student_id
                WHERE s.university_id = :university_id
                ORDER BY c.student_id, c.certificate_title
            """, university_id=WISE_UNIVERSITY_ID)

            for student_id, certificate_title in cursor.fetchall():
                student = students_by_id.get(int(student_id))

                if student is not None:
                    student["certificates"].append(certificate_title)

            # 5. Get student projects.
            cursor.execute("""
                SELECT
                    p.student_id,
                    p.project_name
                FROM projects p
                JOIN students s
                    ON s.student_id = p.student_id
                WHERE s.university_id = :university_id
                ORDER BY p.student_id, p.project_name
            """, university_id=WISE_UNIVERSITY_ID)

            for student_id, project_name in cursor.fetchall():
                student = students_by_id.get(int(student_id))

                if student is not None:
                    student["projects"].append(project_name)

            # 6. Count weekly reports for each student.
            cursor.execute("""
                SELECT
                    i.student_id,
                    COUNT(wr.report_id)
                FROM internships i
                LEFT JOIN weekly_reports wr
                    ON wr.internship_id = i.internship_id
                WHERE i.university_id = :university_id
                GROUP BY i.student_id
            """, university_id=WISE_UNIVERSITY_ID)

            for student_id, report_count in cursor.fetchall():
                student = students_by_id.get(int(student_id))

                if student is not None:
                    student["reports"] = int(report_count or 0)

    # 7. Calculate statistics.
    total_students = len(students)

    active_students = sum(
        1 for student in students
        if student["accountStatus"] == "نشط"
    )

    training_students = sum(
        1 for student in students
        if student["trainingStatus"] in ("مستمر", "متأخر")
    )

    completed_students = sum(
        1 for student in students
        if student["trainingStatus"] == "مكتمل"
    )

    return jsonify({
        "data": {
            "statistics": {
                "totalStudents": total_students,
                "activeStudents": active_students,
                "trainingStudents": training_students,
                "completedStudents": completed_students,
            },
            "students": students,
        }
    })