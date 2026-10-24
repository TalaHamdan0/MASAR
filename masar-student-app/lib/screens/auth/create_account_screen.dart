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

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  String? _selectedUniversityName;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const TextStyle _fieldStyle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 15,
    color: MasarColors.textPrimary,
  );

  static const List<_UniversityOption> _universities = [
    // الجامعات الحكومية
    _UniversityOption(
      name: 'الجامعة الأردنية',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة اليرموك',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة مؤتة',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة العلوم والتكنولوجيا الأردنية',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'الجامعة الهاشمية',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة آل البيت',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة البلقاء التطبيقية',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة الحسين بن طلال',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'جامعة الطفيلة التقنية',
      category: 'حكومية',
    ),
    _UniversityOption(
      name: 'الجامعة الألمانية الأردنية',
      category: 'حكومية',
    ),

    // الجامعات الخاصة
    _UniversityOption(
      name: 'جامعة عمان العربية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة الشرق الأوسط',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة جدارا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة عمان الأهلية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة العلوم التطبيقية الخاصة',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة فيلادلفيا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة الإسراء',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة البترا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة الزيتونة الأردنية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة جرش',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة إربد الأهلية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة الزرقاء',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة الأميرة سمية للتكنولوجيا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'الجامعة الأمريكية في مادبا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة عجلون الوطنية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة العقبة للتكنولوجيا',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة العقبة للعلوم الطبية',
      category: 'خاصة',
    ),
    _UniversityOption(
      name: 'جامعة ابن سينا للعلوم الطبية',
      category: 'خاصة',
    ),

    // جامعات ذات قانون خاص
    _UniversityOption(
      name: 'جامعة العلوم الإسلامية العالمية',
      category: 'ذات قانون خاص',
    ),
    _UniversityOption(
      name: 'جامعة الحسين التقنية',
      category: 'ذات قانون خاص',
    ),

    // الجامعات الإقليمية العاملة في الأردن
    _UniversityOption(
      name: 'الجامعة العربية المفتوحة - الأردن',
      category: 'إقليمية',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _universityIdController.dispose();
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
            style: const TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );
  }

  Future<void> _createAccount() async {
    if (_isLoading) {
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final universityName = _selectedUniversityName;

    if (universityName == null) {
      _showMessage('يرجى اختيار الجامعة');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.register(
        name: _nameController.text,
        studentNumber: _universityIdController.text,
        universityName: universityName,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      final student = AuthSession.start(data);

      // بيانات الطالب القادمة من الباكند.
      MasarMockData.currentStudent = student;
      MasarMockData.student = student;
      MasarMockData.isFirstLogin = true;

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
      _confirmPasswordController.clear();

      Navigator.pushReplacementNamed(
        context,
        '/complete-profile',
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
        'تعذر إكمال إنشاء الحساب. حاولي لاحقًا.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        // الرجوع
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

                        // الاسم الكامل
                        const _RequiredLabel(
                          text: 'الاسم الكامل',
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _nameController,
                          enabled: !_isLoading,
                          textDirection: TextDirection.rtl,
                          textInputAction: TextInputAction.next,
                          style: _fieldStyle,
                          decoration: const InputDecoration(
                            hintText: 'أدخل اسمك الكامل',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: MasarColors.primaryBlue,
                            ),
                          ),
                          validator: (value) {
                            final name = value?.trim() ?? '';

                            if (name.isEmpty) {
                              return 'يرجى إدخال الاسم الكامل';
                            }

                            if (name.length > 120) {
                              return 'الحد الأقصى للاسم 120 حرفًا';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // الرقم الجامعي
                        const _RequiredLabel(
                          text: 'الرقم الجامعي',
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _universityIdController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.next,
                          style: _fieldStyle,
                          decoration: const InputDecoration(
                            hintText: 'أدخل الرقم الجامعي',
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                              color: MasarColors.primaryBlue,
                            ),
                          ),
                          validator: (value) {
                            final number = value?.trim() ?? '';

                            if (number.isEmpty) {
                              return 'يرجى إدخال الرقم الجامعي';
                            }

                            if (number.length > 40 ||
                                RegExp(r'\s').hasMatch(number)) {
                              return 'رقم جامعي حتى 40 خانة بدون مسافات';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // اختيار الجامعة
                        const _RequiredLabel(
                          text: 'الجامعة',
                        ),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedUniversityName,
                          isExpanded: true,
                          menuMaxHeight: 360,
                          itemHeight: 76,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          style: _fieldStyle,
                          decoration: const InputDecoration(
                            hintText: 'اختر جامعتك',
                            prefixIcon: Icon(
                              Icons.account_balance_outlined,
                              color: MasarColors.primaryBlue,
                            ),
                            errorMaxLines: 2,
                          ),
                          selectedItemBuilder: (context) {
                            return _universities.map((university) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  university.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: MasarColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          items: _universities.map((university) {
                            return DropdownMenuItem<String>(
                              value: university.name,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    university.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: MasarColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    university.category,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      color: MasarColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedUniversityName = value;
                                  });
                                },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى اختيار الجامعة';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // البريد الإلكتروني الشخصي
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
                          style: _fieldStyle,
                          decoration: const InputDecoration(
                            hintText: 'example@gmail.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: MasarColors.primaryBlue,
                            ),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';

                            if (email.isEmpty) {
                              return 'يرجى إدخال بريدك الإلكتروني الشخصي';
                            }

                            final pattern = RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            );

                            if (email.length > 254 ||
                                !pattern.hasMatch(email)) {
                              return 'يرجى إدخال بريد إلكتروني صحيح';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // كلمة المرور
                        const _RequiredLabel(
                          text: 'كلمة المرور',
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: _fieldStyle,
                          decoration: InputDecoration(
                            hintText: 'أنشئ كلمة مرور',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: MasarColors.primaryBlue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
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
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }

                            if (value.characters.length < 8 ||
                                value.characters.length > 10) {
                              return 'كلمة المرور من 8 إلى 10 خانات';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // تأكيد كلمة المرور
                        const _RequiredLabel(
                          text: 'تأكيد كلمة المرور',
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _confirmPasswordController,
                          enabled: !_isLoading,
                          obscureText: _obscureConfirmPassword,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onFieldSubmitted: (_) {
                            _createAccount();
                          },
                          style: _fieldStyle,
                          decoration: InputDecoration(
                            hintText: 'أعد إدخال كلمة المرور',
                            prefixIcon: const Icon(
                              Icons.lock_reset_outlined,
                              color: MasarColors.primaryBlue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
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

                        // زر إنشاء الحساب
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed:
                                _isLoading ? null : _createAccount,
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  MasarColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
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

                        // تسجيل الدخول
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
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

class _UniversityOption {
  final String name;
  final String category;

  const _UniversityOption({
    required this.name,
    required this.category,
  });
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