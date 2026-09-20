import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'my_applications_screen.dart';
import 'training_dashboard_screen.dart';

class SelectionSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> selectedCompany;

  const SelectionSuccessScreen({
    super.key,
    required this.selectedCompany,
  });

  static const Color borderColor = MasarColors.border;
  static const Color textDark = MasarColors.textPrimary;
  static const Color textMuted = MasarColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // زر الرجوع
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // أيقونة النجاح
                    _buildGraduationIllustration(),

                    const SizedBox(height: 24),

                    // العنوان
                    const Text(
                      'تم اختيار تدريبك بنجاح!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'ستبدأ رحلتك التدريبية مع',
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // بطاقة الشركة
                    _buildSelectedCompanyCard(),

                    const SizedBox(height: 16),

                    // رسالة النجاح
                    _buildSuccessAlertBox(),

                    const SizedBox(height: 28),

                    // الانتقال إلى التدريب
                    _buildPrimaryActionButton(context),

                    const SizedBox(height: 12),

                    // العودة إلى الطلبات
                    _buildSecondaryActionButton(context),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),

        // الـ Navbar الرئيسي
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }

  // =========================================================
  // Graduation Illustration
  // =========================================================

  Widget _buildGraduationIllustration() {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
          ),

          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: MasarColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          // الخط العلوي الأيسر
          Positioned(
            top: 15,
            left: 20,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 12,
                height: 3,
                decoration: BoxDecoration(
                  color: MasarColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // الخط العلوي الأيمن
          Positioned(
            top: 20,
            right: 20,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: MasarColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // الخط السفلي الأيمن
          Positioned(
            bottom: 20,
            right: 18,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 14,
                height: 3,
                decoration: BoxDecoration(
                  color: MasarColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // الخط السفلي الأيسر
          Positioned(
            bottom: 25,
            left: 15,
            child: Transform.rotate(
              angle: 0.4,
              child: Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: MasarColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Selected Company Card
  // =========================================================

  Widget _buildSelectedCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          // شعار الشركة
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selectedCompany['bgColor'] ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Center(
              child: _buildCustomCompanyLogo(selectedCompany),
            ),
          ),

          const SizedBox(width: 12),

          // معلومات الشركة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCompany['name'] ?? 'Microsoft',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  selectedCompany['role'] ?? 'IT Support Intern',
                  style: const TextStyle(
                    fontSize: 12,
                    color: textMuted,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 11,
                      color: textMuted,
                    ),

                    const SizedBox(width: 2),

                    Flexible(
                      child: Text(
                        '${selectedCompany['location'] ?? 'عمان'}  ',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textMuted,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 11,
                      color: textMuted,
                    ),

                    const SizedBox(width: 2),

                    Flexible(
                      child: Text(
                        '${selectedCompany['duration'] ?? '3 أشهر'}  ',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textMuted,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: textMuted,
                    ),

                    const SizedBox(width: 2),

                    Flexible(
                      child: Text(
                        '${selectedCompany['hours'] ?? '120 ساعة'}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Success Alert
  // =========================================================

  Widget _buildSuccessAlertBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.lightGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFCEEAD6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.celebration_rounded,
            color: MasarColors.primaryGreen,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'مبروك!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MasarColors.darkGreen,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'لقد قمت باختيار تدريبك بنجاح.\n'
                  'سيتم إلغاء باقي الطلبات المقبولة تلقائياً.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: MasarColors.darkGreen,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // Go To Training Dashboard
  // =========================================================

  Widget _buildPrimaryActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TrainingDashboardScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MasarColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الانتقال إلى تدريبي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(width: 8),

            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Back To Applications
  // =========================================================

  Widget _buildSecondaryActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MyApplicationsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: MasarColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: MasarColors.border,
            ),
          ),
        ),
        child: const Text(
          'العودة إلى طلباتي',
          style: TextStyle(
            color: MasarColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // Company Logos
  // =========================================================

  Widget _buildCustomCompanyLogo(
    Map<String, dynamic> company,
  ) {
    // Microsoft
    if (company['isMicrosoft'] == true ||
        company['name'] == 'Microsoft') {
      return SizedBox(
        width: 22,
        height: 22,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: const Color(0xFFF25022),
            ),
            Container(
              color: const Color(0xFF7FBA00),
            ),
            Container(
              color: const Color(0xFF00A4EF),
            ),
            Container(
              color: const Color(0xFFFFB900),
            ),
          ],
        ),
      );
    }

    // Zain
    if (company['isZain'] == true ||
        company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(
              painter: _ZainLogoPainter(),
            ),
          ),

          const SizedBox(height: 1),

          const Text(
            'zain',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: textDark,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // باقي الشركات
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ?? Icons.business,
          color: MasarColors.primaryBlue,
          size: 20,
        ),

        const SizedBox(height: 2),

        Text(
          company['name'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 8.5,
            color: textDark,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // Main Bottom Navigation
  // =========================================================

  Widget _buildBottomNavigationBar() {
    return const AppBottomNavBar(
      selectedIndex: 2,
    );
  }
}

// ===========================================================
// Zain Logo Painter
// ===========================================================

class _ZainLogoPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    final gradient = const SweepGradient(
      colors: [
        Color(0xFF8B5CF6),
        Color(0xFFEC4899),
        Color(0xFF06B6D4),
        Color(0xFF10B981),
        Color(0xFF8B5CF6),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(
      size.width * 0.2,
      size.height * 0.8,
    );

    path.cubicTo(
      size.width * 0.05,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.05,
      size.width * 0.8,
      size.height * 0.35,
    );

    path.cubicTo(
      size.width * 0.9,
      size.height * 0.65,
      size.width * 0.3,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.5,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}