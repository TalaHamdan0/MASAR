from flask import jsonify, request, current_app

from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest
from . import university_bp


UNIVERSITY_NAME = "جامعة العلوم الإسلامية العالمية"


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


def _get_admin_settings_row(cursor, token):
    cursor.execute("""
        SELECT
            u.user_id,
            u.full_name,
            us.employee_number,
            u.language_code,
            u.theme_mode,
            u.application_notifications_enabled,
            u.report_notifications_enabled,
            u.training_notifications_enabled

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


@university_bp.get("/settings")
def get_university_settings():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "UNAUTHORIZED",
            "Authentication token is required.",
            401,
        )

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        row = _get_admin_settings_row(cursor, token)

        if row is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        return jsonify({
            "success": True,
            "data": {
                "profile": {
                    "fullName": row[1] or "—",
                    "staffNumber": str(row[2]) if row[2] is not None else "—",
                    "universityName": UNIVERSITY_NAME,
                },
                "preferences": {
                    "languageCode": row[3] or "ar",
                    "themeMode": row[4] or "LIGHT",
                    "applicationNotifications": int(row[5] or 0) == 1,
                    "reportNotifications": int(row[6] or 0) == 1,
                    "trainingNotifications": int(row[7] or 0) == 1,
                },
            }
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university settings."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to load settings.",
            500,
        )

    finally:
        if cursor:
            cursor.close()

        if connection:
            connection.close()


@university_bp.patch("/settings/notifications")
def update_university_notification_settings():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "UNAUTHORIZED",
            "Authentication token is required.",
            401,
        )

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict) or not payload:
        return _error_response(
            "INVALID_INPUT",
            "At least one notification setting is required.",
            400,
        )

    allowed_settings = {
        "applicationNotifications": (
            "APPLICATION_NOTIFICATIONS_ENABLED",
            "application_value",
        ),
        "reportNotifications": (
            "REPORT_NOTIFICATIONS_ENABLED",
            "report_value",
        ),
        "trainingNotifications": (
            "TRAINING_NOTIFICATIONS_ENABLED",
            "training_value",
        ),
    }

    updates = []
    parameters = {}

    for key, value in payload.items():
        if key not in allowed_settings:
            return _error_response(
                "INVALID_INPUT",
                f"Unknown setting: {key}",
                400,
            )

        if type(value) is not bool:
            return _error_response(
                "INVALID_INPUT",
                f"The value of {key} must be true or false.",
                400,
            )

        column_name, bind_name = allowed_settings[key]

        updates.append(f"{column_name} = :{bind_name}")
        parameters[bind_name] = 1 if value else 0

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        row = _get_admin_settings_row(cursor, token)

        if row is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        parameters["user_id"] = row[0]

        sql = f"""
            UPDATE users
            SET
                {", ".join(updates)},
                settings_updated_at = LOCALTIMESTAMP
            WHERE user_id = :user_id
        """

        cursor.execute(sql, parameters)

        connection.commit()

        return jsonify({
            "success": True,
            "data": {
                "message": "Notification settings updated successfully.",
            }
        }), 200

    except Exception:
        if connection:
            connection.rollback()

        current_app.logger.exception(
            "Failed to update university notification settings."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to update notification settings.",
            500,
        )

    finally:
        if cursor:
            cursor.close()

        if connection:
            connection.close()


@university_bp.patch("/settings/preferences")
def update_university_general_preferences():
    token = _get_bearer_token()

    if not token:
        return _error_response(
            "UNAUTHORIZED",
            "Authentication token is required.",
            401,
        )

    payload = request.get_json(silent=True)

    if not isinstance(payload, dict) or len(payload) != 1:
        return _error_response(
            "INVALID_INPUT",
            "Send exactly one general preference.",
            400,
        )

    allowed = {
        "languageCode": ("LANGUAGE_CODE", {"ar", "en"}),
        "themeMode": ("THEME_MODE", {"LIGHT", "DARK"}),
    }

    key, value = next(iter(payload.items()))
    if key not in allowed or not isinstance(value, str):
        return _error_response(
            "INVALID_INPUT",
            "Unsupported general preference.",
            400,
        )

    column_name, allowed_values = allowed[key]
    normalized = value.lower() if key == "languageCode" else value.upper()

    if normalized not in allowed_values:
        return _error_response(
            "INVALID_INPUT",
            "The selected preference value is not supported.",
            400,
        )

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        row = _get_admin_settings_row(cursor, token)
        if row is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        cursor.execute(
            f"""
                UPDATE users
                SET {column_name} = :preference_value,
                    settings_updated_at = LOCALTIMESTAMP
                WHERE user_id = :user_id
            """,
            preference_value=normalized,
            user_id=row[0],
        )

        connection.commit()

        return jsonify({
            "success": True,
            "data": {
                "languageCode": normalized if key == "languageCode" else row[3],
                "themeMode": normalized if key == "themeMode" else row[4],
            },
        }), 200

    except Exception:
        if connection:
            connection.rollback()

        current_app.logger.exception(
            "Failed to update university general preferences."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to update general preferences.",
            500,
        )

    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()