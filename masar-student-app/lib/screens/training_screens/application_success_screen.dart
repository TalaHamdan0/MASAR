import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'my_applications_screen.dart';

class ApplicationSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const ApplicationSuccessScreen({
    super.key,
    required this.company,
  });

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
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // أيقونة النجاح
                    _buildSuccessIllustration(),

                    const SizedBox(height: 24),

                    // عنوان النجاح
                    const Text(
                      'تم إرسال طلب التدريب بنجاح!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'شكراً لك على تقديم طلبك.',
                      style: TextStyle(
                        fontSize: 14,
                        color: MasarColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // الشركة المحددة
                    _buildSelectedCompanyCard(),

                    const SizedBox(height: 24),

                    // إشعار البريد
                    _buildEmailNotificationNotice(),

                    const SizedBox(height: 32),

                    // طلباتي
                    _buildTrackApplicationButton(context),

                    const SizedBox(height: 12),

                    // العودة إلى الفرص
                    _buildBackToOpportunitiesButton(context),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Navbar الموحد
        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }

  // =====================================================
  // Success Illustration
  // =====================================================

  Widget _buildSuccessIllustration() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة الخلفية
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: MasarColors.lightBlue,
              shape: BoxShape.circle,
            ),
          ),

          // دائرة النجاح
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: MasarColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),

          // عناصر الاحتفال
          Positioned(
            top: 10,
            left: 20,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 14,
                height: 4,
                decoration: BoxDecoration(
                  color: MasarColors.primaryBlue,
                  borderRadius:
                      BorderRadius.circular(2),
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
                  color: MasarColors.primaryBlue,
                  borderRadius:
                      BorderRadius.circular(2),
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
                  color: MasarColors.primaryBlue,
                  borderRadius:
                      BorderRadius.circular(2),
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
                color: MasarColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Selected Company Card
  // =====================================================

  Widget _buildSelectedCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      company['bgColor'] ??
                          Colors.white,
                  borderRadius:
                      BorderRadius.circular(10),
                  border: Border.all(
                    color: MasarColors.border,
                  ),
                ),
                child: Center(
                  child:
                      _buildCustomCompanyLogo(
                    company,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      company['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            MasarColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      'Data Analyst Intern',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            color: MasarColors.border,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _buildBadge(
                Icons.location_on_outlined,
                '${company['location'] ?? 'عمان'}، الأردن',
              ),

              _buildBadge(
                Icons.calendar_month_outlined,
                '3 أشهر',
              ),

              _buildBadge(
                Icons.access_time_rounded,
                '120 ساعة',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Company Logos
  // =====================================================

  Widget _buildCustomCompanyLogo(
    Map<String, dynamic> company,
  ) {
    // Zain
    if (company['isZain'] == true ||
        company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(
              painter:
                  _ZainRealLogoPainter(),
            ),
          ),

          const SizedBox(height: 1),

          const Text(
            'zain',
            style: TextStyle(
              fontSize: 8.5,
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

    // Microsoft
    if (company['isMicrosoft'] == true) {
      return SizedBox(
        width: 24,
        height: 24,
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

    // Amazon
    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.w900,
              color: Colors.black,
              height: 0.9,
            ),
          ),

          Container(
            width: 14,
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

    // Arab Bank
    if (company['isArabBank'] == true) {
      return const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 20,
          ),

          SizedBox(height: 1),

          Text(
            'ARAB BANK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // باقي الشركات
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
          size: 22,
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
            fontSize: 9,
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

  // =====================================================
  // Badge
  // =====================================================

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

        const SizedBox(width: 4),

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

  // =====================================================
  // Email Notification
  // =====================================================

  Widget _buildEmailNotificationNotice() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: MasarColors.lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.email_outlined,
            color:
                MasarColors.primaryBlue,
            size: 26,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'سيتم إشعارك عبر البريد الإلكتروني\n'
          'عند تحديث حالة الطلب.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color:
                MasarColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // Track Application Button
  // =====================================================

  Widget _buildTrackApplicationButton(
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
                  const MyApplicationsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
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
              'طلباتي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
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

  // =====================================================
  // Back To Opportunities
  // =====================================================

  Widget _buildBackToOpportunitiesButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              MasarColors.lightBlue,
          foregroundColor:
              MasarColors.primaryBlue,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'العودة إلى الفرص',
          style: TextStyle(
            color:
                MasarColors.primaryBlue,
            fontSize: 14,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
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