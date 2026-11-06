
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../theme/masar_theme.dart';
import '../../core/services/auth_session.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isResetPassword;

  const ChangePasswordScreen({
    super.key,
    this.isResetPassword = false,
  });

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController =
      TextEditingController();

  final _newPasswordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isSaving = false;

  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5010',
  );

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
  }

  String _errorMessage(
    int statusCode,
    String responseBody,
  ) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];

        if (error is Map) {
          final message = error['message'];

          if (message is String && message.isNotEmpty) {
            return message;
          }
        }

        final message = decoded['message'];

        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      // Use the fallback message.
    }

    if (statusCode == 401) {
      return 'انتهت الجلسة، سجّل الدخول مجددًا.';
    }

    if (statusCode >= 500) {
      return 'حدث خطأ في الخادم. حاول مرة أخرى.';
    }

    return 'تعذّر تغيير كلمة المرور. حاول مرة أخرى.';
  }

  Future<void> _changePassword() async {
    if (_isSaving) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (widget.isResetPassword) {
      _showMessage(
        'إعادة تعيين كلمة المرور تحتاج التحقق برمز الاستعادة أولًا.',
      );
      return;
    }

    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      _showMessage(
        'انتهت الجلسة، سجّل الدخول مجددًا.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse(
              '$_apiBaseUrl/api/v1/auth/change-password',
            ),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'currentPassword':
                  _currentPasswordController.text,
              'newPassword':
                  _newPasswordController.text,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;
debugPrint('MASAR CHANGE PASSWORD STATUS: ${response.statusCode}');
debugPrint('MASAR CHANGE PASSWORD RESPONSE: ${response.body}');
      if (response.statusCode == 200) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        _showMessage(
          'تم تغيير كلمة المرور بنجاح.',
        );

        return;
      }

      _showMessage(
        _errorMessage(
          response.statusCode,
          response.body,
        ),
      );
    } on TimeoutException {
      _showMessage(
        'انتهت مهلة الاتصال بالخادم. حاول مرة أخرى.',
      );
    } on http.ClientException {
      _showMessage(
        'تعذّر الاتصال بالخادم. تأكد من تشغيل الـ Backend.',
      );
    } catch (_) {
      _showMessage(
        'حدث خطأ أثناء تغيير كلمة المرور.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _passwordDecoration({
    required String label,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: 'Cairo',
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          visible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
      filled: true,
      fillColor: MasarColors.lightBlue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: MasarColors.primaryBlue,
          width: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isReset = widget.isResetPassword;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_right,
              size: 30,
              color: MasarColors.darkBlue,
            ),
          ),
          title: Text(
            isReset
                ? 'إعادة تعيين كلمة المرور'
                : 'تغيير كلمة المرور',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Container(
              width: double.infinity,
              color: MasarColors.background,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),

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
                          size: 48,
                          color: MasarColors.primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        isReset
                            ? 'إنشاء كلمة مرور جديدة'
                            : 'تغيير كلمة المرور',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MasarColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        isReset
                            ? 'أدخل كلمة المرور الجديدة لحسابك'
                            : 'يمكنك تغيير كلمة المرور الحالية من هنا',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: MasarColors.textSecondary,
                          height: 1.7,
                        ),
                      ),

                      const SizedBox(height: 30),

                      if (!isReset) ...[
                        TextFormField(
                          controller:
                              _currentPasswordController,
                          obscureText:
                              !_showCurrentPassword,
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: _passwordDecoration(
                            label: 'كلمة المرور الحالية',
                            visible: _showCurrentPassword,
                            onToggle: () {
                              setState(() {
                                _showCurrentPassword =
                                    !_showCurrentPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'أدخل كلمة المرور الحالية';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),
                      ],

                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_showNewPassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: _passwordDecoration(
                          label: 'كلمة المرور الجديدة',
                          visible: _showNewPassword,
                          onToggle: () {
                            setState(() {
                              _showNewPassword =
                                  !_showNewPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'أدخل كلمة المرور الجديدة';
                          }

                          if (value.length < 8 ||
                              value.length > 10) {
                            return 'كلمة المرور من 8 إلى 10 خانات';
                          }

                          if (!isReset &&
                              value ==
                                  _currentPasswordController
                                      .text) {
                            return 'كلمة المرور الجديدة يجب أن تختلف عن الحالية';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller:
                            _confirmPasswordController,
                        obscureText:
                            !_showConfirmPassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: _passwordDecoration(
                          label: 'تأكيد كلمة المرور الجديدة',
                          visible: _showConfirmPassword,
                          onToggle: () {
                            setState(() {
                              _showConfirmPassword =
                                  !_showConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'أكد كلمة المرور الجديدة';
                          }

                          if (value !=
                              _newPasswordController.text) {
                            return 'كلمتا المرور غير متطابقتين';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : _changePassword,
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
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isReset
                                          ? 'حفظ كلمة المرور'
                                          : 'تغيير كلمة المرور',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
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
