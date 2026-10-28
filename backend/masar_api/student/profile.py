import re
from datetime import date
from urllib.parse import urlsplit

import oracledb
from flask import current_app, jsonify, request

from . import student_bp
from ..authentication import bearer_token, session_user
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, read_student


class ProfileError(Exception):
    def __init__(
        self,
        message,
        status=422,
        code="invalid_profile",
    ):
        super().__init__(message)
        self.message = message
        self.status = status
        self.code = code


@student_bp.errorhandler(ProfileError)
def handle_profile_error(error):
    return jsonify({
        "error": {
            "code": error.code,
            "message": error.message,
        }
    }), error.status


@student_bp.errorhandler(oracledb.Error)
def handle_profile_database_error(error):
    details = error.args[0] if error.args else None
    error_code = getattr(details, "full_code", None)

    if not error_code:
        number = getattr(details, "code", None)

        error_code = (
            f"ORA-{number:05d}"
            if isinstance(number, int)
            else "DATABASE_ERROR"
        )

    current_app.logger.exception(
        "Profile database operation failed: %s",
        error_code,
    )

    return jsonify({
        "error": {
            "code": "profile_database_error",
            "message": (
                "تعذر إكمال عملية الملف الشخصي. "
                f"رمز الخطأ: {error_code}"
            ),
        }
    }), 500


def _text(value, label, maximum, required=True):
    if value is None and not required:
        return ""

    if not isinstance(value, str):
        raise ProfileError(f"قيمة {label} غير صالحة.")

    value = value.strip()

    if required and not value:
        raise ProfileError(f"يرجى إدخال {label}.")

    if len(value) > maximum:
        raise ProfileError(
            f"{label}: الحد الأقصى {maximum} حرفًا."
        )

    return value


def _english_name(value):
    value = _text(value, "الاسم بالإنجليزي", 200)

    if not re.fullmatch(r"[A-Za-z][A-Za-z .'-]*", value):
        raise ProfileError(
            "اكتبي الاسم بحروف إنجليزية فقط."
        )

    if sum(character.isalpha() for character in value) < 2:
        raise ProfileError(
            "أدخلي اسمًا إنجليزيًا صحيحًا."
        )

    return " ".join(value.split())


def _id(value, label, optional=False):
    if optional and (value is None or value == ""):
        return None

    if type(value) is int:
        value = str(value)

    if (
        not isinstance(value, str)
        or not re.fullmatch(r"[1-9][0-9]{0,27}", value)
    ):
        raise ProfileError(f"رقم {label} غير صالح.")

    return int(value)


def _items(payload, key):
    items = payload.get(key)

    if not isinstance(items, list) or len(items) > 100:
        raise ProfileError(
            f"قائمة {key} غير صالحة أو تتجاوز 100 عنصر."
        )

    if any(not isinstance(item, dict) for item in items):
        raise ProfileError(
            f"بيانات قائمة {key} غير صالحة."
        )

    return items


def _skills(items):
    result = {}

    for item in items:
        skill_id = _id(item.get("id"), "المهارة")
        level = item.get("level")

        if level is not None and (
            type(level) is not int
            or not 0 <= level <= 100
        ):
            raise ProfileError(
                "مستوى المهارة يجب أن يكون بين 0 و100."
            )

        if skill_id in result:
            raise ProfileError(
                "لا تضيفي المهارة نفسها أكثر من مرة."
            )

        result[skill_id] = level

    return result


def _certificates(items):
    result = []
    ids = set()

    for item in items:
        certificate_id = _id(
            item.get("id"),
            "الشهادة",
            optional=True,
        )

        if certificate_id is not None:
            if certificate_id in ids:
                raise ProfileError(
                    "توجد شهادة مكررة في الطلب."
                )

            ids.add(certificate_id)

        issue_date_text = _text(
            item.get("date"),
            "تاريخ الشهادة",
            10,
            required=False,
        )

        issue_date = None

        if issue_date_text:
            try:
                issue_date = date.fromisoformat(issue_date_text)

                if issue_date.isoformat() != issue_date_text:
                    raise ValueError()

            except ValueError:
                raise ProfileError(
                    "تاريخ الشهادة يجب أن يكون بصيغة YYYY-MM-DD."
                )

        result.append({
            "id": certificate_id,
            "title": _text(
                item.get("title"),
                "اسم الشهادة",
                200,
            ),
            "issuer": _text(
                item.get("issuer"),
                "الجهة المانحة",
                200,
            ),
            "issue_date": issue_date,
        })

    return result


def _projects(items):
    result = []
    ids = set()

    for item in items:
        project_id = _id(
            item.get("id"),
            "المشروع",
            optional=True,
        )

        if project_id is not None:
            if project_id in ids:
                raise ProfileError(
                    "يوجد مشروع مكرر في الطلب."
                )

            ids.add(project_id)

        url = _text(
            item.get("githubUrl"),
            "رابط GitHub",
            500,
            required=False,
        )

        if url:
            try:
                parts = urlsplit(url)

                valid = (
                    parts.scheme == "https"
                    and parts.hostname in (
                        "github.com",
                        "www.github.com",
                    )
                    and not parts.username
                    and not parts.password
                )

            except ValueError:
                valid = False

            if not valid:
                raise ProfileError(
                    "أدخلي رابط GitHub صحيحًا يبدأ بـ "
                    "https://github.com/."
                )

        technologies = item.get("technologies")

        if (
            not isinstance(technologies, list)
            or len(technologies) > 50
        ):
            raise ProfileError(
                "كل مشروع يسمح بإضافة 50 تقنية كحد أقصى."
            )

        names = []
        seen = set()

        for value in technologies:
            name = _text(value, "اسم التقنية", 120)

            if name.casefold() not in seen:
                names.append(name)
                seen.add(name.casefold())

        result.append({
            "id": project_id,
            "name": _text(
                item.get("name"),
                "اسم المشروع",
                200,
            ),
            "description": _text(
                item.get("description"),
                "وصف المشروع",
                2000,
            ),
            "github_url": url or None,
            "technologies": names,
        })

    return result


def _payload():
    if request.content_length and request.content_length > 2_000_000:
        raise ProfileError(
            "حجم بيانات الملف كبير جدًا.",
            413,
        )

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        raise ProfileError(
            "أرسلي بيانات الملف بصيغة JSON.",
            400,
        )

    version = payload.get("version")

    if type(version) is not int or version < 0:
        raise ProfileError("نسخة الملف غير صالحة.")

    technical = _skills(_items(payload, "skills"))
    soft = _skills(_items(payload, "softSkills"))

    if set(technical) & set(soft):
        raise ProfileError(
            "لا يمكن تكرار المهارة بين القائمتين."
        )

    return {
        "version": version,
        "name_en": (
            _english_name(payload["nameEn"])
            if "nameEn" in payload
            else None
        ),
        "program_id": _id(
            payload.get("programId"),
            "التخصص",
        ),
        "academic_year": _text(
            payload.get("academicYear"),
            "السنة الدراسية",
            50,
        ),
        "technical": technical,
        "soft": soft,
        "certificates": _certificates(
            _items(payload, "certificates")
        ),
        "projects": _projects(
            _items(payload, "projects")
        ),
    }


def _require_token():
    token = bearer_token()

    if token is None:
        raise ProfileError(
            "سجّلي الدخول أولًا.",
            401,
            "invalid_session",
        )

    return token


def _require_user(cursor, token):
    user_id = session_user(cursor, token)

    if user_id is None:
        raise ProfileError(
            "انتهت الجلسة، سجّلي الدخول مجددًا.",
            401,
            "invalid_session",
        )

    return user_id


@student_bp.get("/me")
def get_my_profile():
    token = _require_token()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)
            student = read_student(cursor, user_id)

    return jsonify({"data": student})


@student_bp.get("/profile-options")
def get_profile_options():
    token = _require_token()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            _require_user(cursor, token)

            cursor.execute("""
                SELECT
                    program_id,
                    program_name,
                    required_training_hours
                FROM university_programs
                WHERE university_id = :university_id
                  AND is_active = 1
                ORDER BY program_name
            """, university_id=WISE_UNIVERSITY_ID)

            programs = [
                {
                    "id": str(row[0]),
                    "name": row[1],
                    "requiredTrainingHours": (
                        float(row[2])
                        if row[2] is not None
                        else None
                    ),
                }
                for row in cursor.fetchall()
            ]

            cursor.execute("""
                SELECT
                    skill_id,
                    skill_name,
                    skill_type
                FROM skills
                WHERE is_active = 1
                ORDER BY skill_name
            """)

            skills = [
                {
                    "id": str(row[0]),
                    "name": row[1],
                    "type": row[2],
                }
                for row in cursor.fetchall()
            ]

    return jsonify({
        "data": {
            "programs": programs,
            "skills": skills,
        }
    })


def _save_skills(cursor, student_id, data, skill_catalog):
    for key, expected_type in (
        ("technical", "TECHNICAL"),
        ("soft", "SOFT"),
    ):
        for skill_id in data[key]:
            if (
                skill_catalog.get(skill_id, {}).get("type")
                != expected_type
            ):
                raise ProfileError(
                    "إحدى المهارات غير متاحة أو لا تنتمي "
                    "إلى القائمة الصحيحة."
                )

    cursor.execute("""
        DELETE FROM student_skills
        WHERE student_id = :student_id
    """, student_id=student_id)

    combined = data["technical"] | data["soft"]

    for skill_id, level in combined.items():
        cursor.execute("""
            INSERT INTO student_skills (
                student_id,
                skill_id,
                self_reported_level
            )
            VALUES (
                :student_id,
                :skill_id,
                :skill_level
            )
        """,
            student_id=student_id,
            skill_id=skill_id,
            skill_level=level,
        )


def _save_certificates(cursor, student_id, items):
    cursor.execute("""
        SELECT certificate_id
        FROM certificates
        WHERE student_id = :student_id
    """, student_id=student_id)

    existing = {
        int(row[0])
        for row in cursor.fetchall()
    }

    submitted = {
        item["id"]
        for item in items
        if item["id"] is not None
    }

    if not submitted <= existing:
        raise ProfileError(
            "إحدى الشهادات لا تخص هذا الملف. "
            "حمّلي أحدث نسخة."
        )

    for certificate_id in existing - submitted:
        cursor.execute("""
            DELETE FROM certificates
            WHERE certificate_id = :id
              AND student_id = :student_id
        """,
            id=certificate_id,
            student_id=student_id,
        )

    for item in items:
        params = {
            "student_id": student_id,
            "title": item["title"],
            "issuer": item["issuer"],
            "issue_date": item["issue_date"],
        }

        if item["id"] is None:
            cursor.execute("""
                INSERT INTO certificates (
                    student_id,
                    certificate_title,
                    issuer,
                    issue_date
                )
                VALUES (
                    :student_id,
                    :title,
                    :issuer,
                    :issue_date
                )
            """, **params)

        else:
            cursor.execute("""
                UPDATE certificates
                SET certificate_title = :title,
                    issuer = :issuer,
                    issue_date = :issue_date,
                    updated_at = LOCALTIMESTAMP
                WHERE certificate_id = :id
                  AND student_id = :student_id
            """, id=item["id"], **params)


def _save_projects(cursor, student_id, items, skill_catalog):
    cursor.execute("""
        SELECT project_id
        FROM projects
        WHERE student_id = :student_id
    """, student_id=student_id)

    existing = {
        int(row[0])
        for row in cursor.fetchall()
    }

    submitted = {
        item["id"]
        for item in items
        if item["id"] is not None
    }

    if not submitted <= existing:
        raise ProfileError(
            "أحد المشاريع لا يخص هذا الملف. "
            "حمّلي أحدث نسخة."
        )

    for project_id in existing - submitted:
        cursor.execute("""
            DELETE FROM project_technologies
            WHERE project_id = :id
        """, id=project_id)

        cursor.execute("""
            DELETE FROM projects
            WHERE project_id = :id
              AND student_id = :student_id
        """,
            id=project_id,
            student_id=student_id,
        )

    name_matches = {}

    for skill_id, skill in skill_catalog.items():
        if skill["type"] == "TECHNICAL":
            name_matches.setdefault(
                skill["name"].casefold(),
                [],
            ).append(skill_id)

    for item in items:
        description_lob = cursor.connection.createlob(
            oracledb.DB_TYPE_CLOB,
            item["description"],
        )

        params = {
            "student_id": student_id,
            "name": item["name"],
            "description": description_lob,
            "github_url": item["github_url"],
        }

        try:
            if item["id"] is None:
                project_id_out = cursor.var(int)

                cursor.execute("""
                    INSERT INTO projects (
                        student_id,
                        project_name,
                        description,
                        github_url
                    )
                    VALUES (
                        :student_id,
                        :name,
                        :description,
                        :github_url
                    )
                    RETURNING project_id INTO :project_id_out
                """,
                    project_id_out=project_id_out,
                    **params,
                )

                project_id = int(
                    project_id_out.getvalue()[0]
                )

            else:
                project_id = item["id"]

                cursor.execute("""
                    UPDATE projects
                    SET project_name = :name,
                        description = :description,
                        github_url = :github_url,
                        updated_at = LOCALTIMESTAMP
                    WHERE project_id = :id
                      AND student_id = :student_id
                """, id=project_id, **params)

                cursor.execute("""
                    DELETE FROM project_technologies
                    WHERE project_id = :id
                """, id=project_id)

        finally:
            description_lob.close()

        for name in item["technologies"]:
            matches = name_matches.get(
                name.casefold(),
                [],
            )

            skill_id = (
                matches[0]
                if len(matches) == 1
                else None
            )

            cursor.execute("""
                INSERT INTO project_technologies (
                    project_id,
                    technology_name,
                    skill_id
                )
                VALUES (
                    :project_id,
                    :name,
                    :skill_id
                )
            """,
                project_id=project_id,
                name=name,
                skill_id=skill_id,
            )


@student_bp.put("/me/profile")
def save_my_profile():
    token = _require_token()
    data = _payload()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = _require_user(cursor, token)

            cursor.execute("""
                SELECT
                    student_id,
                    profile_version
                FROM students
                WHERE user_id = :user_id
                FOR UPDATE
            """, user_id=user_id)

            row = cursor.fetchone()

            if row is None:
                raise ProfileError(
                    "ملف الطالب غير موجود.",
                    404,
                )

            student_id = int(row[0])
            version = int(row[1])

            if version != data["version"]:
                current_app.logger.warning(
                    "Profile version conflict: "
                    "student_id=%s submitted_version=%s "
                    "current_version=%s",
                    student_id,
                    data["version"],
                    version,
                )

                raise ProfileError(
                    f"نسخة الشاشة: {data['version']}، "
                    f"نسخة قاعدة البيانات: {version}.",
                    409,
                    "profile_conflict",
                )

            cursor.execute("""
                SELECT program_name
                FROM university_programs
                WHERE program_id = :program_id
                  AND university_id = :university_id
                  AND is_active = 1
            """,
                program_id=data["program_id"],
                university_id=WISE_UNIVERSITY_ID,
            )

            program = cursor.fetchone()

            if program is None:
                raise ProfileError(
                    "اختاري تخصصًا مفعّلًا من تخصصات الجامعة."
                )

            cursor.execute("""
                SELECT
                    skill_id,
                    skill_name,
                    skill_type
                FROM skills
                WHERE is_active = 1
            """)

            skill_catalog = {
                int(row[0]): {
                    "name": row[1],
                    "type": row[2],
                }
                for row in cursor.fetchall()
            }

            _save_skills(
                cursor,
                student_id,
                data,
                skill_catalog,
            )

            _save_certificates(
                cursor,
                student_id,
                data["certificates"],
            )

            _save_projects(
                cursor,
                student_id,
                data["projects"],
                skill_catalog,
            )

            cursor.execute("""
                UPDATE students
                SET program_id = :program_id,
                    major = :major,
                    academic_year = :academic_year,
                    profile_completed = 1,
                    profile_version = profile_version + 1,
                    updated_at = LOCALTIMESTAMP
                WHERE student_id = :student_id
            """,
                program_id=data["program_id"],
                major=program[0],
                academic_year=data["academic_year"],
                student_id=student_id,
            )

            if data["name_en"] is not None:
                cursor.execute("""
                    UPDATE users
                    SET full_name_en = :name_en,
                        updated_at = LOCALTIMESTAMP
                    WHERE user_id = :user_id
                """,
                    name_en=data["name_en"],
                    user_id=user_id,
                )

            student = read_student(cursor, user_id)

        connection.commit()

    return jsonify({"data": student})