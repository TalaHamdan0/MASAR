import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'application_success_screen.dart';

class ApplyTrainingApplicationScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const ApplyTrainingApplicationScreen({super.key, required this.company});

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
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الهيدر العلوي
                    _buildTopHeader(context),
                    const SizedBox(height: 16),

                    // مؤشر الخطوات
                    _buildStepIndicator(),
                    const SizedBox(height: 16),

                    // بطاقة الشركة المحددة بتصميم متناسق وتفاعلي
                    _buildSelectedCompanyCard(),
                    const SizedBox(height: 20),

                    // معلومات الطالب
                    _buildSectionTitle(
                      'معلومات الطالب',
                      'سيتم استخدام هذه المعلومات في طلبك.',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'الإسم الكامل',
                      'شهد أحمد',
                      Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'الجامعة',
                      'جامعة العلوم والتكنولوجيا الأردنية',
                      Icons.school_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'التخصص',
                      'علوم الحاسوب',
                      Icons.menu_book_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'البريد الإلكتروني',
                      'shahd@example.com',
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'رقم الهاتف',
                      '+962 7 9123 4567',
                      Icons.phone_outlined,
                    ),
                    const SizedBox(height: 24),

                    // المرفقات
                    _buildSectionTitle(
                      'المرفقات المطلوبة',
                      'يرجى رفع الملفات بصيغة PDF.',
                    ),
                    const SizedBox(height: 12),
                    _buildUploadBox('السيرة الذاتية (CV)', 'ارفع ملف PDF'),
                    const SizedBox(height: 10),
                    _buildUploadBox('السجل الأكاديمي', 'ارفع ملف PDF'),
                    const SizedBox(height: 10),
                    _buildUploadBox('أي مستند إضافي (اختياري)', 'ارفع ملف PDF'),
                    const SizedBox(height: 20),

                    // الملاحظة
                    _buildNoteBox(),
                    const SizedBox(height: 24),

                    // زر الإرسال مع ربطه بـ BuildContext
                    _buildSubmitButton(context),
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

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: lightPurpleBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: primaryPurple,
            ),
          ),
        ),
        const Text(
          'تقديم طلب التدريب',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(width: 34),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepCircle('1', true),
              _buildStepLine(),
              _buildStepCircle('2', false),
              _buildStepLine(),
              _buildStepCircle('3', false),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'تقديم الطلب',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              Text(
                'المراجعة',
                style: TextStyle(fontSize: 12, color: textMuted),
              ),
              Text(
                'تم الإرسال',
                style: TextStyle(fontSize: 12, color: textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? primaryPurple : const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : textMuted,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(width: 60, height: 2, color: const Color(0xFFE2E8F0));
  }

  /// بطاقة الشركة بتصميم عصري
  Widget _buildSelectedCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFBFBFE)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryPurple.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: company['bgColor'] ?? Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Center(child: _buildCustomCompanyLogo(company)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      company['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: lightPurpleBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'الشركة المختارة',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Data Analyst Intern',
                  style: TextStyle(fontSize: 13, color: textMuted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: textMuted,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${company['location'] ?? 'عمان'}، الأردن',
                      style: const TextStyle(fontSize: 11, color: textMuted),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                      color: textMuted,
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      '3 أشهر',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: textMuted,
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      '120 ساعة',
                      style: TextStyle(fontSize: 11, color: textMuted),
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

  Widget _buildCustomCompanyLogo(Map<String, dynamic> company) {
    if (company['isZain'] == true || company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 26,
            height: 26,
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

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: textMuted)),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12, color: textMuted),
          prefixIcon: Icon(icon, color: textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightPurpleBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload_rounded,
                  color: primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: textMuted),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: primaryPurple,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F0FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2DEFF)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: primaryPurple,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'تأكد من أن جميع المعلومات والمرفقات صحيحة قبل إرسال الطلب.',
              style: TextStyle(
                fontSize: 12,
                color: primaryPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicationSuccessScreen(company: company),
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
              'إرسال طلب التدريب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ],
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
        currentIndex: 3,
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
