import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState
    extends State<CreateAccountScreen> {
  static const String _universityName =
      'جامعة العلوم الإسلامية العالمية';

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _studentNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'يرجى إدخال الاسم الكامل بالعربي';
    }

    if (name.runes.length < 2 || name.runes.length > 200) {
      return 'الاسم من حرفين إلى 200 حرف';
    }

    return null;
  }

  String? _validateEnglishName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'يرجى إدخال الاسم الكامل بالإنجليزي';
    }

    if (name.length > 200) {
      return 'الحد الأقصى للاسم 200 حرف';
    }

    if (!RegExp(r"^[A-Za-z][A-Za-z .'-]*$").hasMatch(name) ||
        RegExp(r'[A-Za-z]').allMatches(name).length < 2) {
      return 'اكتبي الاسم باستخدام الحروف الإنجليزية';
    }

    return null;
  }

  Future<void> _createAccount() async {
    if (_isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.register(
        name: _nameController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        studentNumber: _studentNumberController.text.trim(),
        universityName: _universityName,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      final student = AuthSession.start(data);

      MasarMockData.currentStudent = student;
      MasarMockData.student = student;
      MasarMockData.isFirstLogin = true;

      MasarMockData.profileMockData.addAll({
        'name': student.name,
        'nameEn': student.nameEn,
        'major': student.major,
        'university': student.university,
        'academicYear': student.academicYear,
        'email': student.email,
        'studentNumber': _studentNumberController.text.trim(),
        'careerPath': student.careerPathId,
      });

      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.pushReplacementNamed(
        context,
        '/complete-profile',
      );
    } on ApiException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on FormatException {
      if (mounted) {
        _showMessage(
          'وصلت بيانات طالب غير مكتملة من الباكند.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'تعذر إكمال إنشاء الحساب. حاولي لاحقًا.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _decoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: MasarColors.primaryBlue,
      ),
    );
  }

  Widget _passwordField({required bool confirmation}) {
    final controller = confirmation
        ? _confirmPasswordController
        : _passwordController;

    final obscure = confirmation
        ? _obscureConfirmPassword
        : _obscurePassword;

    return TextFormField(
      controller: controller,
      enabled: !_isLoading,
      obscureText: obscure,
      textDirection: TextDirection.ltr,
      textInputAction: confirmation
          ? TextInputAction.done
          : TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      onFieldSubmitted: confirmation
          ? (_) {
              _createAccount();
            }
          : null,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        color: MasarColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: confirmation
            ? 'أعد إدخال كلمة المرور'
            : 'أنشئ كلمة مرور',
        prefixIcon: Icon(
          confirmation ? Icons.lock_reset_outlined : Icons.lock_outline,
          color: MasarColors.primaryBlue,
        ),
        suffixIcon: IconButton(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    if (confirmation) {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    } else {
                      _obscurePassword = !_obscurePassword;
                    }
                  });
                },
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: MasarColors.primaryGreen,
          ),
        ),
      ),
      validator: (value) {
        if (confirmation) {
          if (value == null || value.isEmpty) {
            return 'يرجى تأكيد كلمة المرور';
          }

          if (value != _passwordController.text) {
            return 'كلمتا المرور غير متطابقتين';
          }

          return null;
        }

        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال كلمة المرور';
        }

        if (value.runes.length < 8 || value.runes.length > 10) {
          return 'كلمة المرور من 8 إلى 10 خانات';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Container(
              width: double.infinity,
              color: MasarColors.background,
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: MasarColors.darkBlue,
                              size: 22,
                            ),
                          ),
                        ),
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
                        const _RequiredLabel(
                          text: 'الاسم الكامل بالعربي',
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          enabled: !_isLoading,
                          textDirection: TextDirection.rtl,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            color: MasarColors.textPrimary,
                          ),
                          decoration: _decoration(
                            'أدخل اسمك الكامل بالعربي',
                            Icons.person_outline,
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 20),
                        const _RequiredLabel(
                          text: 'الاسم الكامل بالإنجليزي',
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameEnController,
                          enabled: !_isLoading,
                          textDirection: TextDirection.ltr,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            color: MasarColors.textPrimary,
                          ),
                          decoration: _decoration(
                            'أدخل اسمك الكامل بالإنجليزي',
                            Icons.person_outline,
                          ),
                          validator: _validateEnglishName,
                        ),
                        const SizedBox(height: 20),
                        const _RequiredLabel(
                          text: 'الرقم الجامعي',
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _studentNumberController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(40),
                          ],
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            color: MasarColors.textPrimary,
                          ),
                          decoration: _decoration(
                            'أدخل الرقم الجامعي',
                            Icons.badge_outlined,
                          ),
                          validator: (value) {
                            final number = value?.trim() ?? '';

                            if (number.isEmpty) {
                              return 'يرجى إدخال الرقم الجامعي';
                            }

                            if (!RegExp(
                              r'^[0-9]{1,40}$',
                            ).hasMatch(number)) {
                              return 'يرجى إدخال رقم جامعي صحيح';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'الجامعة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MasarColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _universityName,
                          readOnly: true,
                          enableInteractiveSelection: false,
                          maxLines: 2,
                          minLines: 1,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: MasarColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.account_balance_outlined,
                              color: MasarColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const _RequiredLabel(
                          text: 'البريد الإلكتروني الشخصي',
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            color: MasarColors.textPrimary,
                          ),
                          decoration: _decoration(
                            'example@gmail.com',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني الشخصي';
                            }

                            if (email.length > 254 ||
                                !RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                ).hasMatch(email)) {
                              return 'يرجى إدخال بريد إلكتروني صحيح';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const _RequiredLabel(
                          text: 'كلمة المرور',
                        ),
                        const SizedBox(height: 8),
                        _passwordField(confirmation: false),
                        const SizedBox(height: 20),
                        const _RequiredLabel(
                          text: 'تأكيد كلمة المرور',
                        ),
                        const SizedBox(height: 8),
                        _passwordField(confirmation: true),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed:
                                _isLoading ? null : _createAccount,
                            style: FilledButton.styleFrom(
                              backgroundColor: MasarColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
                              onPressed: _isLoading
                                  ? null
                                  : () {
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
          ),
        ),
      ),
    );
  }
}

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