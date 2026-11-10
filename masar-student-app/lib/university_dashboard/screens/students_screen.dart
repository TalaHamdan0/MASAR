<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_auth_service.dart';
import '../../core/services/university_students_service.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedMajor = 'الكل';
  String selectedTrainingStatus = 'الكل';

<<<<<<< HEAD
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
=======
  List<Map<String, dynamic>> students = [];

  Map<String, dynamic> statistics = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final data = await UniversityStudentsService.fetchStudents();

      final studentsData = data['students'] as List? ?? [];
      final statisticsData = data['statistics'] as Map? ?? {};

      if (!mounted) return;

      setState(() {
        students = studentsData
            .map((student) => Map<String, dynamic>.from(student as Map))
            .toList();

        statistics = Map<String, dynamic>.from(statisticsData);

        isLoading = false;
        errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error is UniversityAuthException
            ? error.message
            : 'حدث خطأ أثناء تحميل بيانات الطلاب.';

        isLoading = false;
      });
    }
  }

  int _getNumber(String key) {
    final value = statistics[key];

    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<String> get majorOptions {
    final majors = students
        .map((student) => student['major'].toString())
        .where((major) => major.isNotEmpty && major != 'غير محدد')
        .toSet()
        .toList();

    majors.sort();

    return ['الكل', ...majors];
  }
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredStudents {
    final query = searchController.text.trim().toLowerCase();

    return students.where((student) {
      final matchesSearch =
          student['name'].toString().toLowerCase().contains(query) ||
          student['id'].toString().toLowerCase().contains(query) ||
          student['major'].toString().toLowerCase().contains(query) ||
          student['careerPath'].toString().toLowerCase().contains(query);

<<<<<<< HEAD
      final matchesMajor = selectedMajor == 'الكل' ||
          student['major'] == selectedMajor;

      final matchesTraining = selectedTrainingStatus == 'الكل' ||
=======
      final matchesMajor =
          selectedMajor == 'الكل' || student['major'] == selectedMajor;

      final matchesTraining =
          selectedTrainingStatus == 'الكل' ||
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          student['trainingStatus'] == selectedTrainingStatus;

      return matchesSearch && matchesMajor && matchesTraining;
    }).toList();
  }

  void showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
<<<<<<< HEAD
          textDirection: TextDirection.rtl,
=======
          textDirection: Directionality.of(context),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 720,
              constraints: const BoxConstraints(maxHeight: 760),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: MasarColors.white,
=======
                color: UniColors.white,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
<<<<<<< HEAD
                            color: MasarColors.lightBlue,
=======
                            color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
<<<<<<< HEAD
                            color: MasarColors.primaryBlue,
=======
                            color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
<<<<<<< HEAD
                              Text(
                                student['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: MasarColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                student['id'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MasarColors.textSecondary,
=======
                              UniText(
                                student['name'].toString(),
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: UniColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              UniText(
                                student['id'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                ),
                              ),
                            ],
                          ),
                        ),
                        _accountBadge(student['accountStatus'].toString()),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

<<<<<<< HEAD
                    _sectionTitle('المعلومات الأكاديمية', Icons.school_outlined),
=======
                    _sectionTitle(
                      'المعلومات الأكاديمية',
                      Icons.school_outlined,
                    ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    const SizedBox(height: 12),
                    _sectionContainer(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'اسم الطالب',
                                student['name'].toString(),
                                Icons.person_outline_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'الرقم الجامعي',
                                student['id'].toString(),
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
                                student['major'].toString(),
                                Icons.menu_book_outlined,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'المعدل التراكمي',
                                student['gpa'].toString(),
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
                                student['email'].toString(),
                                Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'رقم الهاتف',
                                student['phone'].toString(),
                                Icons.phone_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _sectionTitle('المسار والتدريب', Icons.route_outlined),
                    const SizedBox(height: 12),
                    _sectionContainer(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _detailItem(
                                'المسار المهني',
                                student['careerPath'].toString(),
                                Icons.route_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'حالة التدريب',
                                student['trainingStatus'].toString(),
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
                                student['hours'].toString(),
                                Icons.access_time_rounded,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _detailItem(
                                'التقارير',
                                '${student['reports']} تقارير',
                                Icons.description_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _sectionTitle('المهارات', Icons.auto_awesome_outlined),
                    const SizedBox(height: 12),
                    _sectionContainer(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (student['skills'] as List)
                              .map(
                                (skill) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
<<<<<<< HEAD
                                    color: MasarColors.lightBlue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    skill.toString(),
                                    style: const TextStyle(
                                      color: MasarColors.primaryBlue,
=======
                                    color: UniColors.lightBlue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: UniText(
                                    skill.toString(),
                                    style: TextStyle(
                                      color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
<<<<<<< HEAD
                    _sectionTitle(
                      'الشهادات',
                      Icons.workspace_premium_outlined,
                    ),
=======
                    _sectionTitle('الشهادات', Icons.workspace_premium_outlined),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    const SizedBox(height: 12),
                    _sectionContainer(
                      children: [
                        ...(student['certificates'] as List).map(
                          (certificate) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 19,
<<<<<<< HEAD
                                  color: MasarColors.primaryGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  certificate.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: MasarColors.textPrimary,
=======
                                  color: UniColors.primaryGreen,
                                ),
                                const SizedBox(width: 10),
                                UniText(
                                  certificate.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _sectionTitle('المشاريع', Icons.code_rounded),
                    const SizedBox(height: 12),
                    _sectionContainer(
                      children: [
                        ...(student['projects'] as List).map(
                          (project) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.folder_rounded,
                                  size: 19,
<<<<<<< HEAD
                                  color: MasarColors.primaryBlue,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  project.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: MasarColors.textPrimary,
=======
                                  color: UniColors.primaryBlue,
                                ),
                                const SizedBox(width: 10),
                                UniText(
                                  project.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
<<<<<<< HEAD
        Icon(icon, size: 19, color: MasarColors.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: MasarColors.textPrimary,
=======
        Icon(icon, size: 19, color: UniColors.primaryBlue),
        const SizedBox(width: 8),
        UniText(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ],
    );
  }

  Widget _sectionContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _detailItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        Icon(icon, size: 18, color: MasarColors.textSecondary),
=======
        Icon(icon, size: 18, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: MasarColors.textPrimary,
=======
              UniText(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  color: UniColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              UniText(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isActive
<<<<<<< HEAD
            ? MasarColors.lightGreen
            : MasarColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? MasarColors.primaryGreen : MasarColors.error,
=======
            ? UniColors.lightGreen
            : UniColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
        status,
        style: TextStyle(
          color: isActive ? UniColors.primaryGreen : UniColors.error,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _trainingBadge(String status) {
    late Color color;
    late Color background;

    switch (status) {
      case 'مكتمل':
<<<<<<< HEAD
        color = MasarColors.primaryGreen;
        background = MasarColors.lightGreen;
        break;
      case 'متأخر':
        color = MasarColors.error;
        background = MasarColors.error.withOpacity(0.08);
        break;
      case 'مستمر':
        color = MasarColors.primaryBlue;
        background = MasarColors.lightBlue;
        break;
      case 'لم يبدأ':
      default:
        color = MasarColors.textSecondary;
        background = MasarColors.background;
=======
        color = UniColors.primaryGreen;
        background = UniColors.lightGreen;
        break;
      case 'متأخر':
        color = UniColors.error;
        background = UniColors.error.withOpacity(0.08);
        break;
      case 'مستمر':
        color = UniColors.primaryBlue;
        background = UniColors.lightBlue;
        break;
      case 'لم يبدأ':
      default:
        color = UniColors.textSecondary;
        background = UniColors.background;
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
<<<<<<< HEAD
      child: Text(
=======
      child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
          color: MasarColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: MasarColors.border),
=======
          color: UniColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
              child: Icon(icon, color: color, size: 23),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: MasarColors.textSecondary,
=======
                  UniText(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: UniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  UniText(
                    value,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: UniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  UniText(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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

<<<<<<< HEAD
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MasarColors.border),
=======
    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: UniColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UniColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 42,
              color: UniColors.textSecondary,
            ),
            const SizedBox(height: 12),
            UniText(
              students.isEmpty
                  ? 'لا يوجد طلاب مسجلون حاليًا'
                  : 'لا توجد نتائج تطابق البحث أو الفلاتر',
              style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: UniColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 54,
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 75,
                  columnSpacing: 30,
                  headingRowColor: MaterialStateProperty.all(
<<<<<<< HEAD
                    MasarColors.background,
                  ),
                  columns: const [
                    DataColumn(label: Text('الطالب')),
                    DataColumn(label: Text('الرقم الجامعي')),
                    DataColumn(label: Text('التخصص')),
                    DataColumn(label: Text('المسار المهني')),
                    DataColumn(label: Text('حالة التدريب')),
                    DataColumn(label: Text('ساعات التدريب')),
                    DataColumn(label: Text('حالة الحساب')),
                    DataColumn(label: Text('التفاصيل')),
=======
                    UniColors.background,
                  ),
                  columns: const [
                    DataColumn(label: UniText('الطالب')),
                    DataColumn(label: UniText('الرقم الجامعي')),
                    DataColumn(label: UniText('التخصص')),
                    DataColumn(label: UniText('المسار المهني')),
                    DataColumn(label: UniText('حالة التدريب')),
                    DataColumn(label: UniText('ساعات التدريب')),
                    DataColumn(label: UniText('حالة الحساب')),
                    DataColumn(label: UniText('التفاصيل')),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ],
                  rows: data.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
<<<<<<< HEAD
                                  color: MasarColors.lightBlue,
=======
                                  color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 19,
<<<<<<< HEAD
                                  color: MasarColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                student['name'].toString(),
                                style: const TextStyle(
=======
                                  color: UniColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              UniText(
                                student['name'].toString(),
                                style: TextStyle(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
<<<<<<< HEAD
                        DataCell(Text(student['id'].toString())),
                        DataCell(Text(student['major'].toString())),
                        DataCell(Text(student['careerPath'].toString())),
=======
                        DataCell(UniText(student['id'].toString())),
                        DataCell(UniText(student['major'].toString())),
                        DataCell(UniText(student['careerPath'].toString())),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        DataCell(
                          _trainingBadge(student['trainingStatus'].toString()),
                        ),
                        DataCell(
<<<<<<< HEAD
                          Text(
                            student['hours'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
=======
                          UniText(
                            student['hours'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w700),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                        ),
                        DataCell(
                          _accountBadge(student['accountStatus'].toString()),
                        ),
                        DataCell(
                          IconButton(
<<<<<<< HEAD
                            tooltip: 'عرض التفاصيل',
                            onPressed: () => showStudentDetails(student),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: MasarColors.primaryBlue,
=======
                            tooltip: UniLocalizations.translate('عرض التفاصيل'),
                            onPressed: () => showStudentDetails(student),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: MasarColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
<<<<<<< HEAD
          hint: Text(hint),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12.5),
              ),
=======
          hint: UniText(hint),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: UniText(item, style: TextStyle(fontSize: 12.5)),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final totalStudents = students.length;

    final activeStudents = students
        .where((student) => student['accountStatus'] == 'نشط')
        .length;

    final trainingStudents = students
        .where((student) => student['trainingStatus'] == 'مستمر')
        .length;

    final completedStudents = students
        .where((student) => student['trainingStatus'] == 'مكتمل')
        .length;

    return Container(
      color: MasarColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 25, 30, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الطلاب',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: MasarColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'إدارة ومتابعة بيانات الطلاب وحالة التدريب',
              style: TextStyle(
                fontSize: 13,
                color: MasarColors.textSecondary,
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
                  MasarColors.primaryBlue,
                  MasarColors.lightBlue,
                ),
                const SizedBox(width: 16),
                _statCard(
                  'الحسابات النشطة',
                  '$activeStudents',
                  'حساب نشط',
                  Icons.verified_user_rounded,
                  MasarColors.primaryGreen,
                  MasarColors.lightGreen,
                ),
                const SizedBox(width: 16),
                _statCard(
                  'في التدريب',
                  '$trainingStudents',
                  'طالب',
                  Icons.school_rounded,
                  MasarColors.warning,
                  MasarColors.warning.withOpacity(0.10),
                ),
                const SizedBox(width: 16),
                _statCard(
                  'التدريب المكتمل',
                  '$completedStudents',
                  'طالب',
                  Icons.check_circle_rounded,
                  MasarColors.primaryGreen,
                  MasarColors.lightGreen,
                ),
              ],
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: MasarColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: MasarColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText:
                            'ابحث باسم الطالب، الرقم الجامعي، التخصص أو المسار...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: MasarColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  _filterDropdown(
                    value: selectedMajor,
                    items: const [
                      'الكل',
                      'هندسة البرمجيات',
                      'علوم الحاسوب',
                      'الأمن السيبراني',
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedMajor = value);
                    },
                    hint: 'التخصص',
                  ),
                  const SizedBox(width: 12),
                  _filterDropdown(
                    value: selectedTrainingStatus,
                    items: const [
                      'الكل',
                      'مستمر',
                      'مكتمل',
                      'متأخر',
                      'لم يبدأ',
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedTrainingStatus = value);
                    },
                    hint: 'حالة التدريب',
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
                    fontWeight: FontWeight.w800,
                    color: MasarColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MasarColors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${filteredStudents.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: MasarColors.primaryBlue,
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
=======
    final totalStudents = _getNumber('totalStudents');
    final activeStudents = _getNumber('activeStudents');
    final trainingStudents = _getNumber('trainingStudents');
    final completedStudents = _getNumber('completedStudents');

    return Container(
      color: UniColors.background,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: UniColors.primaryBlue),
            )
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: UniColors.error,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  UniText(
                    errorMessage!,
                    style: TextStyle(
                      color: UniColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loadStudents,
                    child: const UniText('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UniText(
                    'الطلاب',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: UniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  UniText(
                    'إدارة ومتابعة بيانات الطلاب وحالة التدريب',
                    style: TextStyle(
                      fontSize: 13,
                      color: UniColors.textSecondary,
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
                        UniColors.primaryBlue,
                        UniColors.lightBlue,
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        'الحسابات النشطة',
                        '$activeStudents',
                        'حساب نشط',
                        Icons.verified_user_rounded,
                        UniColors.primaryGreen,
                        UniColors.lightGreen,
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        'في التدريب',
                        '$trainingStudents',
                        'طالب',
                        Icons.school_rounded,
                        UniColors.warning,
                        UniColors.warning.withOpacity(0.10),
                      ),
                      const SizedBox(width: 16),
                      _statCard(
                        'التدريب المكتمل',
                        '$completedStudents',
                        'طالب',
                        Icons.check_circle_rounded,
                        UniColors.primaryGreen,
                        UniColors.lightGreen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: UniColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: UniColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: UniLocalizations.translate(
                                'ابحث باسم الطالب، الرقم الجامعي، التخصص أو المسار...',
                              ),
                              prefixIcon: const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: UniColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        _filterDropdown(
                          value: selectedMajor,
                          items: majorOptions,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => selectedMajor = value);
                          },
                          hint: 'التخصص',
                        ),
                        const SizedBox(width: 12),
                        _filterDropdown(
                          value: selectedTrainingStatus,
                          items: const [
                            'الكل',
                            'مستمر',
                            'مكتمل',
                            'متأخر',
                            'لم يبدأ',
                            'ملغي',
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => selectedTrainingStatus = value);
                          },
                          hint: 'حالة التدريب',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      UniText(
                        'قائمة الطلاب',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: UniColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: UniColors.lightBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: UniText(
                          '${filteredStudents.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: UniColors.primaryBlue,
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    );
  }
}
