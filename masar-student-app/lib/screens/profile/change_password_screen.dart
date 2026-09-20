import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isReset = widget.isResetPassword;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,

        // =========================
        // App Bar
        // =========================
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

        // =========================
        // Body
        // =========================
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

                      // =========================
                      // Icon
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
                          Icons.lock_reset,
                          size: 48,
                          color: MasarColors.primaryBlue,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // Title
                      // =========================
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

                      // =========================
                      // Description
                      // =========================
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

                      // ==================================================
                      // Current Password
                      // يظهر فقط عند تغيير كلمة المرور من الإعدادات
                      // ==================================================
                      if (!isReset) ...[
                        TextFormField(
                          controller:
                              _currentPasswordController,
                          obscureText:
                              !_showCurrentPassword,
                          decoration: InputDecoration(
                            labelText:
                                'كلمة المرور الحالية',
                            labelStyle: const TextStyle(
                              fontFamily: 'Cairo',
                            ),

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),

                            // 👁️ العين
                            // مفتوحة = الباسورد ظاهر
                            // مغلقة = الباسورد نقاط
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showCurrentPassword =
                                      !_showCurrentPassword;
                                });
                              },
                              icon: Icon(
                                _showCurrentPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
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
                                value.isEmpty) {
                              return 'أدخل كلمة المرور الحالية';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),
                      ],

                      // ==================================================
                      // New Password
                      // ==================================================
                      TextFormField(
                        controller:
                            _newPasswordController,
                        obscureText: !_showNewPassword,

                        decoration: InputDecoration(
                          labelText:
                              'كلمة المرور الجديدة',
                          labelStyle: const TextStyle(
                            fontFamily: 'Cairo',
                          ),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),

                          // 👁️ العين
                          // مفتوحة = الباسورد ظاهر
                          // مغلقة = الباسورد نقاط
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showNewPassword =
                                    !_showNewPassword;
                              });
                            },
                            icon: Icon(
                              _showNewPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
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
                              value.isEmpty) {
                            return 'أدخل كلمة المرور الجديدة';
                          }

                          if (value.length < 6) {
                            return 'يجب أن تكون 6 أحرف على الأقل';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // Confirm Password
                      // ==================================================
                      TextFormField(
                        controller:
                            _confirmPasswordController,
                        obscureText:
                            !_showConfirmPassword,

                        decoration: InputDecoration(
                          labelText:
                              'تأكيد كلمة المرور الجديدة',
                          labelStyle: const TextStyle(
                            fontFamily: 'Cairo',
                          ),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),

                          // 👁️ العين
                          // مفتوحة = الباسورد ظاهر
                          // مغلقة = الباسورد نقاط
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword =
                                    !_showConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
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

                      // =========================
                      // Save Button
                      // =========================
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
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
                          child: Row(
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

  // ==================================================
  // Change / Reset Password
  // ==================================================
  void _changePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ==================================================
    // Reset Password Flow
    // Forgot Password → OTP → New Password → Login
    // ==================================================
    if (widget.isResetPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إعادة تعيين كلمة المرور بنجاح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );

      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          if (!mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
      );
    }

    // ==================================================
    // Normal Change Password from Settings
    // ==================================================
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تغيير كلمة المرور بنجاح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ),
      );

      // ما بنرجع على Login
      // المستخدم يبقى في نفس الشاشة.
    }
  }
}