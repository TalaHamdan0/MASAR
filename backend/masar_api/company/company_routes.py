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