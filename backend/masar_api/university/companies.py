from flask import jsonify, request

from . import university_bp
from ..database import get_connection
from ..repository import WISE_UNIVERSITY_ID, token_digest


def _bearer_token():
    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    if not 20 <= len(parts[1]) <= 200:
        return None

    return parts[1]


def _error_response(code, message, status):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status


def _read_lob(value):
    if value is None:
        return ""

    if hasattr(value, "read"):
        return value.read()

    return str(value)


def _company_status(status):
    if status == "ACTIVE":
        return "نشطة"

    return "متوقفة مؤقتًا"


def _verification_status(status):
    statuses = {
        "VERIFIED": "موثقة",
        "PENDING": "بانتظار التحقق",
        "REJECTED": "مرفوضة",
    }

    return statuses.get(status, status or "غير معروف")


@university_bp.get("/companies")
def get_companies():

    token = _bearer_token()

    if token is None:
        return _error_response(
            "invalid_session",
            "سجّلي الدخول أولًا.",
            401,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:

            # 1. Verify university administrator session.
            cursor.execute("""
                SELECT us.university_staff_id
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

            if cursor.fetchone() is None:
                return _error_response(
                    "invalid_session",
                    "انتهت الجلسة أو لم تعد صالحة. سجّلي الدخول مجددًا.",
                    401,
                )

            # 2. Get all companies and their counts.
            cursor.execute("""
                SELECT
                    c.company_id,
                    c.company_name,
                    c.industry,
                    c.city,
                    c.address,
                    c.governorate,
                    c.contact_email,
                    c.phone_number,
                    c.description,
                    c.company_status,
                    c.verification_status,

                    (
                        SELECT COUNT(*)
                        FROM internship_offers o
                        WHERE o.company_id = c.company_id
                          AND o.offer_status = 'OPEN'
                    ) AS OPPORTUNITY_COUNT,

                    (
                        SELECT COUNT(DISTINCT i.student_id)
                        FROM internships i
                        WHERE i.company_id = c.company_id
                          AND i.university_id = :university_id
                          AND i.internship_status = 'ACTIVE'
                    ) AS TRAINEE_COUNT

                FROM companies c
                ORDER BY c.company_name
            """, university_id=WISE_UNIVERSITY_ID)

            company_rows = cursor.fetchall()

            companies = []
            companies_by_id = {}

            for row in company_rows:
                company_id = int(row[0])

                location = (
                    row[3]
                    or row[5]
                    or row[4]
                    or "غير محدد"
                )

                company = {
                    "companyId": str(company_id),
                    "name": row[1],
                    "field": row[2] or "غير محدد",
                    "location": location,
                    "opportunities": int(row[11] or 0),
                    "trainees": int(row[12] or 0),
                    "status": _company_status(row[9]),
                    "verificationStatus": _verification_status(row[10]),
                    "email": row[6] or "—",
                    "phone": row[7] or "—",
                    "description": _read_lob(row[8]) or "لا توجد نبذة عن الشركة.",
                    "opportunityList": [],
                    "traineeList": [],
                }

                companies.append(company)
                companies_by_id[company_id] = company

            # 3. Get open training opportunities for each company.
            cursor.execute("""
                SELECT
                    o.company_id,
                    o.title
                FROM internship_offers o
                JOIN companies c
                    ON c.company_id = o.company_id
                WHERE o.offer_status = 'OPEN'
                ORDER BY o.company_id, o.title
            """)

            for company_id, title in cursor.fetchall():
                company = companies_by_id.get(int(company_id))

                if company is not None and title:
                    company["opportunityList"].append(title)

            # 4. Get currently training students for each company.
            cursor.execute("""
                SELECT DISTINCT
                    i.company_id,
                    s.student_id,
                    u.full_name
                FROM internships i
                JOIN students s
                    ON s.student_id = i.student_id
                   AND s.university_id = i.university_id
                JOIN users u
                    ON u.user_id = s.user_id
                WHERE i.university_id = :university_id
                  AND i.internship_status = 'ACTIVE'
                ORDER BY i.company_id, u.full_name
            """, university_id=WISE_UNIVERSITY_ID)

            for company_id, student_id, student_name in cursor.fetchall():
                company = companies_by_id.get(int(company_id))

                if company is not None and student_name:
                    company["traineeList"].append(student_name)

    # 5. Calculate statistics.
    active_companies = sum(
        1 for company in companies
        if company["status"] == "نشطة"
    )

    available_companies = sum(
        1 for company in companies
        if (
            company["status"] == "نشطة"
            and company["verificationStatus"] == "موثقة"
            and company["opportunities"] > 0
        )
    )

    total_opportunities = sum(
        company["opportunities"]
        for company in companies
    )

    total_trainees = sum(
        company["trainees"]
        for company in companies
    )

    return jsonify({
        "data": {
            "statistics": {
                "availableCompanies": available_companies,
                "activeCompanies": active_companies,
                "totalOffers": total_opportunities,
                "trainees": total_trainees,
            },
            "companies": companies,
        }
    })