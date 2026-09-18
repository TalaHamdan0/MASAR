import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
        title: const Text('نسيت كلمة المرور'),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 50,
                  color: MasarColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'هل نسيت كلمة المرور؟',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'أدخل البريد الجامعي المرتبط بحسابك وسنساعدك على استعادة الوصول إلى حسابك.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الجامعي',
                  hintText: 'example@university.edu',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل البريد الجامعي';
                  }

                  final emailRegex = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  );

                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'أدخل بريدًا إلكترونيًا صحيحًا';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _sendEmail,
                child: const Text('إرسال البريد الإلكتروني'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    // لاحقًا:
    // هنا يتم إرسال طلب إلى الـ backend
    // لإرسال رابط إعادة تعيين كلمة المرور إلى هذا البريد.

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'تم استلام الطلب',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'تم تسجيل طلب استعادة كلمة المرور للبريد:\n$email\n\n'
            'عند ربط الـ backend سيتم إرسال رابط الاستعادة فعليًا إلى البريد.',
            style: const TextStyle(
              fontFamily: 'Cairo',
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }
}