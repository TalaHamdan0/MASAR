
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';

import 'university_home_screen.dart';
import 'university_login_screen.dart';
import 'students_screen.dart';
import 'companies_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  // فرص التدريب تم حذفها من الـ Sidebar
  // لذلك طلبات التدريب أصبح index الخاص بها = 3
  int selectedIndex = 3;

  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = 'الكل';

  final List<Map<String, dynamic>> applications = [
    {
      'student': 'تالا حمدان',
      'studentId': '20231001',
      'major': 'هندسة البرمجيات',
      'company': 'Data Solutions',
      'training': 'تحليل البيانات',
      'date': '24/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + كشف العلامات',
      'gpa': '3.65',
    },
    {
      'student': 'ليان أحمد',
      'studentId': '20231002',
      'major': 'علوم الحاسوب',
      'company': 'Creative Hub',
      'training': 'التصميم و UI/UX',
      'date': '23/09/2026',
      'status': 'مقبول',
      'documents': 'السيرة الذاتية + Portfolio',
      'gpa': '3.82',
    },
    {
      'student': 'رنا سمير',
      'studentId': '20231003',
      'major': 'هندسة البرمجيات',
      'company': 'شركة التقنية المتقدمة',
      'training': 'تطوير تطبيقات Flutter',
      'date': '22/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + Portfolio',
      'gpa': '3.54',
    },
    {
      'student': 'محمد يوسف',
      'studentId': '20231004',
      'major': 'الأمن السيبراني',
      'company': 'SecureNet',
      'training': 'الأمن السيبراني',
      'date': '21/09/2026',
      'status': 'مقبول',
      'documents': 'السيرة الذاتية + شهادات',
      'gpa': '3.71',
    },
    {
      'student': 'نور علي',
      'studentId': '20231005',
      'major': 'هندسة البرمجيات',
      'company': 'Quality First',
      'training': 'ضمان الجودة واختبار البرمجيات',
      'date': '20/09/2026',
      'status': 'مرفوض',
      'documents': 'السيرة الذاتية',
      'gpa': '2.95',
    },
    {
      'student': 'سارة خالد',
      'studentId': '20231007',
      'major': 'هندسة البرمجيات',
      'company': 'Jordan Tech',
      'training': 'تطوير الواجهات الأمامية',
      'date': '19/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية + Portfolio',
      'gpa': '3.48',
    },
    {
      'student': 'أحمد محمد',
      'studentId': '20231006',
      'major': 'علوم الحاسوب',
      'company': 'Data Solutions',
      'training': 'تحليل البيانات',
      'date': '18/09/2026',
      'status': 'قيد المراجعة',
      'documents': 'السيرة الذاتية',
      'gpa': '3.32',
    },
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_refresh);
  }

  @override
  void dispose() {
    searchController.removeListener(_refresh);
    searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  List<Map<String, dynamic>> get filteredApplications {
    final search = searchController.text.trim().toLowerCase();

    return applications.where((application) {
      final matchesSearch =
          search.isEmpty ||
          application['student']
              .toString()
              .toLowerCase()
              .contains(search) ||
          application['studentId']
              .toString()
              .toLowerCase()
              .contains(search) ||
          application['training']
              .toString()
              .toLowerCase()
              .contains(search) ||
          application['company']
              .toString()
              .toLowerCase()
              .contains(search);

      final matchesStatus =
          selectedStatus == 'الكل' ||
          application['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _navigateTo(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    Widget? screen;

    switch (index) {
      case 0:
        screen = const UniversityHomeScreen();
        break;

      case 1:
        screen = const StudentsScreen();
        break;

      case 2:
        screen = const CompaniesScreen();
        break;

      case 3:
        return;

      case 4:
        screen = const CurrentTrainingsScreen();
        break;

      case 5:
        screen = const ReportsScreen();
        break;

      case 6:
        screen = const NotificationsScreen();
        break;

      case 7:
        screen = const SettingsScreen();
        break;
    }

    if (screen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => screen!,
        ),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UniversityLoginScreen(),
                    ),
                  );
                },
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayed = filteredApplications;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          textDirection: TextDirection.ltr,
          children: [
            // =====================================================
            // MAIN AREA
            // =====================================================

            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const UniDashboardHeader(
                      title: 'طلبات التدريب',
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          24,
                          28,
                          30,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'طلبات التدريب',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        MasarColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'عرض ومتابعة طلبات الطلاب المقدمة لبرامج التدريب',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color:
                                        MasarColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // =====================================================
                            // STATISTICS
                            // =====================================================

                            Row(
                              children: [
                                Expanded(
                                  child: _statCard(
                                    title: 'إجمالي الطلبات',
                                    value: '127',
                                    subtitle: 'طلب تدريب',
                                    icon:
                                        Icons.assignment_rounded,
                                    color:
                                        MasarColors.primaryBlue,
                                    background:
                                        MasarColors.lightBlue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _statCard(
                                    title: 'قيد المراجعة',
                                    value: '18',
                                    subtitle: 'طلب',
                                    icon:
                                        Icons.pending_actions_rounded,
                                    color:
                                        MasarColors.warning,
                                    background:
                                        const Color(0xFFFFF7E6),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _statCard(
                                    title: 'طلبات مقبولة',
                                    value: '84',
                                    subtitle: 'طلب',
                                    icon:
                                        Icons.check_circle_outline_rounded,
                                    color:
                                        MasarColors.primaryGreen,
                                    background:
                                        MasarColors.lightGreen,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _statCard(
                                    title: 'طلبات مرفوضة',
                                    value: '25',
                                    subtitle: 'طلب',
                                    icon:
                                        Icons.cancel_outlined,
                                    color:
                                        MasarColors.error,
                                    background:
                                        const Color(0xFFFFEEEE),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // =====================================================
                            // SEARCH + FILTER
                            // =====================================================

                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: MasarColors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                border: Border.all(
                                  color: MasarColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          searchController,
                                      decoration:
                                          InputDecoration(
                                        hintText:
                                            'ابحث عن طالب أو رقم جامعي أو تدريب أو شركة...',
                                        hintStyle: TextStyle(
                                          color: MasarColors
                                              .textSecondary,
                                          fontSize: 12.5,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: MasarColors
                                              .textSecondary,
                                        ),
                                        filled: true,
                                        fillColor:
                                            MasarColors.background,
                                        border:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide:
                                              BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal: 14,
                                          vertical: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  SizedBox(
                                    width: 190,
                                    child: _statusDropdown(),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // =====================================================
                            // APPLICATIONS TABLE
                            // =====================================================

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MasarColors.white,
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: MasarColors.border,
                                ),
                              ),
                              clipBehavior:
                                  Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(
                                      22,
                                      20,
                                      22,
                                      18,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration:
                                              BoxDecoration(
                                            color: MasarColors
                                                .lightBlue,
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons
                                                .assignment_rounded,
                                            color: MasarColors
                                                .primaryBlue,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              'قائمة طلبات التدريب',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                                color: MasarColors
                                                    .textPrimary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${displayed.length} طلب ظاهر',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: MasarColors
                                                    .textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(
                                    height: 1,
                                    color:
                                        MasarColors.border,
                                  ),

                                  _buildApplicationsTable(
                                    displayed,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // SIDEBAR - RIGHT
            // =====================================================

            UniDashboardSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: _navigateTo,
              onLogout: _logout,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        MasarColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color:
                        MasarColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color:
                        MasarColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS DROPDOWN
  // ============================================================

  Widget _statusDropdown() {
    return Container(
      height: 48,
      padding:
          const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: MasarColors.textSecondary,
          ),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.5,
            color: MasarColors.textPrimary,
          ),
          items: const [
            'الكل',
            'قيد المراجعة',
            'مقبول',
            'مرفوض',
          ].map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // APPLICATIONS TABLE
  // ============================================================

  Widget _buildApplicationsTable(
    List<Map<String, dynamic>> displayed,
  ) {
    if (displayed.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: MasarColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد طلبات مطابقة للبحث',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MasarColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: DataTable(
              headingRowHeight: 56,
              dataRowMinHeight: 72,
              dataRowMaxHeight: 80,
              columnSpacing: 28,
              horizontalMargin: 22,
              dividerThickness: 0.6,
              headingRowColor:
                  MaterialStateProperty.all(
                MasarColors.background,
              ),
              columns: const [
                DataColumn(
                  label: Text('الطالب'),
                ),
                DataColumn(
                  label: Text('الرقم الجامعي'),
                ),
                DataColumn(
                  label: Text('الشركة'),
                ),
                DataColumn(
                  label: Text('التدريب المتوفر'),
                ),
                DataColumn(
                  label: Text('تاريخ التقديم'),
                ),
                DataColumn(
                  label: Text('الحالة'),
                ),
                DataColumn(
                  label: Text('التفاصيل'),
                ),
              ],
              rows: displayed.map((application) {
                return DataRow(
                  cells: [
                    // الطالب
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Text(
                          application['student'],
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight.w700,
                            color: MasarColors
                                .textPrimary,
                          ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // الرقم الجامعي
                    DataCell(
                      Text(
                        application['studentId'],
                        style: TextStyle(
                          fontSize: 11.5,
                          color: MasarColors
                              .textSecondary,
                        ),
                      ),
                    ),

                    // الشركة
                    DataCell(
                      SizedBox(
                        width: 135,
                        child: Text(
                          application['company'],
                          style: TextStyle(
                            fontSize: 12,
                            color: MasarColors
                                .textPrimary,
                          ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // التدريب المتوفر
                    DataCell(
                      SizedBox(
                        width: 170,
                        child: Text(
                          application['training'],
                          style: TextStyle(
                            fontSize: 12,
                            color: MasarColors
                                .textPrimary,
                            fontWeight:
                                FontWeight.w600,
                          ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // تاريخ التقديم
                    DataCell(
                      Text(
                        application['date'],
                        style: TextStyle(
                          fontSize: 11.5,
                          color: MasarColors
                              .textSecondary,
                        ),
                      ),
                    ),

                    // الحالة
                    DataCell(
                      _statusBadge(
                        application['status'],
                      ),
                    ),

                    // التفاصيل
                    DataCell(
                      IconButton(
                        tooltip: 'عرض التفاصيل',
                        onPressed: () {
                          _showApplicationDetails(
                            application,
                          );
                        },
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: MasarColors
                              .primaryBlue,
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    Color color;
    Color background;

    switch (status) {
      case 'مقبول':
        color = MasarColors.primaryGreen;
        background =
            MasarColors.lightGreen;
        break;

      case 'مرفوض':
        color = MasarColors.error;
        background =
            const Color(0xFFFFEEEE);
        break;

      default:
        color = MasarColors.warning;
        background =
            const Color(0xFFFFF7E6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APPLICATION DETAILS
  // ============================================================

  void _showApplicationDetails(
    Map<String, dynamic> application,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 680,
              constraints:
                  const BoxConstraints(
                maxHeight: 720,
              ),
              decoration: BoxDecoration(
                color: MasarColors.white,
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // =====================================================
                    // HEADER
                    // =====================================================

                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration:
                              BoxDecoration(
                            color:
                                MasarColors.lightBlue,
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Icon(
                            Icons
                                .assignment_rounded,
                            color: MasarColors
                                .primaryBlue,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'تفاصيل طلب التدريب',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w800,
                                  color: MasarColors
                                      .textPrimary,
                                ),
                              ),
                              const SizedBox(
                                  height: 4),
                              Text(
                                application[
                                    'training'],
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: MasarColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _statusBadge(
                          application['status'],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(
                            context,
                          ),
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // STUDENT DATA
                    // =====================================================

                    _detailSection(
                      title: 'بيانات الطالب',
                      children: [
                        _detailItem(
                          'اسم الطالب',
                          application['student'],
                          Icons
                              .person_outline_rounded,
                        ),
                        _detailItem(
                          'الرقم الجامعي',
                          application[
                              'studentId'],
                          Icons
                              .badge_outlined,
                        ),
                        _detailItem(
                          'التخصص',
                          application['major'],
                          Icons
                              .school_outlined,
                        ),
                        _detailItem(
                          'المعدل التراكمي',
                          application['gpa'],
                          Icons
                              .grade_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // APPLICATION DATA
                    // =====================================================

                    _detailSection(
                      title: 'بيانات الطلب',
                      children: [
                        _detailItem(
                          'الشركة',
                          application['company'],
                          Icons
                              .business_outlined,
                        ),
                        _detailItem(
                          'التدريب المتوفر',
                          application['training'],
                          Icons
                              .work_outline_rounded,
                        ),
                        _detailItem(
                          'تاريخ التقديم',
                          application['date'],
                          Icons
                              .calendar_today_outlined,
                        ),
                        _detailItem(
                          'حالة الطلب',
                          application['status'],
                          Icons
                              .info_outline_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // DOCUMENTS
                    // =====================================================

                    _detailSection(
                      title: 'الوثائق المرفقة',
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .description_outlined,
                              color: MasarColors
                                  .primaryBlue,
                              size: 19,
                            ),
                            const SizedBox(
                                width: 9),
                            Expanded(
                              child: Text(
                                application[
                                    'documents'],
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: MasarColors
                                      .textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // INFO
                    // =====================================================

                    Container(
                      padding:
                          const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(
                        color:
                            MasarColors.background,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        border: Border.all(
                          color:
                              MasarColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .info_outline_rounded,
                            color: MasarColors
                                .primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(
                              width: 10),
                          Expanded(
                            child: Text(
                              'هذه الشاشة مخصصة لعرض ومتابعة حالة الطلب فقط.',
                              style: TextStyle(
                                fontSize: 12,
                                color: MasarColors
                                    .textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL SECTION
  // ============================================================

  Widget _detailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color:
                  MasarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ITEM
  // ============================================================

  Widget _detailItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
                BoxDecoration(
              color: MasarColors.white,
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color:
                  MasarColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 12,
              color:
                  MasarColors.textSecondary,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color:
                    MasarColors.textPrimary,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

