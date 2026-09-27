
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import 'university_home_screen.dart';
import 'students_screen.dart';

import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'university_login_screen.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  int selectedIndex = 2;

  final TextEditingController searchController =
      TextEditingController();

  String selectedField = 'الكل';
  String selectedStatus = 'الكل';

  final List<Map<String, dynamic>> companies = [
    {
      'name': 'Data Solutions',
      'field': 'تحليل البيانات',
      'location': 'عمّان',
      'opportunities': 6,
      'trainees': 18,
      'status': 'نشطة',
      'email': 'info@datasolutions.com',
      'phone': '06 555 1234',
      'description':
          'شركة متخصصة في تحليل البيانات وحلول ذكاء الأعمال وتطوير التقارير الرقمية.',
      'opportunityList': [
        'Data Analyst Intern',
        'Business Intelligence Intern',
        'Power BI Intern',
      ],
      'traineeList': [
        'تالا حمدان',
        'محمد يوسف',
        'سارة خالد',
      ],
    },
    {
      'name': 'Creative Hub',
      'field': 'التصميم',
      'location': 'عمّان',
      'opportunities': 4,
      'trainees': 12,
      'status': 'نشطة',
      'email': 'info@creativehub.com',
      'phone': '06 565 2345',
      'description':
          'شركة تعمل في مجال التصميم وتجربة المستخدم والهوية البصرية.',
      'opportunityList': [
        'UI/UX Design Intern',
        'Graphic Design Intern',
      ],
      'traineeList': [
        'ليان أحمد',
        'نور علي',
      ],
    },
    {
      'name': 'شركة التقنية المتقدمة',
      'field': 'تطوير البرمجيات',
      'location': 'الزرقاء',
      'opportunities': 5,
      'trainees': 15,
      'status': 'نشطة',
      'email': 'info@advancedtech.com',
      'phone': '05 333 7788',
      'description':
          'شركة متخصصة في تطوير تطبيقات الويب والموبايل والحلول البرمجية.',
      'opportunityList': [
        'Flutter Developer Intern',
        'Web Developer Intern',
        'Software Engineer Intern',
      ],
      'traineeList': [
        'رنا سمير',
        'أحمد محمد',
        'عمر فهد',
      ],
    },
    {
      'name': 'SecureNet',
      'field': 'الأمن السيبراني',
      'location': 'عمّان',
      'opportunities': 3,
      'trainees': 9,
      'status': 'نشطة',
      'email': 'info@securenet.com',
      'phone': '06 577 8899',
      'description':
          'شركة متخصصة في الأمن السيبراني وحماية الأنظمة والشبكات.',
      'opportunityList': [
        'Cybersecurity Intern',
        'SOC Analyst Intern',
      ],
      'traineeList': [
        'محمد يوسف',
        'خالد أحمد',
      ],
    },
    {
      'name': 'Quality First',
      'field': 'ضمان الجودة',
      'location': 'إربد',
      'opportunities': 2,
      'trainees': 7,
      'status': 'نشطة',
      'email': 'info@qualityfirst.com',
      'phone': '02 721 4567',
      'description':
          'شركة متخصصة في اختبار البرمجيات وضمان جودة الأنظمة والتطبيقات.',
      'opportunityList': [
        'QA Intern',
        'Software Testing Intern',
      ],
      'traineeList': [
        'نور علي',
        'سارة خالد',
      ],
    },
    {
      'name': 'Jordan Tech',
      'field': 'تطوير الويب',
      'location': 'عمّان',
      'opportunities': 3,
      'trainees': 8,
      'status': 'متوقفة مؤقتًا',
      'email': 'info@jordantech.com',
      'phone': '06 544 2211',
      'description':
          'شركة تعمل في تطوير مواقع الويب والمنصات الرقمية.',
      'opportunityList': [
        'Frontend Developer Intern',
        'Backend Developer Intern',
      ],
      'traineeList': [
        'أحمد محمد',
      ],
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCompanies {
    final query = searchController.text.trim().toLowerCase();

    return companies.where((company) {
      final matchesSearch =
          query.isEmpty ||
          company['name']
              .toString()
              .toLowerCase()
              .contains(query) ||
          company['field']
              .toString()
              .toLowerCase()
              .contains(query) ||
          company['location']
              .toString()
              .toLowerCase()
              .contains(query);

      final matchesField =
          selectedField == 'الكل' ||
          company['field'] == selectedField;

      final matchesStatus =
          selectedStatus == 'الكل' ||
          company['status'] == selectedStatus;

      return matchesSearch &&
          matchesField &&
          matchesStatus;
    }).toList();
  }

  void navigateTo(int index) {
    if (index == selectedIndex) return;

    Widget screen;

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
  screen = const ApplicationsScreen();
  break;

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

      case 8:
        screen = const SettingsScreen();
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void logout() {
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

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const UniversityLoginScreen(),
                    ),
                    (route) => false,
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

  void showCompanyDetails(
    Map<String, dynamic> company,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: MasarColors.primaryBlue,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    company['name'],
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _detailRow(
                      'التدريب المتوفر',
                      (company['opportunityList'] as List)
                          .join('، '),
                      Icons.work_outline_rounded,
                    ),

                    _detailRow(
                      'الموقع',
                      company['location'],
                      Icons.location_on_outlined,
                    ),

                    _detailRow(
                      'البريد الإلكتروني',
                      company['email'],
                      Icons.email_outlined,
                    ),

                    _detailRow(
                      'رقم الهاتف',
                      company['phone'],
                      Icons.phone_outlined,
                    ),

                    _detailRow(
                      'حالة الشركة',
                      company['status'],
                      Icons.verified_outlined,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'نبذة عن الشركة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      company['description'],
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.6,
                        color: MasarColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'التدريبات المتوفرة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...List.generate(
                      (company['opportunityList']
                              as List)
                          .length,
                      (index) {
                        final opportunity =
                            company['opportunityList']
                                [index];

                        return Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color:
                                MasarColors.background,
                            borderRadius:
                                BorderRadius.circular(11),
                            border: Border.all(
                              color:
                                  MasarColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .work_outline_rounded,
                                size: 19,
                                color:
                                    MasarColors
                                        .primaryBlue,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  opportunity,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        MasarColors
                                            .textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _infoBox(
                            'التدريبات المتوفرة',
                            '${(company['opportunityList'] as List).length}',
                            Icons.work_rounded,
                            MasarColors.primaryBlue,
                            MasarColors.lightBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoBox(
                            'المتدربون',
                            '${company['trainees']}',
                            Icons.people_alt_rounded,
                            MasarColors.primaryGreen,
                            MasarColors.lightGreen,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'الطلاب المتدربون',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: MasarColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...(company['traineeList'] as List)
                            .map(
                          (trainee) => Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  MasarColors.lightGreen,
                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),
                            child: Text(
                              trainee,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    MasarColors
                                        .primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: MasarColors.lightBlue,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: MasarColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MasarColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: MasarColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(
    String title,
    String value,
    IconData icon,
    Color color,
    Color background,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 21,
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color:
                      MasarColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    Color background,
  ) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(17),
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
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color:
                          MasarColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9.5,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool active = status == 'نشطة';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? MasarColors.lightGreen
            : MasarColors.warning
                .withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: active
              ? MasarColors.primaryGreen
              : MasarColors.warning,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedCompanies =
        filteredCompanies;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const UniDashboardHeader(
                      title: 'الشركات',
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إدارة الشركات',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight:
                                    FontWeight.w800,
                                color:
                                    MasarColors
                                        .textPrimary,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'إدارة الجهات التدريبية ومتابعة الشركات المسجلة في المنصة',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    MasarColors
                                        .textSecondary,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                _statCard(
                                  'الشركات المتاحة للتدريب',
                                  '72',
                                  'شركة',
                                  Icons
                                      .business_center_rounded,
                                  MasarColors
                                      .primaryGreen,
                                  MasarColors
                                      .lightGreen,
                                ),

                                const SizedBox(width: 14),

                                _statCard(
                                  'الشركات النشطة',
                                  '72',
                                  'شركة',
                                  Icons
                                      .business_rounded,
                                  MasarColors
                                      .primaryBlue,
                                  MasarColors
                                      .lightBlue,
                                ),

                                const SizedBox(width: 14),

                                _statCard(
                                  'إجمالي الفرص',
                                  '143',
                                  'فرصة تدريب',
                                  Icons.work_rounded,
                                  MasarColors
                                      .primaryBlue,
                                  MasarColors
                                      .lightBlue,
                                ),

                                const SizedBox(width: 14),

                                _statCard(
                                  'الطلاب المتدربون',
                                  '386',
                                  'طالب',
                                  Icons
                                      .people_alt_rounded,
                                  MasarColors
                                      .primaryGreen,
                                  MasarColors
                                      .lightGreen,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                      18),
                              decoration:
                                  BoxDecoration(
                                color:
                                    MasarColors.white,
                                borderRadius:
                                    BorderRadius
                                        .circular(18),
                                border: Border.all(
                                  color:
                                      MasarColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller:
                                          searchController,
                                      onChanged: (_) =>
                                          setState(
                                              () {}),
                                      decoration:
                                          InputDecoration(
                                        hintText:
                                            'ابحث باسم الشركة أو المجال أو الموقع...',
                                        prefixIcon:
                                            const Icon(
                                          Icons
                                              .search_rounded,
                                        ),
                                        filled: true,
                                        fillColor:
                                            MasarColors
                                                .background,
                                        border:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      12),
                                          borderSide:
                                              BorderSide
                                                  .none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  Expanded(
                                    child:
                                        DropdownButtonFormField<
                                            String>(
                                      value:
                                          selectedField,
                                      decoration:
                                          InputDecoration(
                                        labelText:
                                            'المجال',
                                        filled: true,
                                        fillColor:
                                            MasarColors
                                                .background,
                                        border:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      12),
                                          borderSide:
                                              BorderSide
                                                  .none,
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'الكل',
                                          child: Text(
                                              'كل المجالات'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'تحليل البيانات',
                                          child: Text(
                                              'تحليل البيانات'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'التصميم',
                                          child: Text(
                                              'التصميم'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'تطوير البرمجيات',
                                          child: Text(
                                              'تطوير البرمجيات'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'الأمن السيبراني',
                                          child: Text(
                                              'الأمن السيبراني'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'ضمان الجودة',
                                          child: Text(
                                              'ضمان الجودة'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'تطوير الويب',
                                          child: Text(
                                              'تطوير الويب'),
                                        ),
                                      ],
                                      onChanged:
                                          (value) {
                                        setState(() {
                                          selectedField =
                                              value ??
                                                  'الكل';
                                        });
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  Expanded(
                                    child:
                                        DropdownButtonFormField<
                                            String>(
                                      value:
                                          selectedStatus,
                                      decoration:
                                          InputDecoration(
                                        labelText:
                                            'حالة الشركة',
                                        filled: true,
                                        fillColor:
                                            MasarColors
                                                .background,
                                        border:
                                            OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      12),
                                          borderSide:
                                              BorderSide
                                                  .none,
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'الكل',
                                          child: Text(
                                              'كل الحالات'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'نشطة',
                                          child: Text(
                                              'نشطة'),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'متوقفة مؤقتًا',
                                          child: Text(
                                              'متوقفة مؤقتًا'),
                                        ),
                                      ],
                                      onChanged:
                                          (value) {
                                        setState(() {
                                          selectedStatus =
                                              value ??
                                                  'الكل';
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Container(
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(
                                color:
                                    MasarColors.white,
                                borderRadius:
                                    BorderRadius
                                        .circular(18),
                                border: Border.all(
                                  color:
                                      MasarColors.border,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets
                                        .all(18),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'الشركات المتاحة للتدريب',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                            color:
                                                MasarColors
                                                    .textPrimary,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 10),
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 9,
                                            vertical: 4,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color:
                                                MasarColors
                                                    .lightGreen,
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        20),
                                          ),
                                          child: Text(
                                            '${displayedCompanies.length}',
                                            style:
                                                TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                              color:
                                                  MasarColors
                                                      .primaryGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                        height: 16),

                                    LayoutBuilder(
                                      builder: (
                                        context,
                                        constraints,
                                      ) {
                                        return SingleChildScrollView(
                                          scrollDirection:
                                              Axis.horizontal,
                                          child:
                                              ConstrainedBox(
                                            constraints:
                                                BoxConstraints(
                                              minWidth:
                                                  constraints
                                                      .maxWidth,
                                            ),
                                            child:
                                                DataTable(
                                              headingRowColor:
                                                  WidgetStateProperty
                                                      .all(
                                                MasarColors
                                                    .background,
                                              ),
                                              columnSpacing:
                                                  28,
                                              horizontalMargin:
                                                  12,
                                              columns:
                                                  const [
                                                DataColumn(
                                                  label: Text(
                                                      'الشركة'),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'التدريب المتوفر'),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'الموقع'),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'المتدربون'),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'الحالة'),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'التفاصيل'),
                                                ),
                                              ],
                                              rows:
                                                  displayedCompanies
                                                      .map(
                                                (company) {
                                                  final List
                                                      opportunities =
                                                      company[
                                                              'opportunityList']
                                                          as List;

                                                  return DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: 38,
                                                              height: 38,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    MasarColors.lightBlue,
                                                                borderRadius:
                                                                    BorderRadius.circular(11),
                                                              ),
                                                              child:
                                                                  Icon(
                                                                Icons
                                                                    .business_rounded,
                                                                size: 19,
                                                                color:
                                                                    MasarColors.primaryBlue,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 9),
                                                            Text(
                                                              company[
                                                                  'name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      DataCell(
                                                        SizedBox(
                                                          width:
                                                              250,
                                                          child:
                                                              Text(
                                                            opportunities.join(
                                                                '، '),
                                                            maxLines:
                                                                2,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style:
                                                                TextStyle(
                                                              fontSize:
                                                                  11.5,
                                                              color:
                                                                  MasarColors.textPrimary,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      DataCell(
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size:
                                                                  16,
                                                              color:
                                                                  MasarColors.textSecondary,
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              company[
                                                                  'location'],
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      DataCell(
                                                        Text(
                                                          '${company['trainees']}',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),

                                                      DataCell(
                                                        _statusBadge(
                                                          company[
                                                              'status'],
                                                        ),
                                                      ),

                                                      DataCell(
                                                        IconButton(
                                                          tooltip:
                                                              'عرض التفاصيل',
                                                          onPressed:
                                                              () {
                                                            showCompanyDetails(
                                                              company,
                                                            );
                                                          },
                                                          icon:
                                                              Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size:
                                                                16,
                                                            color:
                                                                MasarColors.primaryBlue,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
            // SIDEBAR — يمين الشاشة
            // =====================================================
            UniDashboardSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: navigateTo,
              onLogout: logout,
            ),
          ],
        ),
      ),
    );
  }
}
