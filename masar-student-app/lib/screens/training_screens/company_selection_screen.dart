import 'package:flutter/material.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'company_details_screen.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({super.key});

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  final TextEditingController _searchController = TextEditingController();

  // الألوان الخاصة بهوية تطبيق مسار
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color lightPurpleBg = Color(0xFFF3F0FF);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);

  // قائمة الشركات المطبقة في التصميم
  final List<Map<String, dynamic>> _companies = const [
    {
      'name': 'Meta',
      'slogan': 'شريك في بناء المستقبل',
      'interns': '+50 متدرب',
      'category': 'تقنية',
      'location': 'عمان',
      'icon': Icons.all_inclusive,
      'iconColor': Color(0xFF0081FB),
      'bgColor': Colors.white,
    },
    {
      'name': 'Orange',
      'slogan': 'فرص أكبر لغد أذكى',
      'interns': '+30 متدرب',
      'category': 'اتصالات',
      'location': 'عمان',
      'icon': Icons.square,
      'iconColor': Color(0xFFFF6600),
      'bgColor': Color(0xFFFF6600),
    },
    {
      'name': 'Microsoft',
      'slogan': 'تمكين كل شخص وكل مؤسسة',
      'interns': '+40 متدرب',
      'category': 'تقنية',
      'location': 'عمان',
      'isMicrosoft': true,
      'bgColor': Colors.white,
    },
    {
      'name': 'البنك العربي',
      'slogan': 'معاً نحو مستقبل أفضل',
      'interns': '+25 متدرب',
      'category': 'بنوك وخدمات مالية',
      'location': 'عمان',
      'isArabBank': true,
      'bgColor': Color(0xFF003366),
    },
    {
      'name': 'Zain',
      'slogan': 'عالم أجمل ممكن',
      'interns': '+35 متدرب',
      'category': 'اتصالات',
      'location': 'عمان',
      'isZain': true,
      'bgColor': Colors.white,
    },
    {
      'name': 'amazon',
      'slogan': 'ابتكار اليوم من أجل غد أفضل',
      'interns': '+40 متدرب',
      'category': 'تقنية',
      'location': 'عمان / عن بعد',
      'isAmazon': true,
      'bgColor': Colors.white,
    },
  ];

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
                    // الهيدر الأعلى
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // العنوان والوصف
                    _buildTitleSection(),
                    const SizedBox(height: 16),

                    // حقل البحث
                    _buildSearchBar(),
                    const SizedBox(height: 14),

                    // أزرار الفلترة
                    _buildFilterSection(),
                    const SizedBox(height: 16),

                    // قائمة الشركات
                    Column(
                      children: _companies
                          .map((company) => _buildCompanyCard(company))
                          .toList(),
                    ),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CustomPaint(painter: _MasarLogoPainter()),
            ),
            const SizedBox(width: 8),
            const Text(
              'MASAR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: primaryPurple,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: textDark,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        const CircleAvatar(
          radius: 17,
          backgroundColor: lightPurpleBg,
          child: Text(
            'S',
            style: TextStyle(
              color: primaryPurple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشركة',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'اكتشف الشركات المتاحة للتدريب في مجال تخصصك',
          style: TextStyle(fontSize: 13, color: textMuted),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'ابحث عن شركة ...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.grid_view_rounded, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'الكل',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildFilterChip('التخصص', Icons.school_outlined),
          const SizedBox(width: 8),
          _buildFilterChip('الموقع', Icons.location_on_outlined),
          const SizedBox(width: 8),
          _buildFilterChip('نوع التدريب', Icons.business_center_outlined),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textDark,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: company['bgColor'] ?? Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(child: _buildCustomCompanyLogo(company)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  company['slogan'],
                  style: const TextStyle(fontSize: 11, color: textMuted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildInfoBadge(
                      Icons.people_outline_rounded,
                      company['interns'],
                    ),
                    _buildInfoBadge(
                      Icons.business_outlined,
                      company['category'],
                    ),
                    _buildInfoBadge(
                      Icons.location_on_outlined,
                      company['location'],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyDetailsScreen(company: company),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightPurpleBg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'اختر الشركة',
              style: TextStyle(
                color: primaryPurple,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Custom Company Logo Builder (شعار Zain المحدث والحديث)
  // =========================
  Widget _buildCustomCompanyLogo(Map<String, dynamic> company) {
    // 1. شعار Zain الحقيقي المبتكر (الشكل الحلزوني + كلمة zain)
    if (company['isZain'] == true || company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(painter: _ZainRealLogoPainter()),
          ),
          const SizedBox(height: 2),
          const Text(
            'zain',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: 0.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // 2. شعار Microsoft
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

    // 3. شعار Amazon
    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 24,
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

    // 4. شعار البنك العربي
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
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }

    // باقي الشركات (Meta, Orange)
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ?? Icons.business,
          color: company['iconColor'] ?? primaryPurple,
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

  Widget _buildInfoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: textMuted),
        const SizedBox(width: 2),
        Text(text, style: const TextStyle(fontSize: 10, color: textMuted)),
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

    // تدرج ألوان شعار زين الشهير (البنفسجي -> الوردي -> الفيروزي)
    final gradient = const SweepGradient(
      colors: [
        Color(0xFF8B5CF6), // بنفسجي
        Color(0xFFEC4899), // وردي
        Color(0xFF06B6D4), // فيروزي
        Color(0xFF10B981), // أخضر زاهي
        Color(0xFF8B5CF6),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // رسم منحنيات الشريط الملتوي المطابق لشعار زين
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

// رسم شعار مسار
class _MasarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.fill;

    double radius = size.width / 4.2;

    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawCircle(Offset(size.width - radius, radius), radius, paint);
    canvas.drawCircle(Offset(radius, size.height - radius), radius, paint);
    canvas.drawCircle(
      Offset(size.width - radius, size.height - radius),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
