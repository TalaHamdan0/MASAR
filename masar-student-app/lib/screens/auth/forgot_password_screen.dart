
import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Container(
              width: double.infinity,
              color: MasarColors.background,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ==========================================
                    // الجزء العلوي
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        45,
                        24,
                        35,
                      ),
                      decoration: const BoxDecoration(
                        color: MasarColors.primaryBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          // زر الرجوع
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'أدخل البريد الإلكتروني المسجّل بحسابك لاستعادة الوصول إليه',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==========================================
                    // المحتوى
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 35),

                            // أيقونة القفل
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: MasarColors.lightBlue,
                                borderRadius:
                                    BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 50,
                                color:
                                    MasarColors.primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 24),

                            const Text(
                              'استعادة كلمة المرور',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color:
                                    MasarColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'سنرسل رمز تحقق إلى البريد الإلكتروني المسجّل بحسابك لتتمكن من إعادة تعيين كلمة المرور.',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color:
                                    MasarColors.textSecondary,
                                height: 1.7,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 30),

                            // ==========================================
                            // البريد الإلكتروني المسجّل بالحساب
                            // ==========================================
                            TextFormField(
                              controller: _emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: 'البريد الإلكتروني المسجّل بالحساب',
                                hintText:
                                    'example@gmail.com',

                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color:
                                      MasarColors.textSecondary,
                                ),

                                labelStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  color:
                                      MasarColors.textSecondary,
                                ),

                                hintStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  color:
                                      MasarColors.textSecondary,
                                  fontSize: 12,
                                ),

                                filled: true,
                                fillColor:
                                    MasarColors.lightBlue,

                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),

                                enabledBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),

                                focusedBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  borderSide:
                                      const BorderSide(
                                    color:
                                        MasarColors.primaryBlue,
                                    width: 1.2,
                                  ),
                                ),
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'أدخل البريد الإلكتروني المسجّل بالحساب';
                                }

                                final emailRegex = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                );

                                if (value.trim().length > 254 ||
                                    !emailRegex.hasMatch(value.trim())) {
                                  return 'أدخل بريدًا إلكترونيًا صحيحًا';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            // ==========================================
                            // زر إرسال البريد
                            // ==========================================
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _sendEmail,
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      MasarColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'إرسال رمز التحقق',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // العودة لتسجيل الدخول
                            // ==========================================
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'العودة إلى تسجيل الدخول',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color:
                                      MasarColors.primaryBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
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

  // ==========================================
  // إرسال رمز التحقق
  // ==========================================
  void _sendEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    // لاحقًا عند ربط الـ Backend:
    // سيتم إرسال رمز OTP فعليًا إلى البريد الإلكتروني.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyCodeScreen(
          email: email,
        ),
      ),
    );
  }
}
