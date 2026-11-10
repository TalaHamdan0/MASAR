import 'package:flutter/material.dart';
import 'package:masar_student_app/screens/profile/change_password_screen.dart';
import '../../theme/masar_theme.dart';


class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() =>
      _VerifyCodeScreenState();
}

class _VerifyCodeScreenState
    extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
                    // =========================
                    // Header
                    // =========================
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
                            'تأكيد البريد الإلكتروني',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'أدخل رمز التحقق المرسل إلى بريدك الإلكتروني',
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

                    // =========================
                    // Body
                    // =========================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            // =========================
                            // Email Icon
                            // =========================
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: MasarColors.lightBlue,
                                borderRadius:
                                    BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 48,
                                color:
                                    MasarColors.primaryBlue,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // =========================
                            // Title
                            // =========================
                            const Text(
                              'تحقق من الكود',
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

                            // =========================
                            // Email
                            // =========================
                            Text(
                              'تم إرسال رمز مكوّن من 6 أرقام إلى:\n'
                              '${widget.email}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color:
                                    MasarColors.textSecondary,
                                height: 1.7,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // =========================
                            // OTP Field
                            // =========================
                            TextFormField(
                              controller: _codeController,
                              keyboardType:
                                  TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 6,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                                color:
                                    MasarColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '------',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  color:
                                      MasarColors.textSecondary,
                                  letterSpacing: 8,
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
                                  borderSide: const BorderSide(
                                    color:
                                        MasarColors.primaryBlue,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'أدخل رمز التحقق';
                                }

                                if (value.trim().length != 6) {
                                  return 'يجب أن يتكون الكود من 6 أرقام';
                                }

                                if (!RegExp(r'^\d{6}$')
                                    .hasMatch(value.trim())) {
                                  return 'أدخل أرقامًا فقط';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            // =========================
                            // Verify Button
                            // =========================
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _verifyCode,
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      MasarColors.primaryBlue,
                                  foregroundColor:
                                      Colors.white,
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
                                      'تأكيد الكود',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 16,
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

                            const SizedBox(height: 15),

                            // =========================
                            // Resend Code
                            // =========================
                            TextButton(
                              onPressed: _resendCode,
                              child: const Text(
                                'إعادة إرسال الكود',
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

  // =========================
  // Verify Code
  // =========================
  void _verifyCode() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // مؤقتًا للتجربة:
    // أي كود مكوّن من 6 أرقام يعتبر صحيحًا.
    //
    // لاحقًا عند ربط الـ Backend:
    // سيتم إرسال الكود للـ API والتحقق منه فعليًا.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(
          isResetPassword: true,
        ),
      ),
    );
  }

  // =========================
  // Resend Code
  // =========================
  void _resendCode() {
    // لاحقًا عند ربط الـ Backend:
    // سيتم إرسال OTP جديد إلى البريد.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'سيتم إرسال كود جديد عند ربط الـ Backend.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}