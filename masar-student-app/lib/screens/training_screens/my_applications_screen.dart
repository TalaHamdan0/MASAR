import 'package:flutter/material.dart';

import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'selection_success_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState
    extends State<MyApplicationsScreen> {
  String selectedFilter = 'الكل';

  final List<Map<String, dynamic>> _applications = [
    {
      'name': 'Microsoft',
      'role': 'IT Support Intern',
      'location': 'عمان',
      'duration': '3 أشهر',
      'hours': '120 ساعة',
      'date': '2026/09/10',
      'status': 'مقبول',
      'isMicrosoft': true,
      'bgColor': Colors.white,
    },
    {
      'name': 'Meta',
      'role': 'Data Analyst Intern',
      'location': 'عمان',
      'duration': '3 أشهر',
      'hours': '120 ساعة',
      'date': '2026/09/05',
      'status': 'مقبول',
      'icon': Icons.all_inclusive,
      'iconColor': Color(0xFF0081FB),
      'bgColor': Colors.white,
    },
    {
      'name': 'Orange',
      'role': 'Software Engineer Intern',
      'location': 'عمان',
      'duration': '6 أشهر',
      'hours': '160 ساعة',
      'date': '2026/08/28',
      'status': 'مرفوض',
      'icon': Icons.square,
      'iconColor': Color(0xFFFF6600),
      'bgColor': Color(0xFFFF6600),
    },
    {
      'name': 'Zain',
      'role': 'Marketing Intern',
      'location': 'عمان',
      'duration': '3 أشهر',
      'hours': '100 ساعة',
      'date': '2026/08/20',
      'status': 'قيد المراجعة',
      'isZain': true,
      'bgColor': Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredList =
        _applications.where((app) {
      if (selectedFilter == 'الكل') {
        return true;
      }

      return app['status'] == selectedFilter;
    }).toList();

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
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // =========================
                  // الهيدر + زر الرجوع
                  // =========================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: MasarColors.textPrimary,
                          ),
                        ),

                        const Expanded(
                          child: Center(
                            child: Text(
                              'طلباتي',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    MasarColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                        // حتى يظل العنوان بالنص
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =========================
                  // شريط الفلترة
                  // =========================

                  _buildFilterTabs(),

                  const SizedBox(height: 16),

                  // =========================
                  // قائمة الطلبات
                  // =========================

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: filteredList.length + 1,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == filteredList.length) {
                          return _buildInfoNoteBox();
                        }

                        return _buildApplicationCard(
                          filteredList[index],
                        );
                      },
                    ),
                  ),
                ],
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
  // شريط الفلترة
  // =========================

  Widget _buildFilterTabs() {
    final filters = [
      'الكل',
      'قيد المراجعة',
      'المقبولة',
      'المرفوضة',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: filters.map((filter) {
          final bool isSelected =
              (selectedFilter == filter) ||
              (filter == 'المقبولة' &&
                  selectedFilter == 'مقبول') ||
              (filter == 'المرفوضة' &&
                  selectedFilter == 'مرفوض');

          return InkWell(
            onTap: () {
              setState(() {
                if (filter == 'المقبولة') {
                  selectedFilter = 'مقبول';
                } else if (filter == 'المرفوضة') {
                  selectedFilter = 'مرفوض';
                } else {
                  selectedFilter = filter;
                }
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? MasarColors.primaryBlue
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? MasarColors.primaryBlue
                      : MasarColors.border,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : MasarColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================
  // كرت الطلب
  // =========================

  Widget _buildApplicationCard(
    Map<String, dynamic> app,
  ) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // شعار الشركة
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            app['bgColor'] ??
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
                          app,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // معلومات الشركة
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            app['name'] ?? '',
                            style:
                                const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.bold,
                              color: MasarColors
                                  .textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app['role'] ?? '',
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: MasarColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // حالة الطلب
                    _buildStatusBadge(
                      app['status'],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // تفاصيل التدريب
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${app['location']}  ',
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: MasarColors
                            .textSecondary,
                      ),
                    ),

                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${app['duration']}  ',
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: MasarColors
                            .textSecondary,
                      ),
                    ),

                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${app['hours']}',
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: MasarColors
                            .textSecondary,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'تم التقديم في ${app['date']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color:
                        MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // طلب مقبول
          // =========================

          if (app['status'] == 'مقبول')
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration:
                  const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: MasarColors.border,
                  ),
                ),
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectionSuccessScreen(
                        selectedCompany: app,
                      ),
                    ),
                  );
                },
                style:
                    OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color:
                        MasarColors.primaryBlue,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      MasarColors.lightBlue,
                ),
                child: const Text(
                  'اختيار هذا التدريب',
                  style: TextStyle(
                    color:
                        MasarColors.primaryBlue,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          // =========================
          // طلب مرفوض
          // =========================

          if (app['status'] == 'مرفوض')
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(10),
              decoration:
                  const BoxDecoration(
                color: Color(0xFFFFF0F0),
                borderRadius:
                    BorderRadius.only(
                  bottomLeft:
                      Radius.circular(16),
                  bottomRight:
                      Radius.circular(16),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'تم رفض طلبك.',
                    style: TextStyle(
                      color:
                          Color(0xFFE53E3E),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'يمكنك التقديم على فرص أخرى.',
                    style: TextStyle(
                      color:
                          Color(0xFFE53E3E),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // Badge حالة الطلب
  // =========================

  Widget _buildStatusBadge(
    String status,
  ) {
    Color bg = const Color(0xFFFFF9E6);
    Color text = const Color(0xFFD97706);
    IconData icon =
        Icons.access_time_rounded;

    if (status == 'مقبول') {
      bg = const Color(0xFFE6F4EA);
      text = const Color(0xFF1E8E3E);
      icon = Icons.check_circle_rounded;
    } else if (status == 'مرفوض') {
      bg = const Color(0xFFFCE8E6);
      text = const Color(0xFFD93025);
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.bold,
              color: text,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            icon,
            size: 14,
            color: text,
          ),
        ],
      ),
    );
  }

  // =========================
  // شعارات الشركات
  // =========================

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
            decoration:
                BoxDecoration(
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
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: const [
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

    // الشركات الأخرى
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ??
              Icons.business,
          color: company['bgColor'] ==
                  const Color(0xFFFF6600)
              ? Colors.white
              : (company['iconColor'] ??
                  MasarColors
                      .primaryBlue),
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
            color: company['bgColor'] ==
                    const Color(
                      0xFFFF6600,
                    )
                ? Colors.white
                : MasarColors
                    .textPrimary,
          ),
        ),
      ],
    );
  }

  // =========================
  // صندوق التنبيه
  // =========================

  Widget _buildInfoNoteBox() {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 16,
      ),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_rounded,
            color:
                MasarColors.primaryBlue,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'سيتم إشعارك عند وجود أي تحديث على طلباتك.',
              style: TextStyle(
                fontSize: 12,
                color:
                    MasarColors.primaryBlue,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// شعار زين
// =========================

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