import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/student_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/demo_mode.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

import 'create_account_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );
  }

  String? _validateInputs() {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني أو الرقم الجامعي.';
    }

    if (identifier.contains('@')) {
      final emailPattern = RegExp(
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      );

      if (identifier.length > 254 ||
          !emailPattern.hasMatch(identifier)) {
        return 'يرجى إدخال بريد إلكتروني صحيح.';
      }
    } else {
      if (identifier.length > 40 ||
          RegExp(r'\s').hasMatch(identifier)) {
        return 'يرجى إدخال رقم جامعي صحيح بدون مسافات.';
      }
    }

    if (password.trim().isEmpty) {
      return 'يرجى إدخال كلمة المرور.';
    }

    if (password.characters.length < 8 ||
        password.characters.length > 10) {
      return 'كلمة المرور يجب أن تكون من 8 إلى 10 خانات.';
    }

    return null;
  }

  Future<void> _login() async {
    if (_isLoading) {
      return;
    }

    final validationMessage = _validateInputs();

    if (validationMessage != null) {
      _showMessage(validationMessage);
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      if (DemoMode.enabled) {
        _startDemoSession();
        return;
      }

      final data = await ApiService.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
        rememberMe: rememberMe,
      );

      if (!mounted) {
        return;
      }

      final student = AuthSession.start(data);

      MasarMockData.currentStudent = student;
      MasarMockData.student = student;
      MasarMockData.isFirstLogin = false;

      MasarMockData.profileMockData.addAll({
        'name': student.name,
        'major': student.major,
        'university': student.university,
        'academicYear': student.academicYear,
        'email': student.email,
        'gpa': student.gpa,
        'careerPath': student.careerPathId,
      });

      _passwordController.clear();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message);
    } on FormatException {
      if (!mounted) {
        return;
      }

      _showMessage(
        'وصلت بيانات طالب غير مكتملة من الباكند.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'تعذر إكمال تسجيل الدخول. حاولي مجددًا.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startDemoSession() {
    final identifier =
        _identifierController.text.trim().toLowerCase();

    final password = _passwordController.text;

    final validIdentifier =
        identifier == DemoMode.studentEmail ||
        identifier == DemoMode.studentNumber;

    if (!validIdentifier ||
        password != DemoMode.studentPassword) {
      throw const ApiException(
        'استخدمي بريد أو رقم حساب العرض التجريبي وكلمة المرور المحددة.',
      );
    }

    AuthSession.clear();

    final student = Student(
      id: 'demo_student_001',
      name: 'ليان أحمد',
      major: 'علم البيانات',
      university: MasarMockData.universityName,
      academicYear: 'السنة الثالثة',
      email: DemoMode.studentEmail,
      careerPathId: 'data_analyst',
      gpa: '3.2',
      skills: List.of(MasarMockData.skills),
      softSkills: List.of(MasarMockData.softSkills),
      certificates: List.of(MasarMockData.certificates),
      projects: List.of(MasarMockData.projects),
    );

    MasarMockData.student = student;
    MasarMockData.updateStudent(student);
    MasarMockData.isFirstLogin = false;

    _passwordController.clear();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                DemoMode.enabled
                                    ? 'عرض تجريبي ببيانات طالب تجريبية'
                                    : 'سجّل الدخول للمتابعة إلى حسابك',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: _identifierController,
                            enabled: !_isLoading,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              labelText:
                                  'الرقم الجامعي أو البريد الإلكتروني',
                              hintText:
                                  'الرقم الجامعي أو you@gmail.com',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: MasarColors.textSecondary,
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.textSecondary,
                                fontSize: 13,
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.textSecondary,
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: MasarColors.lightBlue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(
                                  color: MasarColors.primaryBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            enabled: !_isLoading,
                            obscureText: obscurePassword,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onSubmitted: (_) {
                              _login();
                            },
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              hintText: 'أدخل كلمة المرور',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: MasarColors.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: MasarColors.textSecondary,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          obscurePassword =
                                              !obscurePassword;
                                        });
                                      },
                              ),
                              labelStyle: const TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.textSecondary,
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: MasarColors.lightBlue,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder:
                                  const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                borderSide: BorderSide(
                                  color: MasarColors.primaryBlue,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
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
                                    color: MasarColors.primaryBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5),
                                    ),
                                    onChanged: _isLoading
                                        ? null
                                        : (value) {
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
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    MasarColors.primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
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
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MasarColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
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