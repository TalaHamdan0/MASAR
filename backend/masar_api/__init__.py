import logging
from pathlib import Path

import oracledb
from flask import Flask, jsonify, request

from .authentication import authentication_bp
from .database import (
    DatabaseConfigurationError,
    configure_database,
    get_connection,
)
from .features import register_feature_blueprints
from .registration import registration_bp


def create_app():
    app = Flask(__name__)
    app.json.ensure_ascii = False

    log_path = (
        Path(__file__).resolve().parent.parent
        / "masar_backend.log"
    )

    if not any(
        getattr(handler, "baseFilename", None) == str(log_path)
        for handler in app.logger.handlers
    ):
        file_handler = logging.FileHandler(
            log_path,
            encoding="utf-8",
        )

        file_handler.setFormatter(
            logging.Formatter(
                "%(asctime)s %(levelname)s %(message)s"
            )
        )

        app.logger.addHandler(file_handler)

    app.logger.setLevel(logging.INFO)

    configure_database(app)

    app.register_blueprint(registration_bp)
    app.register_blueprint(authentication_bp)

    register_feature_blueprints(app)

    allowed_origins = {
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:5174",
        "http://127.0.0.1:5174",
    }

    @app.after_request
    def allow_flutter_web(response):
        origin = request.headers.get("Origin")

        if origin in allowed_origins:
            response.headers["Access-Control-Allow-Origin"] = origin

            response.headers["Access-Control-Allow-Headers"] = (
                "Content-Type, Authorization"
            )

            response.headers["Access-Control-Allow-Methods"] = (
                "GET, POST, PUT, PATCH, DELETE, OPTIONS"
            )

        response.vary.add("Origin")
        response.headers["Cache-Control"] = "no-store"

        app.logger.info(
            "%s %s -> %s",
            request.method,
            request.path,
            response.status_code,
        )

        return response

    @app.errorhandler(DatabaseConfigurationError)
    def handle_database_configuration_error(error):
        app.logger.error("%s", error)

        return jsonify({
            "error": {
                "code": "database_not_configured",
                "message": "إعدادات الاتصال بقاعدة البيانات غير مكتملة.",
            }
        }), 503

    @app.errorhandler(oracledb.Error)
    def handle_database_error(error):
        details = error.args[0] if error.args else None
        error_code = getattr(details, "full_code", None)

        if not error_code:
            number = getattr(details, "code", None)

            error_code = (
                f"ORA-{number:05d}"
                if isinstance(number, int)
                else "DATABASE_ERROR"
            )

        app.logger.exception(
            "Oracle operation failed: %s",
            error_code,
        )

        return jsonify({
            "error": {
                "code": "database_unavailable",
                "message": (
                    "تعذر تنفيذ طلب قاعدة البيانات. "
                    f"رمز الخطأ: {error_code}"
                ),
            }
        }), 503

    @app.get("/api/v1/health")
    def health():
        return jsonify({
            "status": "ok",
            "message": "MASAR backend is running",
            "build": "masar-profile-save-v2",
        })

    @app.get("/api/v1/health/database")
    def database_health():
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT COUNT(*)
                    FROM universities
                    WHERE is_active = 1
                """)

                universities_count = int(cursor.fetchone()[0])

        return jsonify({
            "status": "ok",
            "database": "connected",
            "universities_count": universities_count,
        })

    @app.get("/api/v1/universities")
    def universities():
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT
                        university_id,
                        university_name,
                        university_type
                    FROM universities
                    WHERE is_active = 1
                      AND university_id = 12
                    ORDER BY university_name
                """)

                rows = cursor.fetchall()

        return jsonify({
            "data": [
                {
                    "id": str(row[0]),
                    "name": row[1],
                    "type": row[2],
                }
                for row in rows
            ],
        })

    return app