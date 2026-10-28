import re

import oracledb
from flask import Blueprint, jsonify, request
from werkzeug.security import generate_password_hash

from .database import get_connection
from .repository import (
    WISE_UNIVERSITY_ID,
    create_session,
    read_student,
)


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

    fields = (
        "name",
        "studentNumber",
        "universityId",
        "email",
        "password",
    )

    if not isinstance(payload, dict) or any(
        not isinstance(payload.get(key), str)
        for key in fields
    ):
        return error_response(
            "invalid_fields",
            "بيانات إنشاء الحساب غير مكتملة.",
            422,
        )

    name = payload["name"].strip()
    student_number = payload["studentNumber"].strip()
    university_id = payload["universityId"].strip()
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
            "أدخلي رقمًا جامعيًا صحيحًا من 1 إلى 40 رقمًا.",
            422,
        )

    if university_id != str(WISE_UNIVERSITY_ID):
        return error_response(
            "invalid_university",
            "التسجيل متاح لجامعة العلوم الإسلامية العالمية فقط.",
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

    if not 8 <= len(password) <= 10 or not password.strip():
        return error_response(
            "invalid_password",
            "كلمة المرور يجب أن تكون من 8 إلى 10 خانات.",
            422,
        )

    password_hash = generate_password_hash(password)

    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT university_id
                    FROM universities
                    WHERE university_id = :university_id
                      AND is_active = 1
                """, university_id=WISE_UNIVERSITY_ID)

                if cursor.fetchone() is None:
                    return error_response(
                        "university_unavailable",
                        "التسجيل في الجامعة غير متاح حاليًا.",
                        503,
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
                        "إعدادات حساب الطالب غير مكتملة.",
                        503,
                    )

                user_id_out = cursor.var(int)

                cursor.execute("""
                    INSERT INTO users (
                        full_name,
                        email,
                        password_hash,
                        role_id
                    )
                    VALUES (
                        :name,
                        :email,
                        :password_hash,
                        :role_id
                    )
                    RETURNING user_id INTO :user_id_out
                """,
                    name=name,
                    email=email,
                    password_hash=password_hash,
                    role_id=int(role[0]),
                    user_id_out=user_id_out,
                )

                user_id = int(user_id_out.getvalue()[0])

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
                """,
                    user_id=user_id,
                    university_id=WISE_UNIVERSITY_ID,
                    student_number=student_number,
                )

                student = read_student(cursor, user_id)
                token, expires_in = create_session(
                    cursor,
                    user_id,
                )

            connection.commit()

        return jsonify({
            "data": {
                "accessToken": token,
                "expiresIn": expires_in,
                "student": student,
            }
        }), 201

    except oracledb.IntegrityError as error:
        details = error.args[0] if error.args else None

        if getattr(details, "code", None) == 1:
            return error_response(
                "account_exists",
                "البريد الإلكتروني أو الرقم الجامعي مستخدم بالفعل.",
                409,
            )

        raise