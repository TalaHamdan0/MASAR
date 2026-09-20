import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/saved_training_store.dart';
import 'apply_training_application_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
  });

  @override
  State<CompanyDetailsScreen> createState() =>
      _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState
    extends State<CompanyDetailsScreen> {
  // =========================
  // المحفوظات
  // =========================

  bool get isSaved {
    return SavedTrainingStore.isSaved(widget.company);
  }

  void _toggleSaveCompany() {
    SavedTrainingStore.toggleSaved(widget.company);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved
              ? 'تم حفظ فرصة التدريب'
              : 'تمت إزالة فرصة التدريب من المحفوظات',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,

        // =========================
        // Body
        // =========================

        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildTopHeader(context),

                    const SizedBox(height: 16),

                    // Company banner
                    _buildCompanyBannerCard(),

                    const SizedBox(height: 20),

                    // Training opportunity
                    _buildSectionTitle('فرصة التدريب'),

                    const SizedBox(height: 8),

                    _buildRoleCard(),

                    const SizedBox(height: 16),

                    // Training details
                    _buildDetailsGrid(),

                    const SizedBox(height: 20),

                    // About company
                    _buildSectionTitle('نبذة عن الشركة'),

                    const SizedBox(height: 8),

                    _buildInfoCard(
                      '${widget.company['name']} هي شركة رائدة في مجال تقديم خدمات الاتصالات والتقنية المبتكرة، وتهدف إلى بناء مجتمعات رقمية متطورة ومميزة.',
                    ),

                    const SizedBox(height: 20),

                    // Training description
                    _buildSectionTitle('وصف التدريب'),

                    const SizedBox(height: 8),

                    _buildInfoCard(
                      'ستتاح لك الفرصة للعمل مع فرق العمل التقنية والمساهمة في مشاريع حقيقية، وإجراء تقارير وتطوير مهاراتك العملية.',
                    ),

                    const SizedBox(height: 20),

                    // Required skills
                    _buildSectionTitle('المهارات المطلوبة'),

                    const SizedBox(height: 10),

                    _buildSkillsWrap(),

                    const SizedBox(height: 24),

                    // Apply button
                    _buildApplyButton(context),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),

        // =========================
        // Navbar الموحد
        // =========================

        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }

  // =========================
  // Top Header
  // =========================

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: MasarColors.primaryBlue,
            ),
          ),
        ),

        const Text(
          'تفاصيل الشركة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),

        // Save button
        IconButton(
          onPressed: _toggleSaveCompany,
          tooltip: isSaved
              ? 'إزالة من المحفوظات'
              : 'حفظ',
          icon: Icon(
            isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isSaved
                ? MasarColors.primaryBlue
                : MasarColors.textPrimary,
            size: 25,
          ),
        ),
      ],
    );
  }

  // =========================
  // Company Banner
  // =========================

  Widget _buildCompanyBannerCard() {
    final String imageUrl =
        widget.company['bannerUrl'] ??
            'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=800&auto=format&fit=crop';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Company image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Company logo
            Positioned(
              right: 16,
              bottom: -25,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color:
                      widget.company['bgColor'] ??
                          Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: _buildCustomCompanyLogo(
                    widget.company,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 35),

        // Company information
        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                widget.company['name'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      MasarColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                widget.company['slogan'] ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  color:
                      MasarColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  _buildBadge(
                    Icons.people_outline_rounded,
                    widget.company['interns'] ?? '',
                  ),

                  const SizedBox(width: 12),

                  _buildBadge(
                    Icons.business_outlined,
                    widget.company['category'] ?? '',
                  ),

                  const SizedBox(width: 12),

                  _buildBadge(
                    Icons.location_on_outlined,
                    '${widget.company['location'] ?? ''}، الأردن',
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
  // Company Logo
  // =========================

  Widget _buildCustomCompanyLogo(
    Map<String, dynamic> company,
  ) {
    // =========================
    // Zain
    // =========================

    if (company['isZain'] == true ||
        company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CustomPaint(
              painter:
                  _ZainRealLogoPainter(),
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'zain',
            style: TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w900,
              color:
                  MasarColors.textPrimary,
              letterSpacing: 0.5,
              fontStyle:
                  FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // =========================
    // Microsoft
    // =========================

    if (company['isMicrosoft'] == true) {
      return SizedBox(
        width: 28,
        height: 28,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          physics:
              const NeverScrollableScrollPhysics(),
          children: [
            Container(
              color:
                  const Color(0xFFF25022),
            ),
            Container(
              color:
                  const Color(0xFF7FBA00),
            ),
            Container(
              color:
                  const Color(0xFF00A4EF),
            ),
            Container(
              color:
                  const Color(0xFFFFB900),
            ),
          ],
        ),
      );
    }

    // =========================
    // Amazon
    // =========================

    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 26,
              fontWeight:
                  FontWeight.w900,
              color: Colors.black,
              height: 0.9,
            ),
          ),

          Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFFF9900),
              borderRadius:
                  BorderRadius.circular(2),
            ),
          ),
        ],
      );
    }

    // =========================
    // Arab Bank
    // =========================

    if (company['isArabBank'] == true) {
      return const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 24,
          ),

          SizedBox(height: 1),

          Text(
            'ARAB BANK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 5.5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // =========================
    // Meta / Orange / باقي الشركات
    // =========================

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ??
              Icons.business,
          color:
              company['bgColor'] ==
                      const Color(0xFFFF6600)
                  ? Colors.white
                  : (company['iconColor'] ??
                      MasarColors.primaryBlue),
          size: 26,
        ),

        const SizedBox(height: 2),

        Text(
          company['name'] ?? '',
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 10,
            color:
                company['bgColor'] ==
                        const Color(0xFFFF6600)
                    ? Colors.white
                    : MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // =========================
  // Section Title
  // =========================

  Widget _buildSectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight:
            FontWeight.bold,
        color:
            MasarColors.textPrimary,
      ),
    );
  }

  // =========================
  // Role Card
  // =========================

  Widget _buildRoleCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color:
                  MasarColors.primaryBlue,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Data Analyst Intern',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      MasarColors.textPrimary,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'تحليل البيانات',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      MasarColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // Details Grid
  // =========================

  Widget _buildDetailsGrid() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
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
            widget.company['location'] ??
                'عمان',
          ),

          _buildDivider(),

          _buildGridItem(
            Icons.calendar_month_outlined,
            'مدة التدريب',
            '3 أشهر',
          ),

          _buildDivider(),

          _buildGridItem(
            Icons.access_time_rounded,
            'عدد الساعات',
            '120 ساعة',
          ),
        ],
      ),
    );
  }

  // =========================
  // Grid Item
  // =========================

  Widget _buildGridItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              MasarColors.primaryBlue,
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color:
                MasarColors.textSecondary,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            color:
                MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // =========================
  // Divider
  // =========================

  Widget _buildDivider() {
    return Container(
      height: 35,
      width: 1,
      color: MasarColors.border,
    );
  }

  // =========================
  // Info Card
  // =========================

  Widget _buildInfoCard(
    String text,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color:
              MasarColors.textSecondary,
          height: 1.6,
        ),
      ),
    );
  }

  // =========================
  // Skills
  // =========================

  Widget _buildSkillsWrap() {
    final skills = [
      'Data Analysis',
      'Excel',
      'SQL',
      'Python',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color:
                MasarColors.lightBlue,
            borderRadius:
                BorderRadius.circular(10),
            border: Border.all(
              color: MasarColors.border,
            ),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              color:
                  MasarColors.primaryBlue,
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // Apply Button
  // =========================

  Widget _buildApplyButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ApplyTrainingApplicationScreen(
                company: widget.company,
              ),
            ),
          );
        },
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              MasarColors.primaryBlue,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              'تقديم طلب التدريب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            SizedBox(width: 10),

            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Badge
  // =========================

  Widget _buildBadge(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color:
              MasarColors.textSecondary,
        ),

        const SizedBox(width: 3),

        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color:
                MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// Zain Logo Painter
// =====================================================

class _ZainRealLogoPainter
    extends CustomPainter {
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

    final gradient =
        const SweepGradient(
      colors: [
        Color(0xFF8B5CF6),
        Color(0xFFEC4899),
        Color(0xFF06B6D4),
        Color(0xFF10B981),
        Color(0xFF8B5CF6),
      ],
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(rect)
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap =
          StrokeCap.round;

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