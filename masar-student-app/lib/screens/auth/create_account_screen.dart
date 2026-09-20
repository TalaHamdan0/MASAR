
import 'package:flutter/material.dart';
import '../../core/models/student_model.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // =========================
  // Controllers
  // =========================

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _universityIdController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // =========================
  // Form
  // =========================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // =========================
  // Password Visibility
  // =========================

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _universityIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================
  // Create Account
  // =========================

  void _createAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Student student = Student(
      id: _universityIdController.text.trim(),
      name: _nameController.text.trim(),

      // University is fixed for the current version.
      university: MasarMockData.universityName,

      // Major will be selected in Complete Profile.
      major: '',

      // Academic year will be selected in Complete Profile.
      academicYear: '',

      email: _emailController.text.trim(),

      // Career path is selected later from Home.
      careerPathId: null,

      // GPA will be added later.
      gpa: '',

      // Skills will be added in Complete Profile.
      skills: const [],

      // No soft skills yet.
      softSkills: const [],

      // Certificates are added later.
      certificates: const [],

      // Projects are added later.
      projects: const [],
    );

    // Save the current student in Mock Data.
    MasarMockData.currentStudent = student;

    // Go to Complete Profile.
    Navigator.pushReplacementNamed(
      context,
      '/complete-profile',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // Back Button
                  // =========================

                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: MasarColors.darkBlue,
                        size: 22,
                      ),
                    ),
                  ),

                  // =========================
                  // Title
                  // =========================

                  const SizedBox(height: 5),

                  const Text(
                    'أنشئ حسابك في MASAR',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'لنبدأ بإعداد حسابك',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =========================
                  // Full Name
                  // =========================

                  const _RequiredLabel(
                    text: 'الاسم الكامل',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nameController,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'أدخل اسمك الكامل',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى إدخال الاسم الكامل';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // University ID
                  // =========================

                  const _RequiredLabel(
                    text: 'الرقم الجامعي',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _universityIdController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'أدخل الرقم الجامعي',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى إدخال الرقم الجامعي';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // University
                  // =========================

                  Card(
                    color: MasarColors.lightBlue,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_outlined,
                            color: MasarColors.primaryBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'الجامعة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        MasarColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  MasarMockData.universityName,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: MasarColors.darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Email
                  // =========================

                  const _RequiredLabel(
                    text: 'البريد الإلكتروني الجامعي',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'أدخل بريدك الإلكتروني الجامعي',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني الجامعي';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Password
                  // =========================

                  const _RequiredLabel(
                    text: 'كلمة المرور',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'أنشئ كلمة مرور',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: MasarColors.primaryBlue,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                                !_obscurePassword;
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

                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Confirm Password
                  // =========================

                  const _RequiredLabel(
                    text: 'تأكيد كلمة المرور',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: MasarColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'أعد إدخال كلمة المرور',
                      prefixIcon: const Icon(
                        Icons.lock_reset_outlined,
                        color: MasarColors.primaryBlue,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: MasarColors.primaryGreen,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى تأكيد كلمة المرور';
                      }

                      if (value != _passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // Create Account Button
                  // =========================

                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            MasarColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'إنشاء الحساب',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Login
                  // =========================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: MasarColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'Cairo',
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
          ),
        ),
      ),
    );
  }
}

// ======================================================
// Required Field Label
// ======================================================

class _RequiredLabel extends StatelessWidget {
  final String text;

  const _RequiredLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MasarColors.darkBlue,
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: MasarColors.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
