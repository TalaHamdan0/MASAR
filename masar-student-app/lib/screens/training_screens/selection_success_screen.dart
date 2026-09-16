import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'my_applications_screen.dart';
import 'training_dashboard_screen.dart';

class SelectionSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> selectedCompany;

  const SelectionSuccessScreen({super.key, required this.selectedCompany});

  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color lightPurpleBg = Color(0xFFF3F0FF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFC),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // زر الرجوع في أعلى اليسار
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

                    // 1. أيقونة قبعة التخرج الاحتفالية
                    _buildGraduationIllustration(),
                    const SizedBox(height: 24),

                    // 2. عناوين نجاح الاختيار
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
                      style: TextStyle(fontSize: 13, color: textMuted),
                    ),
                    const SizedBox(height: 20),

                    // 3. بطاقة الشركة المختارة
                    _buildSelectedCompanyCard(),
                    const SizedBox(height: 16),

                    // 4. التنبيه الأخضر
                    _buildSuccessAlertBox(),
                    const SizedBox(height: 28),

                    // 5. زر الانتقال إلى تدريبي
                    _buildPrimaryActionButton(context),
                    const SizedBox(height: 12),

                    // 6. زر العودة إلى طلباتي
                    _buildSecondaryActionButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // رسم أيقونة القبعة مع الخطوط الاحتفالية المتناثرة
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
              color: lightPurpleBg,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          Positioned(
            top: 15,
            left: 20,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 12,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 18,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 14,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 15,
            child: Transform.rotate(
              angle: 0.4,
              child: Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة عرض الشركة المختارة وتفاصيلها المصغرة
  Widget _buildSelectedCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selectedCompany['bgColor'] ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Center(child: _buildCustomCompanyLogo(selectedCompany)),
          ),
          const SizedBox(width: 12),
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
                  style: const TextStyle(fontSize: 12, color: textMuted),
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
                    Text(
                      '${selectedCompany['location'] ?? 'عمان'}  ',
                      style: const TextStyle(fontSize: 10, color: textMuted),
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 11,
                      color: textMuted,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${selectedCompany['duration'] ?? '3 أشهر'}  ',
                      style: const TextStyle(fontSize: 10, color: textMuted),
                    ),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: textMuted,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${selectedCompany['hours'] ?? '120 ساعة'}',
                      style: const TextStyle(fontSize: 10, color: textMuted),
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

  // صندوق التنبيه الأخضر
  Widget _buildSuccessAlertBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCEEAD6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.celebration_rounded,
            color: Color(0xFF1E8E3E),
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
                    color: Color(0xFF1E8E3E),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'لقد قمت باختيار تدريبك بنجاح.\nسيتم إلغاء باقي الطلبات المقبولة تلقائياً.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF137333),
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

  // زر الانتقال إلى تدريبي (الرئيسي بنفسجي)
  Widget _buildPrimaryActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TrainingDashboardScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
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
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // زر العودة إلى طلباتي
  Widget _buildSecondaryActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApplicationsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        child: const Text(
          'العودة إلى طلباتي',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // شعارات الشركات المتوافقة مع الشاشات السابقة
  Widget _buildCustomCompanyLogo(Map<String, dynamic> company) {
    if (company['isMicrosoft'] == true || company['name'] == 'Microsoft') {
      return SizedBox(
        width: 22,
        height: 22,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(color: const Color(0xFFF25022)),
            Container(color: const Color(0xFF7FBA00)),
            Container(color: const Color(0xFF00A4EF)),
            Container(color: const Color(0xFFFFB900)),
          ],
        ),
      );
    }

    if (company['isZain'] == true || company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(painter: _ZainLogoPainter()),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ?? Icons.business,
          color: primaryPurple,
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textMuted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            label: 'فرص التدريب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }
}

// رسام شعار زين
class _ZainLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
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
    path.moveTo(size.width * 0.2, size.height * 0.8);
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
