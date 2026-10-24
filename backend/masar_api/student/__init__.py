from flask import Blueprint


student_bp = Blueprint(
    "student",
    __name__,
    url_prefix="/api/v1/students",
)