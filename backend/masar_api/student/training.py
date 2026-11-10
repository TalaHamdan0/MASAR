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