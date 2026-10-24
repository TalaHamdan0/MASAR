import hashlib
import re
import secrets

import oracledb
from flask import Blueprint, jsonify, request
from werkzeug.security import generate_password_hash

from .database import get_connection


registration_bp = Blueprint("registration", __name__)


def error_response(code, message, status):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status


@registration_bp.post("/api/v1/auth/register")
def register():
    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return error_response(
            "invalid_json",
            "أرسلي بيانات الحساب بصيغة JSON.",
            400,
        )

    required_fields = (
        "name",
        "studentNumber",
        "universityId",
        "email",
        "password",
    )

    if any(
        not isinstance(payload.get(key), str)
        for key in required_fields
    ):
        return error_response(
            "invalid_fields",
            "بيانات إنشاء الحساب غير مكتملة.",
            422,
        )

    name = payload["name"].strip()
    student_number = payload["studentNumber"].strip()
    university_id_text = payload["universityId"].strip()
    email = payload["email"].strip().lower()
    password = payload["password"]

    if not 2 <= len(name) <= 200:
        return error_response(
            "invalid_name",
            "الاسم يجب أن يكون بين حرفين و200 حرف.",
            422,
        )

    if not re.fullmatch(r"[0-9]{1,40}", student_number):
        return error_response(
            "invalid_student_number",
            "الرقم الجامعي يجب أن يحتوي أرقامًا فقط وبحد أقصى 40 خانة.",
            422,
        )

    if not re.fullmatch(r"[1-9][0-9]{0,27}", university_id_text):
        return error_response(
            "invalid_university",
            "اختاري جامعة صالحة.",
            422,
        )

    if (
        len(email) > 254
        or not re.fullmatch(
            r"[^\s@]+@[^\s@]+\.[^\s@]+",
            email,
        )
    ):
        return error_response(
            "invalid_email",
            "أدخلي بريدًا إلكترونيًا صالحًا.",
            422,
        )

    if not 8 <= len(password) <= 10:
        return error_response(
            "invalid_password",
            "كلمة المرور يجب أن تكون من 8 إلى 10 خانات.",
            422,
        )

    university_id = int(university_id_text)
    password_hash = generate_password_hash(password)

    access_token = secrets.token_urlsafe(32)
    token_hash = hashlib.sha256(
        access_token.encode("utf-8")
    ).hexdigest()

    expires_in = 8 * 60 * 60

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT university_name
                    FROM universities
                    WHERE university_id = :university_id
                      AND is_active = 1
                """, university_id=university_id)

                university = cursor.fetchone()

                if university is None:
                    return error_response(
                        "invalid_university",
                        "الجامعة غير موجودة أو غير مفعّلة.",
                        422,
                    )

                cursor.execute("""
                    SELECT role_id
                    FROM roles
                    WHERE role_code = 'STUDENT'
                """)

                role = cursor.fetchone()

                if role is None:
                    return error_response(
                        "account_setup_missing",
                        "إعدادات حساب الطالب غير مكتملة في النظام.",
                        500,
                    )

                user_id_out = cursor.var(int)

                cursor.execute("""
                    INSERT INTO users (
                        full_name,
                        email,
                        password_hash,
                        account_status,
                        email_verified
                    )
                    VALUES (
                        :name,
                        :email,
                        :password_hash,
                        'ACTIVE',
                        0
                    )
                    RETURNING user_id INTO :user_id_out
                """,
                    name=name,
                    email=email,
                    password_hash=password_hash,
                    user_id_out=user_id_out,
                )

                user_id = int(user_id_out.getvalue()[0])
                student_id_out = cursor.var(int)

                cursor.execute("""
                    INSERT INTO students (
                        user_id,
                        university_id,
                        student_number,
                        profile_completed,
                        profile_version,
                        affiliation_status
                    )
                    VALUES (
                        :user_id,
                        :university_id,
                        :student_number,
                        0,
                        0,
                        'PENDING'
                    )
                    RETURNING student_id INTO :student_id_out
                """,
                    user_id=user_id,
                    university_id=university_id,
                    student_number=student_number,
                    student_id_out=student_id_out,
                )

                student_id = int(student_id_out.getvalue()[0])

                cursor.execute("""
                    INSERT INTO user_roles (
                        user_id,
                        role_id
                    )
                    VALUES (
                        :user_id,
                        :role_id
                    )
                """,
                    user_id=user_id,
                    role_id=role[0],
                )

                cursor.execute("""
                    INSERT INTO user_settings (user_id)
                    VALUES (:user_id)
                """, user_id=user_id)

                cursor.execute("""
                    INSERT INTO student_privacy_settings (
                        student_id
                    )
                    VALUES (:student_id)
                """, student_id=student_id)

                cursor.execute("""
                    INSERT INTO auth_sessions (
                        user_id,
                        token_hash,
                        remember_me,
                        created_at,
                        expires_at
                    )
                    VALUES (
                        :user_id,
                        :token_hash,
                        0,
                        LOCALTIMESTAMP,
                        LOCALTIMESTAMP
                            + NUMTODSINTERVAL(:expires_in, 'SECOND')
                    )
                """,
                    user_id=user_id,
                    token_hash=token_hash,
                    expires_in=expires_in,
                )

                response = jsonify({
                    "data": {
                        "accessToken": access_token,
                        "expiresIn": expires_in,
                        "student": {
                            "id": str(student_id),
                            "name": name,
                            "email": email,
                            "studentNumber": student_number,
                            "universityId": str(university_id),
                            "university": university[0],
                            "major": "",
                            "academicYear": "",
                            "gpa": "",
                            "careerPathId": None,
                            "profileCompleted": False,
                            "version": 0,
                            "skills": [],
                            "softSkills": [],
                            "certificates": [],
                            "projects": [],
                        },
                    }
                })

            connection.commit()

        return response, 201

    except oracledb.IntegrityError as error:
        details = error.args[0] if error.args else None

        if getattr(details, "code", None) == 1:
            return error_response(
                "account_exists",
                "البريد الإلكتروني مستخدم، أو الرقم الجامعي مسجّل في الجامعة المختارة.",
                409,
            )

        raise