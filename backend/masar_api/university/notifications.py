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


def _get_admin_user_id(cursor, token):
    cursor.execute("""
        SELECT u.user_id
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

    row = cursor.fetchone()

    return int(row[0]) if row else None


@university_bp.get("/dashboard/badges")
def get_university_dashboard_badges():
    """Return only the two counts required by the university dashboard chrome."""
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

        user_id = _get_admin_user_id(cursor, token)
        if user_id is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        cursor.execute("""
            SELECT
                (
                    SELECT COUNT(*)
                    FROM internship_applications ia
                    JOIN students s
                        ON s.student_id = ia.student_id
                    WHERE s.university_id = :university_id
                      AND UPPER(REPLACE(REPLACE(TRIM(ia.application_status), '-', '_'), ' ', '_')) IN (
                          'PENDING',
                          'SUBMITTED',
                          'UNDER_REVIEW',
                          'PENDING_REVIEW',
                          'IN_REVIEW',
                          'REVIEWING',
                          'WAITING_FOR_REVIEW',
                          'WAITING_COMPANY_REVIEW',
                          'WAITING_UNIVERSITY_REVIEW'
                      )
                ) AS pending_applications,
                (
                    SELECT COUNT(*)
                    FROM university_notifications
                    WHERE user_id = :user_id
                      AND is_read = 0
                ) AS unread_notifications
            FROM dual
        """,
            university_id=WISE_UNIVERSITY_ID,
            user_id=user_id,
        )
        row = cursor.fetchone()

        return jsonify({
            "success": True,
            "data": {
                "pendingApplications": int(row[0] or 0),
                "unreadNotifications": int(row[1] or 0),
            },
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university dashboard badge counts."
        )
        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to load dashboard badge counts.",
            500,
        )
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


def _notification_type(value):
    type_map = {
        "APPLICATION": "application",
        "REPORT": "report",
        "TRAINING": "training",
        "OPPORTUNITY": "opportunity",
        "COMPLETED": "completed",
    }

    raw_type = (value or "GENERAL").strip().upper()

    return type_map.get(raw_type, "general")


def create_university_notification(
    cursor,
    title,
    message,
    notification_type="GENERAL",
    related_entity_type=None,
    related_entity_id=None,
):
    """
    Create a notification for every active university administrator.

    The caller is responsible for committing the transaction.
    """

    cursor.execute("""
        INSERT INTO university_notifications (
            user_id,
            title,
            message,
            notification_type,
            related_entity_type,
            related_entity_id
        )
        SELECT
            us.user_id,
            :title,
            :message,
            :notification_type,
            :related_entity_type,
            :related_entity_id
        FROM university_staff us
        JOIN users u
            ON u.user_id = us.user_id
        JOIN roles r
            ON r.role_id = u.role_id
        WHERE us.university_id = :university_id
          AND us.staff_role = 'ADMIN'
          AND us.is_active = 1
          AND u.account_status = 'ACTIVE'
          AND r.role_code = 'UNIVERSITY_ADMIN'
          AND CASE UPPER(:notification_type)
                WHEN 'APPLICATION' THEN NVL(u.application_notifications_enabled, 1)
                WHEN 'REPORT' THEN NVL(u.report_notifications_enabled, 1)
                WHEN 'TRAINING' THEN NVL(u.training_notifications_enabled, 1)
                WHEN 'COMPLETED' THEN NVL(u.training_notifications_enabled, 1)
                ELSE 1
              END = 1
    """,
        title=title,
        message=message,
        notification_type=notification_type,
        related_entity_type=related_entity_type,
        related_entity_id=related_entity_id,
        university_id=WISE_UNIVERSITY_ID,
    )


@university_bp.get("/notifications")
def get_university_notifications():
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

        user_id = _get_admin_user_id(cursor, token)

        if user_id is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        cursor.execute("""
            SELECT
                notification_id,
                title,
                message,
                notification_type,
                is_read,

                TO_CHAR(
                    created_at,
                    'YYYY-MM-DD"T"HH24:MI:SS'
                ) AS created_at,

                related_entity_type,
                related_entity_id

            FROM university_notifications

            WHERE user_id = :user_id

            ORDER BY
                created_at DESC,
                notification_id DESC
        """, user_id=user_id)

        rows = cursor.fetchall()

        notifications = []

        for row in rows:
            notifications.append({
                "id": str(row[0]),
                "title": row[1],
                "message": row[2],
                "type": _notification_type(row[3]),
                "read": int(row[4] or 0) == 1,
                "createdAt": row[5],
                "relatedEntityType": row[6],
                "relatedEntityId": (
                    str(row[7]) if row[7] is not None else None
                ),
            })

        unread_count = sum(
            1 for item in notifications if not item["read"]
        )

        return jsonify({
            "success": True,
            "data": {
                "statistics": {
                    "totalNotifications": len(notifications),
                    "unreadNotifications": unread_count,
                },
                "notifications": notifications,
            }
        }), 200

    except Exception:
        current_app.logger.exception(
            "Failed to load university notifications."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to load notifications.",
            500,
        )

    finally:
        if cursor:
            cursor.close()

        if connection:
            connection.close()


@university_bp.patch("/notifications/read-all")
def mark_all_notifications_as_read():
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

        user_id = _get_admin_user_id(cursor, token)

        if user_id is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        cursor.execute("""
            UPDATE university_notifications
            SET
                is_read = 1,
                read_at = LOCALTIMESTAMP
            WHERE user_id = :user_id
              AND is_read = 0
        """, user_id=user_id)

        updated_count = cursor.rowcount

        connection.commit()

        return jsonify({
            "success": True,
            "data": {
                "updatedCount": updated_count,
            }
        }), 200

    except Exception:
        if connection:
            connection.rollback()

        current_app.logger.exception(
            "Failed to mark all notifications as read."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to update notifications.",
            500,
        )

    finally:
        if cursor:
            cursor.close()

        if connection:
            connection.close()


@university_bp.patch("/notifications/<int:notification_id>/read")
def mark_notification_as_read(notification_id):
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

        user_id = _get_admin_user_id(cursor, token)

        if user_id is None:
            return _error_response(
                "INVALID_SESSION",
                "The session is invalid or has expired.",
                401,
            )

        cursor.execute("""
            UPDATE university_notifications
            SET
                is_read = 1,
                read_at = LOCALTIMESTAMP
            WHERE notification_id = :notification_id
              AND user_id = :user_id
        """,
            notification_id=notification_id,
            user_id=user_id,
        )

        if cursor.rowcount == 0:
            return _error_response(
                "NOT_FOUND",
                "Notification was not found.",
                404,
            )

        connection.commit()

        return jsonify({
            "success": True,
            "data": {
                "notificationId": str(notification_id),
                "read": True,
            }
        }), 200

    except Exception:
        if connection:
            connection.rollback()

        current_app.logger.exception(
            "Failed to mark notification as read."
        )

        return _error_response(
            "INTERNAL_SERVER_ERROR",
            "Unable to update notification.",
            500,
        )

    finally:
        if cursor:
            cursor.close()

        if connection:
            connection.close()
