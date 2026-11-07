
import 'package:flutter/material.dart';
import 'university_main_layout.dart';
import '../../theme/masar_theme.dart';
import '../../data/university_mock_data.dart';

class UniversityLoginScreen extends StatefulWidget {
  const UniversityLoginScreen({super.key});

  @override
  State<UniversityLoginScreen> createState() =>
      _UniversityLoginScreenState();
}

class _UniversityLoginScreenState
    extends State<UniversityLoginScreen> {
  final TextEditingController universityIdController =
      TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    universityIdController.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();

    final id = universityIdController.text.trim();

    if (id.isEmpty) {
      setState(() {
        errorMessage = 'يرجى إدخال الرقم الجامعي / الوظيفي';
      });
      return;
    }

    if (!UniversityMockData.validateAdminId(id)) {
      setState(() {
        errorMessage = 'الرقم الجامعي / الوظيفي غير صحيح';
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UniversityMainLayout(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 440,
              padding: const EdgeInsets.all(34),
              decoration: BoxDecoration(
                color: MasarColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: MasarColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/masar_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.route_rounded,
                              color: MasarColors.primaryBlue,
                              size: 42,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'بوابة الجامعة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'إدارة ومتابعة برامج التدريب الميداني',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'الرقم الجامعي / الوظيفي',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MasarColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextField(
                    controller: universityIdController,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      hintText: '1001',
                      hintStyle: TextStyle(
                        color: MasarColors.textSecondary
                            .withOpacity(0.65),
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: MasarColors.primaryBlue,
                      ),
                      filled: true,
                      fillColor: MasarColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: MasarColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: MasarColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(
                          color: MasarColors.primaryBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 15,
                      ),
                    ),
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: MasarColors.error,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: MasarColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 22),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MasarColors.primaryBlue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            MasarColors.primaryBlue.withOpacity(0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
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
