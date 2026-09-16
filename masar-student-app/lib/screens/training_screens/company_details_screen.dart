import 'package:flutter/material.dart';
import 'apply_training_application_screen.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({super.key, required this.company});

  // الألوان الخاصة بهوية تطبيق مسار
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
                    // الهيدر الأعلى (زر الرجوع والعنوان وزر الحفظ)
                    _buildTopHeader(context),
                    const SizedBox(height: 16),

                    // بنر صورة الشركة مع الشعار والمعلومات
                    _buildCompanyBannerCard(),
                    const SizedBox(height: 20),

                    // المسمى الوظيفي الفرصة
                    _buildSectionTitle('فرصة التدريب'),
                    const SizedBox(height: 8),
                    _buildRoleCard(),
                    const SizedBox(height: 16),

                    // شبكة التفاصيل السريعة
                    _buildDetailsGrid(),
                    const SizedBox(height: 20),

                    // نبذة عن الشركة
                    _buildSectionTitle('نبذة عن الشركة'),
                    const SizedBox(height: 8),
                    _buildInfoCard(
                      '${company['name']} هي شركة رائدة في مجال تقديم خدمات الاتصالات والتقنية المبتكرة، وتهدف إلى بناء مجتمعات رقمية متطورة ومميزة.',
                    ),
                    const SizedBox(height: 20),

                    // وصف التدريب
                    _buildSectionTitle('وصف التدريب'),
                    const SizedBox(height: 8),
                    _buildInfoCard(
                      'ستتاح لك الفرصة العمل مع فرق العمل التقنية والمساهمة في مشاريع حقيقية، وإجراء تقارير وتطوير مهاراتك العملية.',
                    ),
                    const SizedBox(height: 20),

                    // المهارات المطلوبة
                    _buildSectionTitle('المهارات المطلوبة'),
                    const SizedBox(height: 10),
                    _buildSkillsWrap(),
                    const SizedBox(height: 24),

                    // زر تقديم الطلب
                    _buildApplyButton(context),
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

  // =========================
  // Top Header Navigation
  // =========================
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
          'تفاصيل الشركة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border_rounded,
            color: textDark,
            size: 24,
          ),
        ),
      ],
    );
  }

  // =========================
  // Company Banner Card
  // =========================
  Widget _buildCompanyBannerCard() {
    final String imageUrl =
        company['bannerUrl'] ??
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=800&auto=format&fit=crop';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // صورة خلفية مبنى الشركة
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // مربع شعار الشركة العائم في الأسفل
            Positioned(
              right: 16,
              bottom: -25,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: company['bgColor'] ?? Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(child: _buildCustomCompanyLogo(company)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 35),

        // بيانات اسم الشركة والتاغات
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company['name'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                company['slogan'] ?? '',
                style: const TextStyle(fontSize: 13, color: textMuted),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildBadge(
                    Icons.people_outline_rounded,
                    company['interns'] ?? '',
                  ),
                  const SizedBox(width: 12),
                  _buildBadge(
                    Icons.business_outlined,
                    company['category'] ?? '',
                  ),
                  const SizedBox(width: 12),
                  _buildBadge(
                    Icons.location_on_outlined,
                    '${company['location'] ?? ''}، الأردن',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // Custom Company Logo Builder (شعار Zain المحدث)
  // =========================
  Widget _buildCustomCompanyLogo(Map<String, dynamic> company) {
    // 1. Zain
    if (company['isZain'] == true || company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CustomPaint(painter: _ZainRealLogoPainter()),
          ),
          const SizedBox(height: 2),
          const Text(
            'zain',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: 0.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // 2. Microsoft
    if (company['isMicrosoft'] == true) {
      return SizedBox(
        width: 28,
        height: 28,
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

    // 3. Amazon
    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 0.9,
            ),
          ),
          Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9900),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      );
    }

    // 4. البنك العربي
    if (company['isArabBank'] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
          SizedBox(height: 1),
          Text(
            'ARAB BANK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 5.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // 5. Meta & Orange وباقي الشركات
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ?? Icons.business,
          color: company['bgColor'] == const Color(0xFFFF6600)
              ? Colors.white
              : (company['iconColor'] ?? primaryPurple),
          size: 26,
        ),
        const SizedBox(height: 2),
        Text(
          company['name'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: (company['bgColor'] == const Color(0xFFFF6600))
                ? Colors.white
                : textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
    );
  }

  Widget _buildRoleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEBE6FF)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lightPurpleBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Analyst Intern',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'تحليل البيانات',
                style: TextStyle(fontSize: 12, color: textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGridItem(
            Icons.business_center_outlined,
            'نوع التدريب',
            'ميداني',
          ),
          _buildDivider(),
          _buildGridItem(
            Icons.location_on_outlined,
            'الموقع',
            company['location'] ?? 'عمان',
          ),
          _buildDivider(),
          _buildGridItem(
            Icons.calendar_month_outlined,
            'مدة التدريب',
            '3 أشهر',
          ),
          _buildDivider(),
          _buildGridItem(Icons.access_time_rounded, 'عدد الساعات', '120 ساعة'),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: primaryPurple),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 11, color: textMuted)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 35, width: 1, color: borderColor);
  }

  Widget _buildInfoCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: textMuted, height: 1.6),
      ),
    );
  }

  Widget _buildSkillsWrap() {
    final skills = ['Data Analysis', 'Excel', 'SQL', 'Python'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F0FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              color: primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ApplyTrainingApplicationScreen(company: company),
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
              'تقديم طلب التدريب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textMuted),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 11, color: textMuted)),
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
        currentIndex: 1,
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
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            activeIcon: Icon(Icons.business_center),
            label: 'التدريب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'المهارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }
}

// =========================
// الرسام المخصص لشعار زين (Zain Dynamic Ribbon Painter)
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
