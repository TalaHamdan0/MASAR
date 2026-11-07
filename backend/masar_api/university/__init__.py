from flask import Blueprint


university_bp = Blueprint(
    "university",
    __name__,
    url_prefix="/api/v1/university",
)


# Import university modules to register their API routes.
from . import authentication
from . import home
from . import students
from . import companies
from . import applications
from . import current_trainings
from . import reports
from . import notifications
from . import settings