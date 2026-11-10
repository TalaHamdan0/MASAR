
import hashlib
import hmac
import os
import re
import secrets

from flask import Blueprint, current_app, jsonify, request
from itsdangerous import BadSignature, URLSafeTimedSerializer
from werkzeug.security import check_password_hash, generate_password_hash

from .database import get_connection
from .registration import error_response
from .repository import WISE_UNIVERSITY_ID


password_reset_bp = Blueprint("password_reset", __name__)


def _secret():
    value = os.environ.get("MASAR_RESET_SECRET", "")
    if len(value) < 32:
        raise RuntimeError(
            "MASAR_RESET_SECRET must contain at least 32 characters"
        )
    return value


def _signer():
    return URLSafeTimedSerializer(
        _secret(),
        salt="masar-reset-v1",
    )


def _hash(user_id, code, salt):
    message = f"{user_id}:{salt}:{code}".encode("utf-8")
    return hmac.new(
        _secret().encode("utf-8"),
        message,
        hashlib.sha256,
    ).hexdigest()


def _matches(stored, user_id, code):
    try:
        salt, digest = stored.split(":", 1)
        return hmac.compare_digest(
            digest,
            _hash(user_id, code, salt),
        )
    except (AttributeError, TypeError, ValueError):
        return False


def _payload():
    value = request.get_json(silent=True)
    return value if isinstance(value, dict) else None


def _valid_email(email):
    return (
        isinstance(email, str)
        and len(email.strip()) <= 254
        and bool(
            re.fullmatch(
                r"[^@\s]+@[^@\s]+\.[^@\s]+",
                email.strip(),
            )
        )
    )


def _user_id(cursor, email):
    cursor.execute(
        """
        SELECT u.user_id
        FROM users u
        JOIN students s ON s.user_id = u.user_id
        JOIN roles r ON r.role_id = u.role_id
        JOIN universities un
          ON un.university_id = s.university_id
        WHERE LOWER(u.email) = :email
          AND u.account_status = 'ACTIVE'
          AND r.role_code = 'STUDENT'
          AND un.is_active = 1
          AND s.university_id = :university_id
        """,
        email=email,
        university_id=WISE_UNIVERSITY_ID,
    )
    row = cursor.fetchone()
    return int(row[0]) if row else None


def _lock_user(cursor, user_id):
    cursor.execute(
        """
        SELECT user_id
        FROM users
        WHERE user_id = :uid
        FOR UPDATE
        """,
        uid=user_id,
    )
    return cursor.fetchone() is not None


def _latest(cursor, user_id):
    cursor.execute(
        """
        SELECT reset_id, code_hash, expires_at,
               attempts, used_at
        FROM password_reset_codes
        WHERE user_id = :uid
        ORDER BY created_at DESC, reset_id DESC
        FETCH FIRST 1 ROW ONLY
        """,
        uid=user_id,
    )
    return cursor.fetchone()


def _valid(cursor, row):
    if row is None:
        return False

    if row[4] is not None or int(row[3]) >= 5:
        return False

    cursor.execute(
        """
        SELECT CASE
            WHEN :expiry > LOCALTIMESTAMP THEN 1
            ELSE 0
        END
        FROM dual
        """,
        expiry=row[2],
    )
    return cursor.fetchone()[0] == 1


def _generic():
    return jsonify({
        "data": {
            "message": (
                "إذا كان البريد مسجّلًا، "
                "تمت معالجة طلب الاستعادة."
            )
        }
    })


def _local_otp_enabled():
    return (
        current_app.debug
        and os.environ.get("MASAR_ENV") == "development"
        and os.environ.get("MASAR_DEV_SHOW_OTP") == "1"
        and request.remote_addr in ("127.0.0.1", "::1")
    )


@password_reset_bp.post("/api/v1/auth/forgot-password")
def forgot_password():
    data = _payload()

    if data is None:
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    email = data.get("email")

    if not _valid_email(email):
        return error_response(
            "invalid_email",
            "أدخل بريدًا إلكترونيًا صحيحًا.",
            422,
        )

    email = email.strip().lower()

    # Local development only. Real email delivery
    # must be configured before production.
    if not _local_otp_enabled():
        return error_response(
            "delivery_unavailable",
            "استعادة كلمة المرور غير متاحة حتى يتم إعداد البريد.",
            503,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            uid = _user_id(cursor, email)

            if uid is None:
                return _generic()

            if not _lock_user(cursor, uid):
                return _generic()

            # Allow one request per minute per account.
            cursor.execute(
                """
                SELECT CASE
                    WHEN MAX(created_at) >
                         LOCALTIMESTAMP - INTERVAL '60' SECOND
                    THEN 1
                    ELSE 0
                END
                FROM password_reset_codes
                WHERE user_id = :uid
                """,
                uid=uid,
            )

            if cursor.fetchone()[0] == 1:
                return _generic()

            code = f"{secrets.randbelow(1000000):06d}"
            salt = secrets.token_hex(12)
            digest = salt + ":" + _hash(uid, code, salt)

            # Invalidate previous codes.
            cursor.execute(
                """
                UPDATE password_reset_codes
                SET used_at = LOCALTIMESTAMP
                WHERE user_id = :uid
                  AND used_at IS NULL
                """,
                uid=uid,
            )

            cursor.execute(
                """
                INSERT INTO password_reset_codes
                (
                    user_id,
                    code_hash,
                    expires_at,
                    attempts,
                    created_at
                )
                VALUES
                (
                    :uid,
                    :digest,
                    LOCALTIMESTAMP + INTERVAL '5' MINUTE,
                    0,
                    LOCALTIMESTAMP
                )
                """,
                uid=uid,
                digest=digest,
            )

        connection.commit()

    # Print only to the local terminal.
    # Never log this code using app.logger.
    print(
        f"[MASAR LOCAL DEV OTP] {email}: {code}",
        flush=True,
    )

    return _generic()


@password_reset_bp.post("/api/v1/auth/verify-reset-code")
def verify_reset_code():
    data = _payload()

    if data is None:
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    email = data.get("email")
    code = data.get("code")

    if (
        not _valid_email(email)
        or not isinstance(code, str)
        or not re.fullmatch(r"[0-9]{6}", code)
    ):
        return error_response(
            "invalid_code",
            "رمز التحقق غير صالح.",
            422,
        )

    email = email.strip().lower()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            uid = _user_id(cursor, email)

            if uid is None:
                return error_response(
                    "invalid_code",
                    "الرمز غير صحيح أو انتهت صلاحيته.",
                    422,
                )

            if not _lock_user(cursor, uid):
                return error_response(
                    "invalid_code",
                    "الرمز غير صحيح أو انتهت صلاحيته.",
                    422,
                )

            row = _latest(cursor, uid)

            if not _valid(cursor, row):
                return error_response(
                    "invalid_code",
                    "الرمز غير صحيح أو انتهت صلاحيته.",
                    422,
                )

            if not _matches(row[1], uid, code):
                cursor.execute(
                    """
                    UPDATE password_reset_codes
                    SET attempts = attempts + 1
                    WHERE reset_id = :rid
                    """,
                    rid=int(row[0]),
                )
                connection.commit()

                return error_response(
                    "invalid_code",
                    "الرمز غير صحيح أو انتهت صلاحيته.",
                    422,
                )

            reset_token = _signer().dumps({
                "uid": uid,
                "rid": int(row[0]),
                "hash": row[1],
            })

    return jsonify({
        "data": {
            "resetToken": reset_token,
            "expiresIn": 300,
        }
    })


@password_reset_bp.post("/api/v1/auth/reset-password")
def reset_password():
    data = _payload()

    if data is None:
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    password = data.get("newPassword")
    token = data.get("resetToken")

    if (
        not isinstance(password, str)
        or not 8 <= len(password) <= 10
    ):
        return error_response(
            "invalid_new_password",
            "كلمة المرور من 8 إلى 10 خانات.",
            422,
        )

    if (
        not isinstance(token, str)
        or not token
        or len(token) > 2000
    ):
        return error_response(
            "invalid_reset_token",
            "جلسة الاستعادة غير صالحة.",
            422,
        )

    try:
        info = _signer().loads(
            token,
            max_age=300,
        )

        uid = int(info["uid"])
        rid = int(info["rid"])
        digest = info["hash"]

        if not isinstance(digest, str):
            raise ValueError("Invalid digest")

    except (BadSignature, ValueError, TypeError, KeyError):
        return error_response(
            "invalid_reset_token",
            "انتهت صلاحية الاستعادة. اطلب رمزًا جديدًا.",
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            if not _lock_user(cursor, uid):
                return error_response(
                    "invalid_reset_token",
                    "جلسة الاستعادة غير صالحة.",
                    422,
                )

            row = _latest(cursor, uid)

            if (
                not _valid(cursor, row)
                or int(row[0]) != rid
                or not hmac.compare_digest(row[1], digest)
            ):
                return error_response(
                    "invalid_reset_token",
                    "انتهت صلاحية الاستعادة. اطلب رمزًا جديدًا.",
                    422,
                )

            cursor.execute(
                """
                SELECT password_hash
                FROM users
                WHERE user_id = :uid
                """,
                uid=uid,
            )

            old_password = cursor.fetchone()

            if old_password is None:
                return error_response(
                    "invalid_reset_token",
                    "جلسة الاستعادة غير صالحة.",
                    422,
                )

            if check_password_hash(
                old_password[0],
                password,
            ):
                return error_response(
                    "same_password",
                    "كلمة المرور الجديدة يجب أن تختلف عن الحالية.",
                    422,
                )

            cursor.execute(
                """
                UPDATE users
                SET password_hash = :password_hash,
                    updated_at = LOCALTIMESTAMP
                WHERE user_id = :uid
                """,
                password_hash=generate_password_hash(password),
                uid=uid,
            )

            cursor.execute(
                """
                UPDATE password_reset_codes
                SET used_at = LOCALTIMESTAMP
                WHERE reset_id = :rid
                """,
                rid=rid,
            )

            # Revoke old login sessions.
            cursor.execute(
                """
                UPDATE auth_sessions
                SET revoked_at = LOCALTIMESTAMP
                WHERE user_id = :uid
                  AND revoked_at IS NULL
                """,
                uid=uid,
            )

        connection.commit()

    return jsonify({
        "data": {
            "message": "تمت إعادة تعيين كلمة المرور بنجاح."
        }
    })
