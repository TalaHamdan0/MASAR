import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_auth_service.dart';
import '../../core/services/university_students_service.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedMajor = 'الكل';
  String selectedTrainingStatus = 'الكل';

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

      final matchesMajor =
          selectedMajor == 'الكل' || student['major'] == selectedMajor;

      final matchesTraining =
          selectedTrainingStatus == 'الكل' ||
          student['trainingStatus'] == selectedTrainingStatus;

      return matchesSearch && matchesMajor && matchesTraining;
    }).toList();
  }

  void showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 720,
              constraints: const BoxConstraints(maxHeight: 760),
              decoration: BoxDecoration(
                color: UniColors.white,
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
                            color: UniColors.lightBlue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: UniColors.primaryBlue,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    color: UniColors.lightBlue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: UniText(
                                    skill.toString(),
                                    style: TextStyle(
                                      color: UniColors.primaryBlue,
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
                    _sectionTitle('الشهادات', Icons.workspace_premium_outlined),
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
                                  color: UniColors.primaryGreen,
                                ),
                                const SizedBox(width: 10),
                                UniText(
                                  certificate.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: UniColors.textPrimary,
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
                                  color: UniColors.primaryBlue,
                                ),
                                const SizedBox(width: 10),
                                UniText(
                                  project.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: UniColors.textPrimary,
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
        Icon(icon, size: 19, color: UniColors.primaryBlue),
        const SizedBox(width: 8),
        UniText(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: UniColors.textPrimary,
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
        color: UniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UniColors.border),
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
        Icon(icon, size: 18, color: UniColors.textSecondary),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ? UniColors.lightGreen
            : UniColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
        status,
        style: TextStyle(
          color: isActive ? UniColors.primaryGreen : UniColors.error,
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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
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
          color: UniColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: UniColors.border),
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
                                  color: UniColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 19,
                                  color: UniColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              UniText(
                                student['name'].toString(),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(UniText(student['id'].toString())),
                        DataCell(UniText(student['major'].toString())),
                        DataCell(UniText(student['careerPath'].toString())),
                        DataCell(
                          _trainingBadge(student['trainingStatus'].toString()),
                        ),
                        DataCell(
                          UniText(
                            student['hours'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(
                          _accountBadge(student['accountStatus'].toString()),
                        ),
                        DataCell(
                          IconButton(
                            tooltip: UniLocalizations.translate('عرض التفاصيل'),
                            onPressed: () => showStudentDetails(student),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: UniColors.primaryBlue,
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
        color: UniColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: UniColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: UniText(hint),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: UniText(item, style: TextStyle(fontSize: 12.5)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
