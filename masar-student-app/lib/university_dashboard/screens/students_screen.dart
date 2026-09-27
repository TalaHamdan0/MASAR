
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_header.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';
import 'university_home_screen.dart';
import 'companies_screen.dart';

import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  int selectedIndex = 1;

  final TextEditingController searchController =
      TextEditingController();

  String selectedMajor = 'الكل';
  String selectedTrainingStatus = 'الكل';

  final List<Map<String, dynamic>> students = [
    {
      'name': 'تالا حمدان',
      'id': '20231001',
      'major': 'هندسة البرمجيات',
      'careerPath': 'تحليل البيانات',
      'trainingStatus': 'مستمر',
      'hours': '164/280',
      'accountStatus': 'نشط',
      'gpa': '3.72',
      'email': 'tala@example.com',
      'phone': '0790000001',
      'skills': ['Python', 'SQL', 'Excel', 'Power BI'],
      'certificates': ['Python Basics', 'Data Analysis'],
      'projects': ['MASAR', 'Student Analytics Dashboard'],
      'reports': 8,
    },
    {
      'name': 'ليان أحمد',
      'id': '20231002',
      'major': 'علوم الحاسوب',
      'careerPath': 'التصميم',
      'trainingStatus': 'مستمر',
      'hours': '210/280',
      'accountStatus': 'نشط',
      'gpa': '3.85',
      'email': 'layan@example.com',
      'phone': '0790000002',
      'skills': ['Figma', 'UI/UX', 'Adobe XD'],
      'certificates': ['UI/UX Fundamentals'],
      'projects': ['MASAR UI Redesign'],
      'reports': 11,
    },
    {
      'name': 'رنا سمير',
      'id': '20231003',
      'major': 'هندسة البرمجيات',
      'careerPath': 'تطوير التطبيقات',
      'trainingStatus': 'مستمر',
      'hours': '245/280',
      'accountStatus': 'نشط',
      'gpa': '3.61',
      'email': 'rana@example.com',
      'phone': '0790000003',
      'skills': ['Flutter', 'Dart', 'Firebase'],
      'certificates': ['Flutter Development'],
      'projects': ['Mobile Training App'],
      'reports': 14,
    },
    {
      'name': 'محمد يوسف',
      'id': '20231004',
      'major': 'الأمن السيبراني',
      'careerPath': 'الأمن السيبراني',
      'trainingStatus': 'مستمر',
      'hours': '98/280',
      'accountStatus': 'نشط',
      'gpa': '3.54',
      'email': 'mohammad@example.com',
      'phone': '0790000004',
      'skills': ['Networking', 'Linux', 'Cybersecurity'],
      'certificates': ['Network Security'],
      'projects': ['Security Monitoring System'],
      'reports': 5,
    },
    {
      'name': 'نور علي',
      'id': '20231005',
      'major': 'هندسة البرمجيات',
      'careerPath': 'ضمان الجودة',
      'trainingStatus': 'مكتمل',
      'hours': '280/280',
      'accountStatus': 'نشط',
      'gpa': '3.91',
      'email': 'noor@example.com',
      'phone': '0790000005',
      'skills': ['Testing', 'Selenium', 'Jira'],
      'certificates': ['Software Testing'],
      'projects': ['QA Automation Project'],
      'reports': 18,
    },
    {
      'name': 'سارة خالد',
      'id': '20231007',
      'major': 'هندسة البرمجيات',
      'careerPath': 'تطوير الويب',
      'trainingStatus': 'لم يبدأ',
      'hours': '0/280',
      'accountStatus': 'نشط',
      'gpa': '3.48',
      'email': 'sara@example.com',
      'phone': '0790000007',
      'skills': ['HTML', 'CSS', 'JavaScript'],
      'certificates': ['Web Fundamentals'],
      'projects': ['Portfolio Website'],
      'reports': 0,
    },
    {
      'name': 'أحمد محمد',
      'id': '20231006',
      'major': 'علوم الحاسوب',
      'careerPath': 'تحليل البيانات',
      'trainingStatus': 'متأخر',
      'hours': '132/280',
      'accountStatus': 'نشط',
      'gpa': '3.32',
      'email': 'ahmad@example.com',
      'phone': '0790000006',
      'skills': ['Python', 'Excel', 'SQL'],
      'certificates': ['Excel Advanced'],
      'projects': ['Sales Dashboard'],
      'reports': 7,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredStudents {
    final query =
        searchController.text.trim().toLowerCase();

    return students.where((student) {
      final matchesSearch =
          student['name']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              student['id']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              student['major']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              student['careerPath']
                  .toString()
                  .toLowerCase()
                  .contains(query);

      final matchesMajor =
          selectedMajor == 'الكل' ||
              student['major'] == selectedMajor;

      final matchesTraining =
          selectedTrainingStatus == 'الكل' ||
              student['trainingStatus'] ==
                  selectedTrainingStatus;

      return matchesSearch &&
          matchesMajor &&
          matchesTraining;
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
        screen =  const UniversityHomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UniversityHomeScreen(),
      ),
    );
  }

  void showStudentDetails(
      Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 720,
              constraints: const BoxConstraints(
                maxHeight: 760,
              ),
              decoration: BoxDecoration(
                color: MasarColors.white,
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color:
                                MasarColors.lightBlue,
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color:
                                MasarColors.primaryBlue,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['name'],
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight:
                                      FontWeight.w800,
                                  color: MasarColors
                                      .textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                student['id'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MasarColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _accountBadge(
                          student['accountStatus'],
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    _sectionTitle(
                      'المعلومات الأكاديمية',
                      Icons.school_outlined,
                    ),

                    const SizedBox(height: 12),

                    _sectionContainer(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'اسم الطالب',
                                student['name'],
                                Icons
                                    .person_outline_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'الرقم الجامعي',
                                student['id'],
                                Icons.badge_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'التخصص',
                                student['major'],
                                Icons
                                    .menu_book_outlined,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'المعدل التراكمي',
                                student['gpa'],
                                Icons.grade_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'البريد الإلكتروني',
                                student['email'],
                                Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'رقم الهاتف',
                                student['phone'],
                                Icons.phone_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(
                      'المسار والتدريب',
                      Icons.route_outlined,
                    ),

                    const SizedBox(height: 12),

                    _sectionContainer(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'المسار المهني',
                                student['careerPath'],
                                Icons.route_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'حالة التدريب',
                                student[
                                    'trainingStatus'],
                                Icons.school_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'ساعات التدريب',
                                student['hours'],
                                Icons
                                    .access_time_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'التقارير',
                                '${student['reports']} تقارير',
                                Icons
                                    .description_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(
                      'المهارات',
                      Icons.auto_awesome_outlined,
                    ),

                    const SizedBox(height: 12),

                    _sectionContainer(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              (student['skills'] as List)
                                  .map(
                                    (skill) =>
                                        Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: MasarColors
                                            .lightBlue,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        skill.toString(),
                                        style: TextStyle(
                                          color: MasarColors
                                              .primaryBlue,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(
                      'الشهادات',
                      Icons.workspace_premium_outlined,
                    ),

                    const SizedBox(height: 12),

                    _sectionContainer(
                      children: [
                        ...(student['certificates']
                                as List)
                            .map(
                          (certificate) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .verified_rounded,
                                    size: 19,
                                    color: MasarColors
                                        .primaryGreen,
                                  ),
                                  const SizedBox(
                                      width: 10),
                                  Text(
                                    certificate.toString(),
                                    style:
                                        const TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: MasarColors
                                          .textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(
                      'المشاريع',
                      Icons.code_rounded,
                    ),

                    const SizedBox(height: 12),

                    _sectionContainer(
                      children: [
                        ...(student['projects'] as List)
                            .map(
                          (project) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.folder_rounded,
                                    size: 19,
                                    color: MasarColors
                                        .primaryBlue,
                                  ),
                                  const SizedBox(
                                      width: 10),
                                  Text(
                                    project.toString(),
                                    style:
                                        const TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: MasarColors
                                          .textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: MasarColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: MasarColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _sectionContainer({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _detailItem(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: MasarColors.textSecondary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color:
                      MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accountBadge(String status) {
    final isActive = status == 'نشط';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? MasarColors.lightGreen
            : MasarColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive
              ? MasarColors.primaryGreen
              : MasarColors.error,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _trainingBadge(String status) {
    Color color;
    Color background;

    switch (status) {
      case 'مكتمل':
        color = MasarColors.primaryGreen;
        background = MasarColors.lightGreen;
        break;

      case 'متأخر':
        color = MasarColors.error;
        background =
            MasarColors.error.withOpacity(0.08);
        break;

      case 'مستمر':
        color = MasarColors.primaryBlue;
        background = MasarColors.lightBlue;
        break;

      case 'لم يبدأ':
        color = MasarColors.textSecondary;
        background = MasarColors.background;
        break;

      default:
        color = MasarColors.textSecondary;
        background = MasarColors.background;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
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
        height: 125,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MasarColors.white,
          borderRadius: BorderRadius.circular(20),
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
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color:
                          MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
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
      ),
    );
  }

  Widget _buildTable() {
    final data = filteredStudents;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: DataTable(
                  headingRowHeight: 54,
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 75,
                  columnSpacing: 30,
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
                      label: Text('التخصص'),
                    ),
                    DataColumn(
                      label: Text('المسار المهني'),
                    ),
                    DataColumn(
                      label: Text('حالة التدريب'),
                    ),
                    DataColumn(
                      label: Text('ساعات التدريب'),
                    ),
                    DataColumn(
                      label: Text('حالة الحساب'),
                    ),
                    DataColumn(
                      label: Text('التفاصيل'),
                    ),
                  ],
                  rows: data.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration:
                                    BoxDecoration(
                                  color: MasarColors
                                      .lightBlue,
                                  borderRadius:
                                      BorderRadius
                                          .circular(10),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 19,
                                  color: MasarColors
                                      .primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                student['name'],
                                style:
                                    const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            student['id'],
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: MasarColors
                                  .textSecondary,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            student['major'],
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            student['careerPath'],
                            style:
                                const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        DataCell(
                          _trainingBadge(
                            student[
                                'trainingStatus'],
                          ),
                        ),
                        DataCell(
                          Text(
                            student['hours'],
                            style:
                                const TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                        DataCell(
                          _accountBadge(
                            student[
                                'accountStatus'],
                          ),
                        ),
                        DataCell(
                          IconButton(
                            tooltip: 'عرض التفاصيل',
                            onPressed: () {
                              showStudentDetails(
                                  student);
                            },
                            icon: Icon(
                              Icons
                                  .visibility_outlined,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = students.length;

    final activeStudents = students
        .where(
          (student) =>
              student['accountStatus'] == 'نشط',
        )
        .length;

    final trainingStudents = students
        .where(
          (student) =>
              student['trainingStatus'] == 'مستمر',
        )
        .length;

    final completedStudents = students
        .where(
          (student) =>
              student['trainingStatus'] == 'مكتمل',
        )
        .length;

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
                      title: 'الطلاب',
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.fromLTRB(
                          30,
                          25,
                          30,
                          35,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الطلاب',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.w800,
                                color: MasarColors
                                    .textPrimary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              'إدارة ومتابعة بيانات الطلاب وحالة التدريب',
                              style: TextStyle(
                                fontSize: 13,
                                color: MasarColors
                                    .textSecondary,
                              ),
                            ),

                            const SizedBox(height: 25),

                            Row(
                              children: [
                                _statCard(
                                  'إجمالي الطلاب',
                                  '$totalStudents',
                                  'طالب مسجل',
                                  Icons.people_alt_rounded,
                                  MasarColors
                                      .primaryBlue,
                                  MasarColors
                                      .lightBlue,
                                ),
                                const SizedBox(
                                    width: 16),
                                _statCard(
                                  'الحسابات النشطة',
                                  '$activeStudents',
                                  'حساب نشط',
                                  Icons
                                      .verified_user_rounded,
                                  MasarColors
                                      .primaryGreen,
                                  MasarColors
                                      .lightGreen,
                                ),
                                const SizedBox(
                                    width: 16),
                                _statCard(
                                  'في التدريب',
                                  '$trainingStudents',
                                  'طالب',
                                  Icons.school_rounded,
                                  MasarColors.warning,
                                  MasarColors.warning
                                      .withOpacity(0.10),
                                ),
                                const SizedBox(
                                    width: 16),
                                _statCard(
                                  'التدريب المكتمل',
                                  '$completedStudents',
                                  'طالب',
                                  Icons
                                      .check_circle_rounded,
                                  MasarColors
                                      .primaryGreen,
                                  MasarColors
                                      .lightGreen,
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    MasarColors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                                border: Border.all(
                                  color:
                                      MasarColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          searchController,
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                      decoration:
                                          InputDecoration(
                                        hintText:
                                            'ابحث باسم الطالب، الرقم الجامعي، التخصص أو المسار...',
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
                                            13,
                                          ),
                                          borderSide:
                                              BorderSide
                                                  .none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets
                                                .symmetric(
                                          vertical: 13,
                                          horizontal: 15,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 14),

                                  _filterDropdown(
                                    value:
                                        selectedMajor,
                                    items: const [
                                      'الكل',
                                      'هندسة البرمجيات',
                                      'علوم الحاسوب',
                                      'الأمن السيبراني',
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMajor =
                                            value!;
                                      });
                                    },
                                    hint: 'التخصص',
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  _filterDropdown(
                                    value:
                                        selectedTrainingStatus,
                                    items: const [
                                      'الكل',
                                      'مستمر',
                                      'مكتمل',
                                      'متأخر',
                                      'لم يبدأ',
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTrainingStatus =
                                            value!;
                                      });
                                    },
                                    hint:
                                        'حالة التدريب',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            Row(
                              children: [
                                const Text(
                                  'قائمة الطلاب',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.w800,
                                    color: MasarColors
                                        .textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: MasarColors
                                        .lightBlue,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),
                                  child: Text(
                                    '${filteredStudents.length}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.w700,
                                      color: MasarColors
                                          .primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            _buildTable(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // SIDEBAR — RIGHT
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

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12.5,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
