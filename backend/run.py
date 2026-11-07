from flask import Flask
# استيراد الـ Blueprint الخاص بالشركة مباشرة من الحزمة
from masar_api.company import company_bp

app = Flask(__name__)

# تسجيل الـ Blueprint في التطبيق الرئيسي
app.register_blueprint(company_bp)

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)