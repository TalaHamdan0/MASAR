import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================
  // Controllers
  // =========================

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // =========================
  // Form
  // =========================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // =========================
  // Variables
  // =========================

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // =========================
  // Login
  // =========================

void _login() {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  Navigator.pushReplacementNamed(
    context,
    '/home',
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.background,

      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // Welcome
                  // =========================
                  const SizedBox(height: 18),

                  const Text(
                    'مرحبًا بك',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'تابع رحلتك مع "مسار"',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 55),

                  // =========================
                  // Email / University ID
                  // =========================
                  const Text(
                    'البريد الإلكتروني / الرقم الجامعي',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _emailController,

                    keyboardType: TextInputType.emailAddress,

                    textDirection: TextDirection.rtl,

                    style: const TextStyle(
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),

                    decoration: const InputDecoration(
                      hintText: 'أدخل البريد الإلكتروني أو الرقم الجامعي',

                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: MasarColors.textSecondary,
                      ),

                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: MasarColors.primaryBlue,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني أو الرقم الجامعي';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 27),

                  // =========================
                  // Password
                  // =========================
                  const Text(
                    'كلمة المرور',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _passwordController,

                    obscureText: _obscurePassword,

                    textDirection: TextDirection.rtl,

                    style: const TextStyle(
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),

                    decoration: InputDecoration(
                      hintText: 'أدخل كلمة المرور',

                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: MasarColors.textSecondary,
                      ),

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: MasarColors.primaryBlue,
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },

                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,

                          color: MasarColors.primaryGreen,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // Remember Me + Forgot Password
                  // =========================
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _rememberMe,

                              activeColor: MasarColors.primaryGreen,

                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),

                            const Flexible(
                              child: Text(
                                'تذكرني',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: MasarColors.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'استرجاع كلمة المرور سيتم ربطه لاحقًا.',
                              ),
                            ),
                          );
                        },

                        child: const Text(
                          'هل نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MasarColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // =========================
                  // Login Button
                  // =========================
                  SizedBox(
                    height: 54,

                    child: ElevatedButton(
                      onPressed: _login,

                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // Create Account
                  // =========================
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
                            color: MasarColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}