from .student import student_bp
from .company import company_bp
from .university import university_bp


def register_feature_blueprints(app):
    app.register_blueprint(student_bp)
    app.register_blueprint(company_bp)
    app.register_blueprint(university_bp)