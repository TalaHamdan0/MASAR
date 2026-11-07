import re

from flask import jsonify, request

from . import university_bp

from ..database import get_connection

from ..registration import error_response

from ..repository import (
    WISE_UNIVERSITY_ID,
    create_session,
    token_digest,
)


# --------------------------------------------------
# 1. Get Token from Authorization Header
# --------------------------------------------------

def get_bearer_token():

    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    token = parts[1]

    if not 20 <= len(token) <= 200:
        return None

    return token


# --------------------------------------------------
# 2. Get Active University Administrator Session
# --------------------------------------------------

def find_university_admin_session(cursor, token):

    cursor.execute("""
        SELECT
            U.USER_ID,
            S.UNIVERSITY_STAFF_ID,
            U.FULL_NAME,
            U.EMAIL,
            S.EMPLOYEE_NUMBER,
            S.STAFF_ROLE,
            S.UNIVERSITY_ID,
            UN.UNIVERSITY_NAME,
            R.ROLE_CODE

        FROM AUTH_SESSIONS A

        JOIN USERS U
            ON U.USER_ID = A.USER_ID

        JOIN UNIVERSITY_STAFF S
            ON S.USER_ID = U.USER_ID

        JOIN ROLES R
            ON R.ROLE_ID = U.ROLE_ID

        JOIN UNIVERSITIES UN
            ON UN.UNIVERSITY_ID = S.UNIVERSITY_ID

        WHERE A.TOKEN_HASH = :token_hash
          AND A.REVOKED_AT IS NULL
          AND A.EXPIRES_AT > LOCALTIMESTAMP
          AND U.ACCOUNT_STATUS = 'ACTIVE'
          AND S.IS_ACTIVE = 1
          AND S.STAFF_ROLE = 'ADMIN'
          AND R.ROLE_CODE = 'UNIVERSITY_ADMIN'
          AND S.UNIVERSITY_ID = :university_id
          AND UN.IS_ACTIVE = 1

    """,
        token_hash=token_digest(token),
        university_id=WISE_UNIVERSITY_ID,
    )

    return cursor.fetchone()


# --------------------------------------------------
# 3. Format University Staff Information
# --------------------------------------------------

def university_staff_response(row):

    return {
        "userId": str(row[0]),
        "staffId": str(row[1]),
        "name": row[2],
        "email": row[3],
        "employeeNumber": row[4],
        "staffRole": row[5],
        "universityId": str(row[6]),
        "university": row[7],
        "roleCode": row[8],
    }


# --------------------------------------------------
# 4. University Login
# --------------------------------------------------

@university_bp.post("/auth/login")
def university_login():

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return error_response(
            "invalid_json",
            "أرسلي الرقم الوظيفي بصيغة JSON.",
            400,
        )

    identifier = payload.get("identifier")

    if (
        not isinstance(identifier, str)
        or not re.fullmatch(r"[0-9]{1,160}", identifier.strip())
    ):
        return error_response(
            "invalid_employee_number",
            "أدخلي رقمًا وظيفيًا صحيحًا.",
            422,
        )

    with get_connection() as connection:

        with connection.cursor() as cursor:

            cursor.execute("""
                SELECT
                    U.USER_ID,
                    S.UNIVERSITY_STAFF_ID,
                    U.FULL_NAME,
                    U.EMAIL,
                    S.EMPLOYEE_NUMBER,
                    S.STAFF_ROLE,
                    S.UNIVERSITY_ID,
                    UN.UNIVERSITY_NAME,
                    R.ROLE_CODE

                FROM UNIVERSITY_STAFF S

                JOIN USERS U
                    ON U.USER_ID = S.USER_ID

                JOIN ROLES R
                    ON R.ROLE_ID = U.ROLE_ID

                JOIN UNIVERSITIES UN
                    ON UN.UNIVERSITY_ID = S.UNIVERSITY_ID

                WHERE S.EMPLOYEE_NUMBER = :employee_number
                  AND S.UNIVERSITY_ID = :university_id
                  AND S.IS_ACTIVE = 1
                  AND S.STAFF_ROLE = 'ADMIN'
                  AND U.ACCOUNT_STATUS = 'ACTIVE'
                  AND R.ROLE_CODE = 'UNIVERSITY_ADMIN'
                  AND UN.IS_ACTIVE = 1

            """,
                employee_number=identifier.strip(),
                university_id=WISE_UNIVERSITY_ID,
            )

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "invalid_employee_number",
                    "الرقم الوظيفي غير موجود أو الحساب غير مفعّل.",
                    401,
                )

            user_id = int(row[0])

            token, expires_in = create_session(
                cursor,
                user_id,
            )

        connection.commit()

    return jsonify({
        "data": {
            "accessToken": token,
            "expiresIn": expires_in,
            "universityStaff": university_staff_response(row),
        }
    })


# --------------------------------------------------
# 5. Get Current University Administrator
# --------------------------------------------------

@university_bp.get("/auth/me")
def university_me():

    token = get_bearer_token()

    if token is None:
        return error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:

        with connection.cursor() as cursor:

            row = find_university_admin_session(
                cursor,
                token,
            )

    if row is None:
        return error_response(
            "invalid_session",
            "انتهت الجلسة أو لم تعد صالحة. سجّلي الدخول مجددًا.",
            401,
        )

    return jsonify({
        "data": {
            "universityStaff": university_staff_response(row),
        }
    })


# --------------------------------------------------
# 6. University Logout
# --------------------------------------------------

@university_bp.post("/auth/logout")
def university_logout():

    token = get_bearer_token()

    if token is None:
        return error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:

        with connection.cursor() as cursor:

            row = find_university_admin_session(
                cursor,
                token,
            )

            if row is None:
                return error_response(
                    "invalid_session",
                    "الجلسة غير صالحة أو انتهت.",
                    401,
                )

            cursor.execute("""
                UPDATE AUTH_SESSIONS
                SET REVOKED_AT = LOCALTIMESTAMP
                WHERE TOKEN_HASH = :token_hash
                  AND REVOKED_AT IS NULL
            """,
                token_hash=token_digest(token),
            )

        connection.commit()

    return jsonify({
        "data": {
            "message": "تم تسجيل الخروج.",
        }
    })