import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'my_applications_screen.dart';

class ApplicationSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const ApplicationSuccessScreen({super.key, required this.company});

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
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // 1. أيقونة النجاح الملونة مع الاحتفال
                    _buildSuccessIllustration(),
                    const SizedBox(height: 24),

                    // 2. عنوان وشكر النجاح
                    const Text(
                      'تم إرسال طلب التدريب بنجاح!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'شكراً لك على تقديم طلبك.',
                      style: TextStyle(fontSize: 14, color: textMuted),
                    ),
                    const SizedBox(height: 24),

                    // 3. بطاقة الشركة المحددة بشعارها المخصص
                    _buildSelectedCompanyCard(),
                    const SizedBox(height: 24),

                    // 4. أيقونة والرسالة التوضيحية للبريد الإلكتروني
                    _buildEmailNotificationNotice(),
                    const SizedBox(height: 32),

                    // 5. زر متابعة الطلب (طلباتي)
                    _buildTrackApplicationButton(context),
                    const SizedBox(height: 12),

                    // 6. زر العودة إلى الفرص
                    _buildBackToOpportunitiesButton(context),
                    const SizedBox(height: 12),
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

  // رسم أيقونة صح النجاح المخصصة
  Widget _buildSuccessIllustration() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة البنفسجية الفاتحة الخلفية
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: lightPurpleBg,
              shape: BoxShape.circle,
            ),
          ),
          // دائرة أيقونة صح البنفسجية
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          // عناصر الاحتفال المحيطة بالأيقونة
          Positioned(
            top: 10,
            left: 20,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 14,
                height: 4,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 25,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 18,
                height: 4,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 16,
                height: 4,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: primaryPurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة تفاصيل الشركة المحددة مع استخدام دالة الشعار المخصص
  Widget _buildSelectedCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: company['bgColor'] ?? Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Center(child: _buildCustomCompanyLogo(company)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Data Analyst Intern',
                    style: TextStyle(fontSize: 13, color: textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge(
                Icons.location_on_outlined,
                '${company['location'] ?? 'عمان'}، الأردن',
              ),
              _buildBadge(Icons.calendar_month_outlined, '3 أشهر'),
              _buildBadge(Icons.access_time_rounded, '120 ساعة'),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // دالة رسم الشعارات المخصصة لكل الشركات
  // =========================
  Widget _buildCustomCompanyLogo(Map<String, dynamic> company) {
    if (company['isZain'] == true || company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(painter: _ZainRealLogoPainter()),
          ),
          const SizedBox(height: 1),
          const Text(
            'zain',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              color: textDark,
              letterSpacing: 0.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    if (company['isMicrosoft'] == true) {
      return SizedBox(
        width: 24,
        height: 24,
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

    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 0.9,
            ),
          ),
          Container(
            width: 14,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9900),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      );
    }

    if (company['isArabBank'] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
          SizedBox(height: 1),
          Text(
            'ARAB BANK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 5,
              fontWeight: FontWeight.bold,
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
          color: company['bgColor'] == const Color(0xFFFF6600)
              ? Colors.white
              : (company['iconColor'] ?? primaryPurple),
          size: 22,
        ),
        const SizedBox(height: 2),
        Text(
          company['name'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 9,
            color: (company['bgColor'] == const Color(0xFFFF6600))
                ? Colors.white
                : textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: textMuted)),
      ],
    );
  }

  // الرسالة الخاصة بالبريد الإلكتروني
  Widget _buildEmailNotificationNotice() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: lightPurpleBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.email_outlined,
            color: primaryPurple,
            size: 26,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'سيتم إشعارك عبر البريد الإلكتروني\nعند تحديث حالة الطلب.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: textMuted, height: 1.5),
        ),
      ],
    );
  }

  // زر طلباتي المحدث
  Widget _buildTrackApplicationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApplicationsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'طلباتي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
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

  // زر العودة إلى الفرص
  Widget _buildBackToOpportunitiesButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // الرجوع إلى الشاشة الرئيسية للفرص
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPurpleBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'العودة إلى الفرص',
          style: TextStyle(
            color: primaryPurple,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // قائمة طلباتي
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
            icon: Icon(Icons.notifications_none_rounded),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            label: 'الفرص',
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

// =========================
// الرسام المخصص لشعار زين المتدرج (Zain Ribbon Painter)
// =========================
class _ZainRealLogoPainter extends CustomPainter {
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
      ..strokeWidth = 3.5
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
