import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_right,
            size: 30,
            color: MasarColors.darkBlue,
          ),
        ),
        title: const Text('تغيير كلمة المرور'),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword =
                            !_showCurrentPassword;
                      });
                    },
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'أدخل كلمة المرور الحالية';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'أدخل كلمة المرور الجديدة';
                  }

                  if (value.length < 6) {
                    return 'يجب أن تكون 6 أحرف على الأقل';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword =
                            !_showConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'أكد كلمة المرور الجديدة';
                  }

                  if (value != _newPasswordController.text) {
                    return 'كلمتا المرور غير متطابقتين';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('تغيير كلمة المرور'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // لاحقًا: إرسال طلب تغيير كلمة المرور إلى الـ backend.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تحديث كلمة المرور بنجاح',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
      ),
    );

    Navigator.pop(context);
  }
}