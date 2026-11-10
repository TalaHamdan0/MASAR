
import re
import secrets

from flask import Blueprint, jsonify, request
from werkzeug.security import (
    check_password_hash,
    generate_password_hash,
)

from .database import get_connection
from .registration import error_response
from .repository import (
    WISE_UNIVERSITY_ID,
    create_session,
    read_student,
    token_digest,
)


authentication_bp = Blueprint("authentication", __name__)

_dummy_hash = generate_password_hash(secrets.token_urlsafe(32))


def bearer_token():
    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    if not 20 <= len(parts[1]) <= 200:
        return None

    return parts[1]


def session_user(cursor, token):
    cursor.execute("""
        SELECT u.user_id
        FROM auth_sessions a
        JOIN users u
            ON u.user_id = a.user_id
        JOIN roles r
            ON r.role_id = u.role_id
        JOIN students s
            ON s.user_id = u.user_id
        JOIN universities un
            ON un.university_id = s.university_id
        WHERE a.token_hash = :token_hash
          AND a.revoked_at IS NULL
          AND a.expires_at > LOCALTIMESTAMP
          AND u.account_status = 'ACTIVE'
          AND r.role_code = 'STUDENT'
          AND s.university_id = :university_id
          AND un.is_active = 1
    """,
        token_hash=token_digest(token),
        university_id=WISE_UNIVERSITY_ID,
    )

    row = cursor.fetchone()

    return int(row[0]) if row else None


@authentication_bp.post("/api/v1/auth/login")
def login():
    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return error_response(
            "invalid_json",
            "أرسلي بيانات الدخول بصيغة JSON.",
            400,
        )

    identifier = payload.get("identifier")
    password = payload.get("password")
    remember_me = payload.get("rememberMe", False)

    if (
        not isinstance(identifier, str)
        or not re.fullmatch(r"[0-9]{1,40}", identifier.strip())
    ):
        return error_response(
            "invalid_student_number",
            "أدخلي الرقم الجامعي، وليس البريد الإلكتروني.",
            422,
        )

    if (
        not isinstance(password, str)
        or not 8 <= len(password) <= 10
    ):
        return error_response(
            "invalid_password",
            "كلمة المرور يجب أن تكون من 8 إلى 10 خانات.",
            422,
        )

    if not isinstance(remember_me, bool):
        return error_response(
            "invalid_remember_me",
            "قيمة تذكرني غير صالحة.",
            422,
        )

    if (
        payload.get("universityId", str(WISE_UNIVERSITY_ID))
        != str(WISE_UNIVERSITY_ID)
    ):
        return error_response(
            "invalid_university",
            "الدخول متاح لجامعة العلوم الإسلامية العالمية فقط.",
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT
                    u.user_id,
                    u.password_hash,
                    u.account_status,
                    un.is_active
                FROM students s
                JOIN users u
                    ON u.user_id = s.user_id
                JOIN roles r
                    ON r.role_id = u.role_id
                JOIN universities un
                    ON un.university_id = s.university_id
                WHERE s.student_number = :student_number
                  AND s.university_id = :university_id
                  AND r.role_code = 'STUDENT'
            """,
                student_number=identifier.strip(),
                university_id=WISE_UNIVERSITY_ID,
            )

            row = cursor.fetchone()

            valid_password = check_password_hash(
                row[1] if row else _dummy_hash,
                password,
            )

            if not valid_password or row is None:
                return error_response(
                    "invalid_credentials",
                    "الرقم الجامعي أو كلمة المرور غير صحيحة.",
                    401,
                )

            if row[2] != "ACTIVE" or row[3] != 1:
                return error_response(
                    "account_unavailable",
                    "الحساب أو الجامعة غير مفعّل.",
                    403,
                )

            user_id = int(row[0])
            student = read_student(cursor, user_id)

            token, expires_in = create_session(
                cursor,
                user_id,
                remember_me,
            )

        connection.commit()

    return jsonify({
        "data": {
            "accessToken": token,
            "expiresIn": expires_in,
            "student": student,
        }
    })


@authentication_bp.get("/api/v1/auth/me")
def me():
    token = bearer_token()

    if token is None:
        return error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = session_user(cursor, token)

            if user_id is None:
                return error_response(
                    "invalid_session",
                    "انتهت الجلسة، سجّلي الدخول مجددًا.",
                    401,
                )

            student = read_student(cursor, user_id)

    return jsonify({
        "data": {
            "student": student,
        }
    })


@authentication_bp.post("/api/v1/auth/logout")
def logout():
    token = bearer_token()

    if token is None:
        return error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE auth_sessions
                SET revoked_at = LOCALTIMESTAMP
                WHERE token_hash = :token_hash
                  AND revoked_at IS NULL
            """, token_hash=token_digest(token))

        connection.commit()

    return jsonify({
        "data": {
            "message": "تم تسجيل الخروج.",
        }
    })


@authentication_bp.post("/api/v1/auth/change-password")
def change_password():
    token = bearer_token()

    if token is None:
        return error_response(
            "invalid_session",
            "سجّل الدخول أولًا.",
            401,
        )

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    current_password = payload.get("currentPassword")
    new_password = payload.get("newPassword")

    if not isinstance(current_password, str):
        return error_response(
            "invalid_current_password",
            "أدخل كلمة المرور الحالية.",
            422,
        )

    if not isinstance(new_password, str):
        return error_response(
            "invalid_new_password",
            "أدخل كلمة المرور الجديدة.",
            422,
        )

    if not 8 <= len(new_password) <= 10:
        return error_response(
            "invalid_new_password",
            "كلمة المرور الجديدة يجب أن تكون من 8 إلى 10 خانات.",
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user_id = session_user(cursor, token)

            if user_id is None:
                return error_response(
                    "invalid_session",
                    "انتهت الجلسة، سجّل الدخول مجددًا.",
                    401,
                )

            cursor.execute("""
                SELECT password_hash
                FROM users
                WHERE user_id = :user_id
                FOR UPDATE
            """, user_id=user_id)

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "account_not_found",
                    "الحساب غير موجود.",
                    404,
                )

            old_hash = row[0]

            if not check_password_hash(
                old_hash,
                current_password,
            ):
                return error_response(
                    "incorrect_current_password",
                    "كلمة المرور الحالية غير صحيحة.",
                    422,
                )

            if check_password_hash(
                old_hash,
                new_password,
            ):
                return error_response(
                    "same_password",
                    "كلمة المرور الجديدة يجب أن تختلف عن الحالية.",
                    422,
                )

            new_hash = generate_password_hash(new_password)

            cursor.execute("""
                UPDATE users
                SET password_hash = :password_hash
                WHERE user_id = :user_id
            """,
                password_hash=new_hash,
                user_id=user_id,
            )

            cursor.execute("""
                UPDATE auth_sessions
                SET revoked_at = LOCALTIMESTAMP
                WHERE user_id = :user_id
                  AND revoked_at IS NULL
                  AND token_hash <> :current_token_hash
            """,
                user_id=user_id,
                current_token_hash=token_digest(token),
            )

        connection.commit()

    return jsonify({
        "data": {
            "message": "تم تغيير كلمة المرور بنجاح.",
        }
    })
