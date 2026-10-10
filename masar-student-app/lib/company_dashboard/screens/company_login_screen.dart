import 'package:flutter/material.dart';
import 'company_home_screen.dart';
import 'company_main_layout.dart';

class CompanyLoginScreen extends StatefulWidget {
  const CompanyLoginScreen({super.key});

  @override
  State<CompanyLoginScreen> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<CompanyLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CompanyMainLayout(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // الشعار
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/masar_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.route_rounded,
                                  color: Color(0xFF1565C0),
                                  size: 36,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // العناوين
                    const Text(
                      'بوابة الشركة / جهة التدريب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'إدارة شواغر التدريب ومتابعة طلبات الطلاب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // حقل البريد الإلكتروني (المعدل مع شرط الصيغة الرسمية)
                    const Text(
                      'البريد الإلكتروني للشركة / مسؤول التوظيف',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        // شرط التحقق من صيغة الإيميل الرسمي
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'يرجى إدخال بريد إلكتروني صحيح (مثال: hr@company.com)';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'hr@company.com',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF1565C0),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // حقل كلمة المرور (رجع كما كان في الأصل مع شرط إدخال أي قيمة فقط)
                    const Text(
                      'كلمة المرور',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF1565C0),
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF6B7280),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // زر تسجيل الدخول
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // البوكس الأخضر السفلي
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF059669),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'للتجربة استخدم:',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'البريد: hr@company.com',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                                Text(
                                  'كلمة المرور: 123456',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
