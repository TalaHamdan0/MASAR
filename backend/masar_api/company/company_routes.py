<<<<<<< HEAD

import secrets
from datetime import date, datetime

from flask import jsonify, request
from werkzeug.security import check_password_hash, generate_password_hash

from . import company_bp
from ..database import get_connection
from ..repository import create_session, token_digest


_dummy_hash = generate_password_hash(secrets.token_urlsafe(32))

OFFER_MODES = {"ONSITE", "REMOTE", "HYBRID"}
OFFER_STATUSES = {"OPEN", "CLOSED"}
DOCUMENT_TYPES = {"CV", "ACADEMIC_RECORD"}

GOVERNORATES = {
    "عمان", "إربد", "الزرقاء", "البلقاء",
    "المفرق", "جرش", "عجلون", "مادبا",
    "الكرك", "الطفيلة", "معان", "العقبة",
}


def error_response(code, message, status):
    return jsonify({
        "error": {
            "code": code,
            "message": message,
        }
    }), status


def bearer_token():
    parts = request.headers.get("Authorization", "").split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        return None

    if not 20 <= len(parts[1]) <= 200:
        return None

    return parts[1]


def get_company_session(cursor):
    token = bearer_token()

    if token is None:
        return None

    cursor.execute("""
        SELECT
            u.user_id,
            u.full_name,
            u.email,
            cs.company_id,
            cs.staff_role,
            r.role_code
        FROM auth_sessions a
        JOIN users u ON u.user_id = a.user_id
        JOIN roles r ON r.role_id = u.role_id
        JOIN company_staff cs ON cs.user_id = u.user_id
        JOIN companies c ON c.company_id = cs.company_id
        WHERE a.token_hash = :token_hash
          AND a.revoked_at IS NULL
          AND a.expires_at > LOCALTIMESTAMP
          AND u.account_status = 'ACTIVE'
          AND cs.is_active = 1
          AND r.role_code IN (
              'COMPANY_ADMIN',
              'COMPANY_SUPERVISOR'
          )
          AND (
              (
                  r.role_code = 'COMPANY_ADMIN'
                  AND cs.staff_role = 'ADMIN'
              )
              OR
              (
                  r.role_code = 'COMPANY_SUPERVISOR'
                  AND cs.staff_role = 'SUPERVISOR'
              )
          )
    """, token_hash=token_digest(token))

    row = cursor.fetchone()

    if row is None:
        return None

    return {
        "userId": int(row[0]),
        "fullName": row[1],
        "email": row[2],
        "companyId": int(row[3]),
        "staffRole": row[4],
        "roleCode": row[5],
    }


def company_access(cursor, company_id, admin_required=False):
    user = get_company_session(cursor)

    if user is None:
        return None, error_response(
            "invalid_session",
            "يرجى تسجيل الدخول بحساب الشركة أولًا.",
            401,
        )

    if user["companyId"] != company_id:
        return None, error_response(
            "access_denied",
            "ليس لديك صلاحية الوصول إلى هذه الشركة.",
            403,
        )

    if admin_required and user["staffRole"] != "ADMIN":
        return None, error_response(
            "access_denied",
            "هذه العملية متاحة لمسؤول الشركة فقط.",
            403,
        )

    return user, None


# ============================================================
# COMPANY AUTHENTICATION
# ============================================================

@company_bp.route("/login", methods=["POST"])
def company_login():
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return error_response(
            "invalid_json",
            "بيانات تسجيل الدخول غير صالحة.",
            400,
        )

    email = data.get("email")
    password = data.get("password")
    remember_me = data.get("rememberMe", False)

    if not isinstance(email, str) or not email.strip():
        return error_response(
            "invalid_email",
            "يرجى إدخال البريد الإلكتروني.",
            422,
        )

    if not isinstance(password, str) or not password:
        return error_response(
            "invalid_password",
            "يرجى إدخال كلمة المرور.",
            422,
        )

    if not isinstance(remember_me, bool):
        return error_response(
            "invalid_remember_me",
            "قيمة تذكرني غير صالحة.",
            422,
        )

    email = email.strip().lower()

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT
                    u.user_id,
                    u.full_name,
                    u.email,
                    u.password_hash,
                    u.account_status,
                    cs.company_id,
                    cs.staff_role,
                    cs.is_active,
                    r.role_code,
                    c.company_name
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                JOIN company_staff cs
                    ON cs.user_id = u.user_id
                JOIN companies c
                    ON c.company_id = cs.company_id
                WHERE u.email = :email
                  AND r.role_code IN (
                      'COMPANY_ADMIN',
                      'COMPANY_SUPERVISOR'
                  )
            """, email=email)

            row = cursor.fetchone()

            valid_password = check_password_hash(
                row[3] if row else _dummy_hash,
                password,
            )

            if row is None or not valid_password:
                return error_response(
                    "invalid_credentials",
                    "البريد الإلكتروني أو كلمة المرور غير صحيحة.",
                    401,
                )

            if row[4] != "ACTIVE" or int(row[7]) != 1:
                return error_response(
                    "account_unavailable",
                    "حساب الشركة غير مفعّل.",
                    403,
                )

            role_code = row[8]
            staff_role = row[6]

            valid_role = (
                role_code == "COMPANY_ADMIN"
                and staff_role == "ADMIN"
            ) or (
                role_code == "COMPANY_SUPERVISOR"
                and staff_role == "SUPERVISOR"
            )

            if not valid_role:
                return error_response(
                    "access_denied",
                    "صلاحيات حساب الشركة غير متطابقة.",
                    403,
                )

            user_id = int(row[0])

            token, expires_in = create_session(
                cursor,
                user_id,
                remember_me,
            )

            response_data = {
                "data": {
                    "accessToken": token,
                    "expiresIn": expires_in,
                    "user": {
                        "userId": user_id,
                        "fullName": row[1],
                        "email": row[2],
                    },
                    "company": {
                        "companyId": int(row[5]),
                        "companyName": row[9],
                        "staffRole": staff_role,
                        "roleCode": role_code,
                    },
                }
            }

        connection.commit()

    return jsonify(response_data), 200


# ============================================================
# COMPANY DASHBOARD
# ============================================================

@company_bp.route(
    "/<int:company_id>/dashboard",
    methods=["GET"],
)
def get_company_dashboard(company_id):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(cursor, company_id)

            if error is not None:
                return error

            cursor.execute("""
                SELECT
                    offer_id,
                    title,
                    offer_status,
                    available_slots
                FROM internship_offers
                WHERE company_id = :company_id
                ORDER BY offer_id DESC
            """, company_id=company_id)

            rows = cursor.fetchall()

    opportunities = [
        {
            "offer_id": int(row[0]),
            "title": row[1],
            "status": row[2],
            "available_slots": row[3],
        }
        for row in rows
    ]

    return jsonify({
        "company_id": company_id,
        "internship_offers": opportunities,
    }), 200


# ============================================================
# COMPANY PROFILE
# ============================================================

@company_bp.route(
    "/<int:company_id>/profile",
    methods=["GET"],
)
def get_company_profile(company_id):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(cursor, company_id)

            if error is not None:
                return error

            cursor.execute("""
                SELECT
                    company_id,
                    company_name,
                    contact_email,
                    phone_number,
                    address
                FROM companies
                WHERE company_id = :company_id
            """, company_id=company_id)

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "company_not_found",
                    "الشركة غير موجودة.",
                    404,
                )

    return jsonify({
        "data": {
            "company_id": int(row[0]),
            "company_name": row[1],
            "contact_email": row[2],
            "phone_number": row[3],
            "address": row[4],
        }
    }), 200


@company_bp.route(
    "/<int:company_id>/profile",
    methods=["PUT"],
)
def update_company_profile(company_id):
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return error_response(
            "invalid_json",
            "بيانات الملف التعريفي غير صالحة.",
            400,
        )

    allowed_fields = {
        "company_name": "COMPANY_NAME",
        "slogan": "SLOGAN",
        "industry": "INDUSTRY",
        "description": "DESCRIPTION",
        "city": "CITY",
        "governorate": "GOVERNORATE",
        "address": "ADDRESS",
        "contact_email": "CONTACT_EMAIL",
        "phone_number": "PHONE_NUMBER",
        "website_url": "WEBSITE_URL",
    }

    updates = {}

    for field, column in allowed_fields.items():
        if field not in data:
            continue

        value = data[field]

        if value is not None and not isinstance(value, str):
            return error_response(
                "invalid_field",
                f"قيمة الحقل {field} غير صالحة.",
                422,
            )

        if isinstance(value, str):
            value = value.strip()

        updates[field] = (column, value)

    if not updates:
        return error_response(
            "empty_update",
            "لم يتم إرسال أي بيانات لتحديثها.",
            422,
        )

    required_fields = {
        "company_name",
        "contact_email",
        "phone_number",
        "address",
    }

    for field in required_fields:
        if field in updates:
            value = updates[field][1]

            if value is None or not value:
                return error_response(
                    "invalid_field",
                    f"الحقل {field} مطلوب.",
                    422,
                )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(
                cursor,
                company_id,
                admin_required=True,
            )

            if error is not None:
                return error

            assignments = []
            parameters = {"company_id": company_id}

            for field, (column, value) in updates.items():
                assignments.append(f"{column} = :{field}")
                parameters[field] = value

            assignments.append("UPDATED_AT = SYSTIMESTAMP")

            query = f"""
                UPDATE companies
                SET {", ".join(assignments)}
                WHERE company_id = :company_id
            """

            cursor.execute(query, parameters)

            if cursor.rowcount == 0:
                return error_response(
                    "company_not_found",
                    "الشركة غير موجودة.",
                    404,
                )

        connection.commit()

    return jsonify({
        "message": "تم تحديث الملف التعريفي للشركة بنجاح",
        "company_id": company_id,
    }), 200


# ============================================================
# CHANGE PASSWORD
# ============================================================

@company_bp.route(
    "/me/change-password",
    methods=["POST"],
)
def change_company_password():
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    current_password = data.get("currentPassword")
    new_password = data.get("newPassword")

    if not isinstance(current_password, str) or not current_password:
        return error_response(
            "invalid_current_password",
            "يرجى إدخال كلمة المرور الحالية.",
            422,
        )

    if not isinstance(new_password, str) or len(new_password) < 8:
        return error_response(
            "invalid_new_password",
            "كلمة المرور الجديدة يجب أن تتكون من 8 أحرف على الأقل.",
            422,
        )

    if len(new_password) > 128:
        return error_response(
            "invalid_new_password",
            "كلمة المرور الجديدة طويلة جدًا.",
            422,
        )

    if current_password == new_password:
        return error_response(
            "same_password",
            "يجب أن تختلف كلمة المرور الجديدة عن الحالية.",
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user = get_company_session(cursor)

            if user is None:
                return error_response(
                    "invalid_session",
                    "يرجى تسجيل الدخول بحساب الشركة أولًا.",
                    401,
                )

            cursor.execute("""
                SELECT password_hash
                FROM users
                WHERE user_id = :user_id
                  AND account_status = 'ACTIVE'
                FOR UPDATE
            """, user_id=user["userId"])

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "account_not_found",
                    "حساب المستخدم غير متاح.",
                    404,
                )

            if not check_password_hash(
                row[0],
                current_password,
            ):
                return error_response(
                    "incorrect_password",
                    "كلمة المرور الحالية غير صحيحة.",
                    422,
                )

            new_hash = generate_password_hash(new_password)

            cursor.execute("""
                UPDATE users
                SET password_hash = :password_hash
                WHERE user_id = :user_id
            """,
                password_hash=new_hash,
                user_id=user["userId"],
            )

        connection.commit()

    return jsonify({
        "message": "تم تغيير كلمة المرور بنجاح."
    }), 200


# ============================================================
# INTERNSHIP OFFER HELPERS
# ============================================================

def _offer_text(value, field, required=False):
    if value is None:
        if required:
            raise ValueError(f"الحقل {field} مطلوب.")
        return None

    if not isinstance(value, str):
        raise ValueError(f"قيمة الحقل {field} غير صالحة.")

    value = value.strip()

    if required and not value:
        raise ValueError(f"الحقل {field} مطلوب.")

    return value or None


def _offer_positive_int(value, field):
    if isinstance(value, bool):
        raise ValueError(f"قيمة {field} غير صالحة.")

    if isinstance(value, int):
        result = value
    elif isinstance(value, str) and value.strip().isdigit():
        result = int(value.strip())
    else:
        raise ValueError(
            f"قيمة {field} يجب أن تكون رقمًا صحيحًا."
        )

    if result <= 0:
        raise ValueError(
            f"قيمة {field} يجب أن تكون أكبر من صفر."
        )

    return result


def _offer_date(value, field):
    if not isinstance(value, str):
        raise ValueError(f"تاريخ {field} مطلوب.")

    try:
        return date.fromisoformat(value)
    except ValueError:
        raise ValueError(
            f"تاريخ {field} غير صالح. استخدم YYYY-MM-DD."
        )


def _offer_payload(data):
    if not isinstance(data, dict):
        raise ValueError("بيانات الفرصة غير صالحة.")

    result = {
        "title": _offer_text(
            data.get("title"),
            "عنوان الفرصة",
            True,
        ),
        "description": _offer_text(
            data.get("description"),
            "وصف الفرصة",
            True,
        ),
        "requirements": _offer_text(
            data.get("requirements"),
            "المتطلبات",
        ),
        "location": _offer_text(
            data.get("location"),
            "الموقع",
            True,
        ),
        "city": _offer_text(
            data.get("city"),
            "المدينة",
        ),
        "governorate": _offer_text(
            data.get("governorate"),
            "المحافظة",
        ),
        "learning_outcomes": _offer_text(
            data.get("learning_outcomes"),
            "مخرجات التعلم",
        ),
        "training_track_id": _offer_positive_int(
            data.get("training_track_id"),
            "المسار التدريبي",
        ),
        "available_slots": _offer_positive_int(
            data.get("available_slots"),
            "عدد المقاعد",
        ),
        "required_hours": _offer_positive_int(
            data.get("required_hours"),
            "ساعات التدريب",
        ),
        "start_date": _offer_date(
            data.get("start_date"),
            "بداية التدريب",
        ),
        "end_date": _offer_date(
            data.get("end_date"),
            "نهاية التدريب",
        ),
    }

    work_mode = data.get("work_mode")

    if not isinstance(work_mode, str):
        raise ValueError("نمط التدريب مطلوب.")

    work_mode = work_mode.strip().upper()

    if work_mode not in OFFER_MODES:
        raise ValueError(
            "نمط التدريب يجب أن يكون "
            "ONSITE أو REMOTE أو HYBRID."
        )

    result["work_mode"] = work_mode

    if result["end_date"] < result["start_date"]:
        raise ValueError(
            "تاريخ نهاية التدريب يجب ألا يسبق تاريخ البداية."
        )

    governorate = result["governorate"]

    if governorate is not None and governorate not in GOVERNORATES:
        raise ValueError("المحافظة غير صالحة.")

    raw_skills = data.get("skill_ids", [])

    if not isinstance(raw_skills, list):
        raise ValueError("قائمة المهارات غير صالحة.")

    skills = []

    for value in raw_skills:
        skill_id = _offer_positive_int(
            value,
            "معرّف المهارة",
        )

        if skill_id not in skills:
            skills.append(skill_id)

    result["skill_ids"] = skills

    raw_documents = data.get("required_documents", [])

    if not isinstance(raw_documents, list):
        raise ValueError("قائمة المستندات غير صالحة.")

    documents = []

    for document_type in raw_documents:
        if not isinstance(document_type, str):
            raise ValueError("نوع المستند غير صالح.")

        document_type = document_type.strip().upper()

        if document_type not in DOCUMENT_TYPES:
            raise ValueError(
                "نوع المستند غير مدعوم. "
                "المسموح CV و ACADEMIC_RECORD."
            )

        if document_type not in documents:
            documents.append(document_type)

    result["required_documents"] = documents

    return result


def _validate_offer_references(cursor, payload):
    cursor.execute("""
        SELECT training_track_id
        FROM training_tracks
        WHERE training_track_id = :track_id
          AND is_active = 1
    """, track_id=payload["training_track_id"])

    if cursor.fetchone() is None:
        raise ValueError(
            "المسار التدريبي غير موجود أو غير مفعّل."
        )

    for skill_id in payload["skill_ids"]:
        cursor.execute("""
            SELECT skill_id
            FROM skills
            WHERE skill_id = :skill_id
              AND is_active = 1
        """, skill_id=skill_id)

        if cursor.fetchone() is None:
            raise ValueError(
                f"المهارة رقم {skill_id} "
                "غير موجودة أو غير مفعّلة."
            )


def _save_offer_relations(cursor, offer_id, payload):
    cursor.execute("""
        DELETE FROM offer_required_skills
        WHERE offer_id = :offer_id
    """, offer_id=offer_id)

    for skill_id in payload["skill_ids"]:
        cursor.execute("""
            INSERT INTO offer_required_skills (
                offer_id,
                skill_id,
                is_mandatory
            ) VALUES (
                :offer_id,
                :skill_id,
                1
            )
        """,
            offer_id=offer_id,
            skill_id=skill_id,
        )

    cursor.execute("""
        DELETE FROM offer_document_requirements
        WHERE offer_id = :offer_id
    """, offer_id=offer_id)

    titles = {
        "CV": "السيرة الذاتية",
        "ACADEMIC_RECORD": "السجل الأكاديمي",
    }

    for index, document_type in enumerate(
        payload["required_documents"],
        start=1,
    ):
        cursor.execute("""
            INSERT INTO offer_document_requirements (
                offer_id,
                document_type,
                document_title,
                is_required,
                display_order,
                created_at
            ) VALUES (
                :offer_id,
                :document_type,
                :document_title,
                1,
                :display_order,
                SYSTIMESTAMP
            )
        """,
            offer_id=offer_id,
            document_type=document_type,
            document_title=titles[document_type],
            display_order=index,
        )


def _offer_to_json(row):
    def as_text(value):
        if value is None:
            return None

        if hasattr(value, "read"):
            return value.read()

        return str(value)

    def as_date(value):
        if value is None:
            return None

        return value.isoformat()

    return {
        "offer_id": int(row[0]),
        "company_id": int(row[1]),
        "training_track_id": (
            int(row[2]) if row[2] is not None else None
        ),
        "title": row[3],
        "description": as_text(row[4]),
        "requirements": as_text(row[5]),
        "location": row[6],
        "city": row[7],
        "work_mode": row[8],
        "available_slots": row[9],
        "required_hours": row[10],
        "start_date": as_date(row[11]),
        "end_date": as_date(row[12]),
        "offer_status": row[13],
        "published_at": as_date(row[14]),
        "governorate": row[15],
        "learning_outcomes": as_text(row[16]),
    }


OFFER_SELECT = """
    SELECT
        offer_id,
        company_id,
        training_track_id,
        title,
        description,
        requirements,
        location,
        city,
        work_mode,
        available_slots,
        required_hours,
        start_date,
        end_date,
        offer_status,
        published_at,
        governorate,
        learning_outcomes
    FROM internship_offers
"""


# ============================================================
# GET COMPANY OFFERS
# ============================================================

@company_bp.route(
    "/<int:company_id>/offers",
    methods=["GET"],
)
def list_company_offers(company_id):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(cursor, company_id)

            if error is not None:
                return error

            cursor.execute(
                OFFER_SELECT + """
                    WHERE company_id = :company_id
                    ORDER BY offer_id DESC
                """,
                company_id=company_id,
            )

            offers = [
                _offer_to_json(row)
                for row in cursor.fetchall()
            ]

            for offer in offers:
                cursor.execute("""
                    SELECT skill_id
                    FROM offer_required_skills
                    WHERE offer_id = :offer_id
                    ORDER BY skill_id
                """, offer_id=offer["offer_id"])

                offer["skill_ids"] = [
                    int(row[0])
                    for row in cursor.fetchall()
                ]

                cursor.execute("""
                    SELECT document_type
                    FROM offer_document_requirements
                    WHERE offer_id = :offer_id
                    ORDER BY display_order
                """, offer_id=offer["offer_id"])

                offer["required_documents"] = [
                    row[0]
                    for row in cursor.fetchall()
                ]

    return jsonify({"data": offers}), 200


# ============================================================
# CREATE AND PUBLISH OFFER
# ============================================================

@company_bp.route(
    "/<int:company_id>/offers",
    methods=["POST"],
)
def create_company_offer(company_id):
    try:
        payload = _offer_payload(
            request.get_json(silent=True)
        )
    except ValueError as exc:
        return error_response(
            "invalid_offer",
            str(exc),
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(
                cursor,
                company_id,
                admin_required=True,
            )

            if error is not None:
                return error

            try:
                _validate_offer_references(cursor, payload)

                # Oracle RETURNING variable
                new_offer_id = cursor.var(int)

                cursor.execute("""
                    INSERT INTO internship_offers (
                        company_id,
                        training_track_id,
                        title,
                        description,
                        requirements,
                        location,
                        city,
                        work_mode,
                        available_slots,
                        required_hours,
                        start_date,
                        end_date,
                        offer_status,
                        published_at,
                        created_at,
                        updated_at,
                        governorate,
                        learning_outcomes
                    ) VALUES (
                        :company_id,
                        :training_track_id,
                        :title,
                        :description,
                        :requirements,
                        :location,
                        :city,
                        :work_mode,
                        :available_slots,
                        :required_hours,
                        :start_date,
                        :end_date,
                        'OPEN',
                        SYSTIMESTAMP,
                        SYSTIMESTAMP,
                        SYSTIMESTAMP,
                        :governorate,
                        :learning_outcomes
                    )
                    RETURNING offer_id INTO :new_offer_id
                """,
                    company_id=company_id,
                    training_track_id=payload[
                        "training_track_id"
                    ],
                    title=payload["title"],
                    description=payload["description"],
                    requirements=payload["requirements"],
                    location=payload["location"],
                    city=payload["city"],
                    work_mode=payload["work_mode"],
                    available_slots=payload[
                        "available_slots"
                    ],
                    required_hours=payload[
                        "required_hours"
                    ],
                    start_date=payload["start_date"],
                    end_date=payload["end_date"],
                    governorate=payload["governorate"],
                    learning_outcomes=payload[
                        "learning_outcomes"
                    ],
                    new_offer_id=new_offer_id,
                )

                # Correctly retrieve this INSERT's Oracle ID.
                returned_ids = new_offer_id.getvalue()

                if not returned_ids:
                    raise RuntimeError(
                        "Oracle did not return the new offer ID."
                    )

                offer_id = int(returned_ids[0])

                _save_offer_relations(
                    cursor,
                    offer_id,
                    payload,
                )

                connection.commit()

            except ValueError as exc:
                connection.rollback()

                return error_response(
                    "invalid_offer",
                    str(exc),
                    422,
                )

            except Exception:
                connection.rollback()
                raise

    return jsonify({
        "message": "تم نشر فرصة التدريب بنجاح.",
        "data": {
            "offer_id": offer_id,
            "offer_status": "OPEN",
        },
    }), 201


# ============================================================
# UPDATE PUBLISHED OFFER
# ============================================================

@company_bp.route(
    "/<int:company_id>/offers/<int:offer_id>",
    methods=["PUT"],
)
def update_company_offer(company_id, offer_id):
    try:
        payload = _offer_payload(
            request.get_json(silent=True)
        )
    except ValueError as exc:
        return error_response(
            "invalid_offer",
            str(exc),
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(
                cursor,
                company_id,
                admin_required=True,
            )

            if error is not None:
                return error

            cursor.execute("""
                SELECT offer_status
                FROM internship_offers
                WHERE offer_id = :offer_id
                  AND company_id = :company_id
                FOR UPDATE
            """,
                offer_id=offer_id,
                company_id=company_id,
            )

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "offer_not_found",
                    "فرصة التدريب غير موجودة.",
                    404,
                )

            if row[0] not in OFFER_STATUSES:
                return error_response(
                    "invalid_status",
                    "لا يمكن تعديل هذه الفرصة بحالتها الحالية.",
                    409,
                )

            try:
                _validate_offer_references(cursor, payload)

                cursor.execute("""
                    UPDATE internship_offers
                    SET
                        training_track_id = :training_track_id,
                        title = :title,
                        description = :description,
                        requirements = :requirements,
                        location = :location,
                        city = :city,
                        work_mode = :work_mode,
                        available_slots = :available_slots,
                        required_hours = :required_hours,
                        start_date = :start_date,
                        end_date = :end_date,
                        governorate = :governorate,
                        learning_outcomes = :learning_outcomes,
                        updated_at = SYSTIMESTAMP
                    WHERE offer_id = :offer_id
                      AND company_id = :company_id
                """,
                    offer_id=offer_id,
                    company_id=company_id,
                    training_track_id=payload[
                        "training_track_id"
                    ],
                    title=payload["title"],
                    description=payload["description"],
                    requirements=payload["requirements"],
                    location=payload["location"],
                    city=payload["city"],
                    work_mode=payload["work_mode"],
                    available_slots=payload[
                        "available_slots"
                    ],
                    required_hours=payload[
                        "required_hours"
                    ],
                    start_date=payload["start_date"],
                    end_date=payload["end_date"],
                    governorate=payload["governorate"],
                    learning_outcomes=payload[
                        "learning_outcomes"
                    ],
                )

                _save_offer_relations(
                    cursor,
                    offer_id,
                    payload,
                )

                connection.commit()

            except ValueError as exc:
                connection.rollback()

                return error_response(
                    "invalid_offer",
                    str(exc),
                    422,
                )

            except Exception:
                connection.rollback()
                raise

    return jsonify({
        "message": "تم تعديل فرصة التدريب بنجاح.",
        "data": {
            "offer_id": offer_id,
        },
    }), 200


# ============================================================
# CLOSE / REOPEN OFFER
# ============================================================

@company_bp.route(
    "/<int:company_id>/offers/<int:offer_id>/status",
    methods=["PATCH"],
)
def change_company_offer_status(company_id, offer_id):
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return error_response(
            "invalid_json",
            "بيانات الطلب غير صالحة.",
            400,
        )

    status = data.get("offer_status")

    if status not in OFFER_STATUSES:
        return error_response(
            "invalid_status",
            "الحالة المسموحة هي OPEN أو CLOSED.",
            422,
        )

    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(
                cursor,
                company_id,
                admin_required=True,
            )

            if error is not None:
                return error

            cursor.execute("""
                SELECT offer_status
                FROM internship_offers
                WHERE offer_id = :offer_id
                  AND company_id = :company_id
                FOR UPDATE
            """,
                offer_id=offer_id,
                company_id=company_id,
            )

            row = cursor.fetchone()

            if row is None:
                return error_response(
                    "offer_not_found",
                    "فرصة التدريب غير موجودة.",
                    404,
                )

            if row[0] not in OFFER_STATUSES:
                return error_response(
                    "invalid_status",
                    "لا يمكن تغيير حالة هذه الفرصة.",
                    409,
                )

            cursor.execute("""
                UPDATE internship_offers
                SET
                    offer_status = :offer_status,
                    updated_at = SYSTIMESTAMP
                WHERE offer_id = :offer_id
                  AND company_id = :company_id
            """,
                offer_status=status,
                offer_id=offer_id,
                company_id=company_id,
            )

        connection.commit()

    return jsonify({
        "message": "تم تحديث حالة فرصة التدريب بنجاح.",
        "data": {
            "offer_id": offer_id,
            "offer_status": status,
        },
    }), 200


# ============================================================
# TRAINING TRACKS
# ============================================================

@company_bp.route(
    "/<int:company_id>/training-tracks",
    methods=["GET"],
)
def get_company_training_tracks(company_id):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(cursor, company_id)

            if error is not None:
                return error

            cursor.execute("""
                SELECT
                    training_track_id,
                    track_name
                FROM training_tracks
                WHERE is_active = 1
                ORDER BY track_name
            """)

            tracks = [
                {
                    "training_track_id": int(row[0]),
                    "track_name": row[1],
                }
                for row in cursor.fetchall()
            ]

    return jsonify({"data": tracks}), 200


# ============================================================
# SKILLS
# ============================================================

@company_bp.route(
    "/<int:company_id>/skills",
    methods=["GET"],
)
def get_company_skills(company_id):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            user, error = company_access(cursor, company_id)

            if error is not None:
                return error

            cursor.execute("""
                SELECT
                    skill_id,
                    skill_name
                FROM skills
                WHERE is_active = 1
                ORDER BY skill_name
            """)

            skills = [
                {
                    "skill_id": int(row[0]),
                    "skill_name": row[1],
                }
                for row in cursor.fetchall()
            ]

    return jsonify({"data": skills}), 200
=======
from flask import request, jsonify
import oracledb
import os
from . import company_bp

# دالة الاتصال بقاعدة بيانات أوراكل باستخدام الإعدادات المعتمدة
def get_db_connection():
    return oracledb.connect(
        user=os.getenv("DB_USER", "MASAR"),
        password=os.getenv("DB_PASSWORD", "24680"),
        dsn=os.getenv("DB_DSN", "localhost:1521/XEPDB1")
    )

# 1. نقطة نهاية تسجيل دخول موظف/مسؤول الشركة (Company Staff Login)
@company_bp.route('/login', methods=['POST'])
def company_login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "الرجاء إدخال البريد الإلكتروني وكلمة المرور"}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        query = """
            SELECT u.USER_ID, u.FULL_NAME, u.EMAIL, cs.COMPANY_ID 
            FROM USERS u
            JOIN COMPANY_STAFF cs ON u.USER_ID = cs.USER_ID
            WHERE u.EMAIL = :email AND u.PASSWORD_HASH = :password AND cs.IS_ACTIVE = 1
        """
        cursor.execute(query, {'email': email, 'password': password})
        staff_member = cursor.fetchone()
        
        cursor.close()
        connection.close()

        if staff_member:
            return jsonify({
                "message": "تم تسجيل الدخول بنجاح",
                "user_id": staff_member[0],
                "full_name": staff_member[1],
                "email": staff_member[2],
                "company_id": staff_member[3]
            }), 200
        else:
            return jsonify({"error": "البريد الإلكتروني أو كلمة المرور غير صحيحة، أو الحساب غير مسجل كمسؤول شركة"}), 401

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 2. نقطة نهاية لجلب معلومات لوحة تحكم الشركة وعروض التدريب الخاصة بها
@company_bp.route('/<int:company_id>/dashboard', methods=['GET'])
def get_company_dashboard(company_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        query = "SELECT OFFER_ID, TITLE, OFFER_STATUS, AVAILABLE_SLOTS FROM INTERNSHIP_OFFERS WHERE COMPANY_ID = :id"
        cursor.execute(query, {'id': company_id})
        rows = cursor.fetchall()

        opportunities = [{
            "offer_id": r[0], 
            "title": r[1], 
            "status": r[2], 
            "available_slots": r[3]
        } for r in rows]

        cursor.close()
        connection.close()

        return jsonify({
            "company_id": company_id,
            "internship_offers": opportunities
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# 3. نقطة نهاية لتحديث بيانات الملف التعريفي للشركة
@company_bp.route('/<int:company_id>/profile', methods=['PUT'])
def update_company_profile(company_id):
    data = request.get_json()
    
    company_name = data.get('company_name')
    slogan = data.get('slogan')
    industry = data.get('industry')
    description = data.get('description')
    city = data.get('city')
    governorate = data.get('governorate')
    address = data.get('address')
    contact_email = data.get('contact_email')
    phone_number = data.get('phone_number')
    website_url = data.get('website_url')

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        query = """
            UPDATE COMPANIES 
            SET COMPANY_NAME = COALESCE(:company_name, COMPANY_NAME),
                SLOGAN = COALESCE(:slogan, SLOGAN),
                INDUSTRY = COALESCE(:industry, INDUSTRY),
                DESCRIPTION = COALESCE(:description, DESCRIPTION),
                CITY = COALESCE(:city, CITY),
                GOVERNORATE = COALESCE(:governorate, GOVERNORATE),
                ADDRESS = COALESCE(:address, ADDRESS),
                CONTACT_EMAIL = COALESCE(:contact_email, CONTACT_EMAIL),
                PHONE_NUMBER = COALESCE(:phone_number, PHONE_NUMBER),
                WEBSITE_URL = COALESCE(:website_url, WEBSITE_URL),
                UPDATED_AT = SYSTIMESTAMP
            WHERE COMPANY_ID = :company_id
        """
        
        cursor.execute(query, {
            'company_name': company_name,
            'slogan': slogan,
            'industry': industry,
            'description': description,
            'city': city,
            'governorate': governorate,
            'address': address,
            'contact_email': contact_email,
            'phone_number': phone_number,
            'website_url': website_url,
            'company_id': company_id
        })
        
        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({
            "message": "تم تحديث الملف التعريفي للشركة بنجاح",
            "company_id": company_id
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
