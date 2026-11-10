<<<<<<< HEAD
from flask import Blueprint, request, jsonify
from . import student_bp

@student_bp.post("/training/apply")
def apply_for_training():
    token = bearer_token()
    if not token:
        return _error("يرجى تسجيل الدخول أولًا.", 401)

    data = request.get_json() or {}
    
    # دعم استقبال offer_id أو opportunity_id لمرونة الربط مع الواجهة
    offer_id = data.get("offer_id") or data.get("opportunity_id")

    if not offer_id:
        return _error("رقم فرصة التدريب مطلوب.", 400)

    try:
        offer_id = int(offer_id)
        if offer_id <= 0:
            raise ValueError
    except (ValueError, TypeError):
        return _error("رقم فرصة التدريب غير صالح.", 400)

    with get_connection() as connection:
        cursor = connection.cursor()
        try:
            # التحقق من هوية الطالب من خلال الـ Token وجلسة الدخول
            student_id = session_user(cursor, token)
            if student_id is None:
                return _error("جلسة المستخدم غير صالحة أو انتهت.", 401)

            # 1. التأكد أن فرصة التدريب موجودة ومتاحة (تخضع لشروط OFFER_FILTER)
            cursor.execute(
                f"""
                SELECT o.offer_id
                FROM internship_offers o
                JOIN companies c ON c.company_id = o.company_id
                WHERE o.offer_id = :offer_id AND {OFFER_FILTER}
                """,
                {"offer_id": offer_id}
            )
            offer = cursor.fetchone()
            if not offer:
                return _error("فرصة التدريب غير موجودة أو غير متاحة للتقديم.", 404)

            # 2. منع التقديم المكرر: التحقق هل الطالب قدم مسبقاً على نفس الفرصة
            cursor.execute(
                """
                SELECT application_id 
                FROM training_applications
                WHERE student_id = :student_id AND offer_id = :offer_id
                """,
                {"student_id": student_id, "offer_id": offer_id}
            )
            existing = cursor.fetchone()
            if existing:
                return _error("لقد قمت بالتقديم على هذه الفرصة التدريبية مسبقاً.", 400)

            # 3. إدخال الطلب الجديد في جدول training_applications في قاعدة بيانات Oracle
            cursor.execute(
                """
                INSERT INTO training_applications (student_id, offer_id, status, created_at)
                VALUES (:student_id, :offer_id, 'قيد المراجعة', CURRENT_TIMESTAMP)
                """,
                {"student_id": student_id, "offer_id": offer_id}
            )
            connection.commit()

            return jsonify({
                "success": True,
                "message": "تم تقديم طلب التدريب بنجاح"
            }), 201

        except Exception as e:
            connection.rollback()
            return _error(f"حدث خطأ أثناء حفظ الطلب: {str(e)}", 500)
        finally:
            cursor.close()


@student_bp.get("/training/applications")
def get_student_applications():
    token = bearer_token()
    if not token:
        return _error("يرجى تسجيل الدخول أولًا.", 401)

    with get_connection() as connection:
        cursor = connection.cursor()
        try:
            student_id = session_user(cursor, token)
            if student_id is None:
                return _error("جلسة المستخدم غير صالحة أو انتهت.", 401)

            # استعراض طلبات الطالب الخاصة به فقط (متابعة الطلبات)
            cursor.execute(
                """
                SELECT
                    a.application_id,
                    a.offer_id,
                    o.title AS opportunity_title,
                    c.company_name,
                    a.status,
                    a.created_at
                FROM training_applications a
                JOIN internship_offers o ON o.offer_id = a.offer_id
                JOIN companies c ON c.company_id = o.company_id
                WHERE a.student_id = :student_id
                ORDER BY a.created_at DESC
                """,
                {"student_id": student_id}
            )
            applications = _rows_as_dicts(cursor)

            return jsonify({
                "data": applications,
                "total": len(applications)
            })

        except Exception as e:
            return _error(f"حدث خطأ أثناء جلب الطلبات: {str(e)}", 500)
        finally:
            cursor.close()
=======

from datetime import date, datetime

from flask import jsonify, request

from ..authentication import bearer_token, session_user
from ..database import get_connection
from . import student_bp

# Only open offers from active, verified companies.
OFFER_FILTER = """
    o.offer_status = 'OPEN'
    AND c.company_status = 'ACTIVE'
    AND c.verification_status = 'VERIFIED'
"""


def _error(message, status_code):
    return jsonify({"message": message}), status_code


def _value(value):
    if value is None:
        return None

    if hasattr(value, "read"):
        value = value.read()

    if isinstance(value, (date, datetime)):
        return value.isoformat()

    return value


def _rows_as_dicts(cursor):
    columns = [
        column[0].lower()
        for column in cursor.description
    ]

    return [
        {
            column: _value(value)
            for column, value in zip(columns, row)
        }
        for row in cursor.fetchall()
    ]


def _authorized_cursor(connection):
    token = bearer_token()

    if not token:
        return None

    cursor = connection.cursor()
    try:
        user_id = session_user(cursor, token)

        if user_id is None:
            cursor.close()
            return None

        return cursor
    except Exception:
        cursor.close()
        raise


@student_bp.get("/training/tracks")
def get_training_tracks():
    with get_connection() as connection:
        cursor = _authorized_cursor(connection)

        if cursor is None:
            return _error("يرجى تسجيل الدخول أولًا.", 401)

        with cursor:
            cursor.execute("""
                SELECT
                    training_track_id,
                    track_name,
                    career_path_id
                FROM training_tracks
                WHERE is_active = 1
                ORDER BY track_name
            """)

            tracks = _rows_as_dicts(cursor)

    return jsonify({
        "data": tracks,
        "total": len(tracks),
    })


@student_bp.get("/training/offers")
def get_training_offers():
    try:
        page = int(request.args.get("page", "1"))
        page_size = int(request.args.get("page_size", "20"))

        if page < 1 or not 1 <= page_size <= 100:
            raise ValueError

    except (ValueError, TypeError):
        return _error(
            "رقم الصفحة أو حجم الصفحة غير صالح.",
            400,
        )

    search = request.args.get("search", "").strip()
    governorate = request.args.get(
        "governorate", ""
    ).strip()

    track_id_text = request.args.get(
        "track_id", ""
    ).strip()

    track_id = None

    if track_id_text:
        try:
            track_id = int(track_id_text)

            if track_id <= 0:
                raise ValueError

        except ValueError:
            return _error(
                "رقم المسار التدريبي غير صالح.",
                400,
            )

    if len(search) > 200 or len(governorate) > 100:
        return _error(
            "قيمة البحث أو المحافظة طويلة جدًا.",
            400,
        )

    conditions = [OFFER_FILTER]
    params = {}

    if search:
        conditions.append("""
            (
                LOWER(o.title) LIKE :search
                OR LOWER(c.company_name) LIKE :search
                OR LOWER(t.track_name) LIKE :search
            )
        """)
        params["search"] = (
            "%" + search.lower() + "%"
        )

    if governorate:
        conditions.append("""
            LOWER(
                COALESCE(
                    o.governorate,
                    c.governorate
                )
            ) = :governorate
        """)
        params["governorate"] = governorate.lower()

    if track_id is not None:
        conditions.append(
            "o.training_track_id = :track_id"
        )
        params["track_id"] = track_id

    where_clause = " AND ".join(
        f"({condition})"
        for condition in conditions
    )

    from_clause = """
        FROM internship_offers o
        JOIN companies c
            ON c.company_id = o.company_id
        LEFT JOIN training_tracks t
            ON t.training_track_id =
               o.training_track_id
    """

    with get_connection() as connection:
        cursor = _authorized_cursor(connection)

        if cursor is None:
            return _error(
                "يرجى تسجيل الدخول أولًا.",
                401,
            )

        with cursor:
            cursor.execute(
                f"""
                SELECT COUNT(*)
                {from_clause}
                WHERE {where_clause}
                """,
                params,
            )

            total = int(cursor.fetchone()[0])

            query_params = dict(params)
            query_params["offset"] = (
                page - 1
            ) * page_size
            query_params["page_size"] = page_size

            cursor.execute(
                f"""
                SELECT
                    o.offer_id,
                    o.company_id,
                    c.company_name,
                    c.industry,
                    c.city AS company_city,
                    o.training_track_id,
                    t.track_name,
                    o.title,
                    o.city,
                    COALESCE(
                        o.governorate,
                        c.governorate
                    ) AS governorate,
                    o.location,
                    o.work_mode,
                    o.available_slots,
                    o.required_hours,
                    o.start_date,
                    o.end_date,
                    o.application_deadline,
                    o.offer_status,
                    o.published_at
                {from_clause}
                WHERE {where_clause}
                ORDER BY
                    o.published_at DESC NULLS LAST,
                    o.offer_id DESC
                OFFSET :offset ROWS
                FETCH NEXT :page_size ROWS ONLY
                """,
                query_params,
            )

            offers = _rows_as_dicts(cursor)

    return jsonify({
        "data": offers,
        "total": total,
        "page": page,
        "page_size": page_size,
        "total_pages": (
            total + page_size - 1
        ) // page_size,
    })


@student_bp.get("/training/offers/<int:offer_id>")
def get_training_offer_details(offer_id):
    if offer_id <= 0:
        return _error(
            "رقم فرصة التدريب غير صالح.",
            400,
        )

    with get_connection() as connection:
        cursor = _authorized_cursor(connection)

        if cursor is None:
            return _error(
                "يرجى تسجيل الدخول أولًا.",
                401,
            )

        with cursor:
            cursor.execute(
                f"""
                SELECT
                    o.offer_id,
                    o.company_id,
                    c.company_name,
                    c.slogan AS company_slogan,
                    c.industry,
                    c.description
                        AS company_description,
                    c.city AS company_city,
                    c.address AS company_address,
                    c.website_url,
                    c.contact_email,
                    c.phone_number,
                    c.logo_file_id,
                    o.training_track_id,
                    t.track_name,
                    o.title,
                    o.description,
                    o.requirements,
                    o.learning_outcomes,
                    o.location,
                    o.city,
                    COALESCE(
                        o.governorate,
                        c.governorate
                    ) AS governorate,
                    o.work_mode,
                    o.available_slots,
                    o.required_hours,
                    o.start_date,
                    o.end_date,
                    o.application_deadline,
                    o.offer_status,
                    o.published_at
                FROM internship_offers o
                JOIN companies c
                    ON c.company_id = o.company_id
                LEFT JOIN training_tracks t
                    ON t.training_track_id =
                       o.training_track_id
                WHERE o.offer_id = :offer_id
                  AND {OFFER_FILTER}
                """,
                {"offer_id": offer_id},
            )

            offers = _rows_as_dicts(cursor)

    if not offers:
        return _error(
            "فرصة التدريب غير موجودة أو غير متاحة.",
            404,
        )

    return jsonify({
        "data": offers[0],
    })
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
