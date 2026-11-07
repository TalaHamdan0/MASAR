from flask import Blueprint


university_bp = Blueprint(
    "university",
    __name__,
    url_prefix="/api/v1/university",
)