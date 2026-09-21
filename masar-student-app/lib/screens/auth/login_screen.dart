
import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
import 'forgot_password_screen.dart';
import '../../data/masar_mock_data.dart';
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool obscurePassword = true;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // الجزء العلوي المنحني
                    // ==========================================
                    Stack(
                      children: [
                        ClipPath(
                          clipper: HeaderClipper(),
                          child: Container(
                            height: 340,
                            color: MasarColors.primaryBlue,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 60,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // ==========================================
                              // شعار تطبيق مسار
                              // ==========================================
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'assets/images/masar_logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  const Text(
                                    'MASAR',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),

                              // ==========================================
                              // عنوان الترحيب
                              // ==========================================
                              const SizedBox(height: 28),

                              const Text(
                                'مرحباً بعودتك',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'سجّل الدخول للمتابعة إلى حسابك',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ==========================================
                    // حقول تسجيل الدخول
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 20),

                          // ==========================================
                          // الرقم الجامعي أو البريد الإلكتروني
                          // ==========================================
                          const TextField(
                            textDirection: TextDirection.ltr,
                            keyboardType:
                                TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText:
                                  'الرقم الجامعي أو البريد الإلكتروني',
                              hintText:
                                  'الرقم الجامعي أو you@gmail.com',

                              prefixIcon: Icon(
                                Icons.person_outline,
                                color:
                                    MasarColors.textSecondary,
                              ),

                              labelStyle: TextStyle(
                                fontFamily: 'Cairo',
                                color:
                                    MasarColors.textSecondary,
                                fontSize: 13,
                              ),

                              hintStyle: TextStyle(
                                fontFamily: 'Cairo',
                                color:
                                    MasarColors.textSecondary,
                                fontSize: 12,
                              ),

                              filled: true,
                              fillColor: MasarColors.lightBlue,

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),

                              enabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),

                              focusedBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(
                                  color:
                                      MasarColors.primaryBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ==========================================
                          // كلمة المرور
                          // ==========================================
                          TextField(
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              hintText: 'أدخل كلمة المرور',

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color:
                                    MasarColors.textSecondary,
                              ),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                  color:
                                      MasarColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },
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
                              ),

                              filled: true,
                              fillColor: MasarColors.lightBlue,

                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),

                              enabledBorder:
                                  const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),

                              focusedBorder:
                                  const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(
                                  color:
                                      MasarColors.primaryBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==========================================
                          // تذكرني + نسيت كلمة المرور
                          // ==========================================
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              // نسيت كلمة المرور
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color:
                                        MasarColors.primaryBlue,
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),

                              // تذكرني
                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  const Text(
                                    'تذكرني',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color:
                                          MasarColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),

                                  Checkbox(
                                    value: rememberMe,
                                    activeColor:
                                        MasarColors.primaryBlue,
                                    checkColor: Colors.white,
                                    side: const BorderSide(
                                      color: MasarColors.border,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ==========================================
                          // زر تسجيل الدخول
                          // ==========================================
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (MasarMockData.isFirstLogin) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/complete-profile',
                                  );
                                } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home',
                                    );
                                  }
                              },
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
                                    'تسجيل الدخول',
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

                          // ==========================================
                          // إنشاء حساب
                          // ==========================================
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                fontSize: 14,
                                color: MasarColors.textSecondary,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateAccountScreen(),
                                    ),
                                  );
                                },

                                child: const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: MasarColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
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

// ==========================================================
// الانحناء في الجزء العلوي
// ==========================================================

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(
      0,
      size.height - 50,
    );

    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}
