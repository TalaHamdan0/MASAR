import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv
from flask import current_app


class DatabaseConfigurationError(RuntimeError):
    pass


def configure_database(app):
    env_path = Path(__file__).resolve().parent.parent / ".env"
    load_dotenv(env_path, override=False)

    app.config["DB_USER"] = os.getenv("DB_USER", "").strip()
    app.config["DB_PASSWORD"] = os.getenv("DB_PASSWORD", "")
    app.config["DB_DSN"] = os.getenv("DB_DSN", "").strip()


def get_connection():
    required_settings = (
        "DB_USER",
        "DB_PASSWORD",
        "DB_DSN",
    )

    missing_settings = [
        name
        for name in required_settings
        if not current_app.config.get(name)
    ]

    if missing_settings:
        raise DatabaseConfigurationError(
            "Missing database settings: "
            + ", ".join(missing_settings)
        )

    connection = oracledb.connect(
        user=current_app.config["DB_USER"],
        password=current_app.config["DB_PASSWORD"],
        dsn=current_app.config["DB_DSN"],
    )

    connection.call_timeout = 5000

    return connection