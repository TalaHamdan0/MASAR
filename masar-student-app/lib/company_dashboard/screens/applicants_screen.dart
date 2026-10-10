import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({super.key});

  static final List<Applicant> sharedApplicants = [
    Applicant(
      id: 1,
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      specialization: 'علوم الحاسوب',
      opportunity: 'تطوير البرمجيات',
      date: '2026/05/10',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 2,
      name: 'نورة خالد',
      email: 'nora@example.com',
      specialization: 'هندسة برمجيات',
      opportunity: 'تطوير البرمجيات',
      date: '2026/05/09',
      status: ApplicantStatus.interview,
    ),
    Applicant(
      id: 3,
      name: 'عبدالله فيصل',
      email: 'abdullah@example.com',
      specialization: 'إدارة أعمال',
      opportunity: 'التسويق',
      date: '2026/05/08',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 4,
      name: 'عمر التميمي',
      email: 'omar@example.com',
      specialization: 'هندسة الشبكات',
      opportunity: 'شبكات',
      date: '2026/05/07',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 5,
      name: 'أحمد خالد',
      email: 'ahmed.khaled@example.com',
      specialization: 'علوم البيانات',
      opportunity: 'تحليل البيانات',
      date: '2026/05/06',
      status: ApplicantStatus.interview,
    ),
    Applicant(
      id: 6,
      name: 'سارة محمود',
      email: 'sara@example.com',
      specialization: 'علم الحاسوب',
      opportunity: 'تطوير برمجيات ',
      date: '2026/05/05',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 7,
      name: 'خالد العتيبي',
      email: 'khalid@example.com',
      specialization: 'هندسة البرمجيات',
      opportunity: 'تطوير البرمجيات',
      date: '2026/05/04',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 8,
      name: 'ريم عبدالله',
      email: 'reem@example.com',
      specialization: 'علوم الحاسوب',
      opportunity: 'تطوير البرمجيات',
      date: '2026/05/03',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 9,
      name: 'محمد سامي',
      email: 'mohammed@example.com',
      specialization: 'إدارةأعمال',
      opportunity: 'إدارة المشاريع',
      date: '2026/05/02',
      status: ApplicantStatus.interview,
    ),
    Applicant(
      id: 10,
      name: 'ليان أحمد',
      email: 'layan@example.com',
      specialization: 'علوم البيانات',
      opportunity: 'تحليل البيانات',
      date: '2026/05/01',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 11,
      name: 'يوسف أحمد',
      email: 'yousef@example.com',
      specialization: 'هندسة شبكات',
      opportunity: 'شبكات',
      date: '2026/04/30',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 12,
      name: 'جنى محمد',
      email: 'jana@example.com',
      specialization: 'التسويق',
      opportunity: 'التسويق',
      date: '2026/04/29',
      status: ApplicantStatus.rejected,
    ),
    Applicant(
      id: 13,
      name: 'رائد حسن',
      email: 'raed@example.com',
      specialization: 'علوم الحاسوب',
      opportunity: 'تطوير البرمجيات',
      date: '2026/04/28',
      status: ApplicantStatus.interview,
    ),
    Applicant(
      id: 14,
      name: 'نور خالد',
      email: 'noor@example.com',
      specialization: 'علوم البيانات',
      opportunity: 'تحليل البيانات',
      date: '2026/04/27',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 15,
      name: 'مازن علي',
      email: 'mazen@example.com',
      specialization: 'هندسة برمجيات',
      opportunity: 'تطوير البرمجيات',
      date: '2026/04/26',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 16,
      name: 'سلمى أحمد',
      email: 'salma@example.com',
      specialization: 'إدارة أعمال',
      opportunity: 'إدارة المشاريع',
      date: '2026/04/25',
      status: ApplicantStatus.accepted,
    ),
    Applicant(
      id: 17,
      name: 'فهد محمد',
      email: 'fahad@example.com',
      specialization: 'هندسة الشبكات',
      opportunity: 'شبكات',
      date: '2026/04/24',
      status: ApplicantStatus.rejected,
    ),
    Applicant(
      id: 18,
      name: 'شهد عبدالله',
      email: 'shahad@example.com',
      specialization: 'التسويق',
      opportunity: 'التسويق',
      date: '2026/04/23',
      status: ApplicantStatus.interview,
    ),
    Applicant(
      id: 19,
      name: 'إياد خالد',
      email: 'eyad@example.com',
      specialization: 'علوم الحاسوب',
      opportunity: 'تطوير البرمجيات',
      date: '2026/04/22',
      status: ApplicantStatus.review,
    ),
    Applicant(
      id: 20,
      name: 'ملك سامر',
      email: 'malak@example.com',
      specialization: 'علوم البيانات',
      opportunity: 'تحليل البيانات',
      date: '2026/04/21',
      status: ApplicantStatus.accepted,
    ),
  ];

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  // ============================================================
  // الإعدادات
  // ============================================================

  static const int rowsPerPage = 10;

  int currentPage = 1;

  String searchQuery = '';
  String selectedPeriod = 'آخر فترة زمنية';
  String selectedOpportunity = 'جميع الفرص التدريبية';
  String selectedSpecialization = 'جميع التخصصات';
  String selectedStatus = 'الكل';

  final TextEditingController searchController = TextEditingController();

  // ============================================================
  // البيانات
  // ============================================================

  List<Applicant> get applicants => ApplicantsScreen.sharedApplicants;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // تنظيف البحث
  // ============================================================

  String _normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================================
  // الفلترة والبحث
  // ============================================================

  List<Applicant> get filteredApplicants {
    List<Applicant> result = List<Applicant>.from(applicants);

    // البحث
    final query = _normalizeText(searchQuery);

    if (query.isNotEmpty) {
      result = result.where((applicant) {
        final name = _normalizeText(applicant.name);
        final email = _normalizeText(applicant.email);
        final specialization = _normalizeText(applicant.specialization);
        final opportunity = _normalizeText(applicant.opportunity);
        final id = applicant.id.toString();

        return name.contains(query) ||
            email.contains(query) ||
            specialization.contains(query) ||
            opportunity.contains(query) ||
            id.contains(query);
      }).toList();
    }

    // الفرصة التدريبية
    if (selectedOpportunity != 'جميع الفرص التدريبية') {
      result = result.where((applicant) {
        return applicant.opportunity == selectedOpportunity;
      }).toList();
    }

    // التخصص
    if (selectedSpecialization != 'جميع التخصصات') {
      result = result.where((applicant) {
        return applicant.specialization == selectedSpecialization;
      }).toList();
    }

    // الحالة
    if (selectedStatus != 'الكل') {
      result = result.where((applicant) {
        return getStatusText(applicant.status) == selectedStatus;
      }).toList();
    }

    return result;
  }

  int get totalPages {
    final total = filteredApplicants.length;

    if (total == 0) {
      return 1;
    }

    return (total / rowsPerPage).ceil();
  }

  List<Applicant> get currentApplicants {
    final data = filteredApplicants;

    final start = (currentPage - 1) * rowsPerPage;

    if (start >= data.length) {
      return [];
    }

    final end = (start + rowsPerPage > data.length)
        ? data.length
        : start + rowsPerPage;

    return data.sublist(start, end);
  }

  // ============================================================
  // البحث
  // ============================================================

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      currentPage = 1;
    });
  }

  void _clearSearch() {
    searchController.clear();

    setState(() {
      searchQuery = '';
      currentPage = 1;
    });
  }

  // ============================================================
  // العودة
  // ============================================================

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // تصدير التقرير
  // ============================================================

  void exportReport() {
    final data = filteredApplicants;

    final buffer = StringBuffer();

    buffer.writeln(
      'الطالب,البريد الإلكتروني,التخصص,الفرصة التدريبية,تاريخ التقديم,الحالة',
    );

    for (final applicant in data) {
      buffer.writeln(
        '${_csv(applicant.name)},'
        '${_csv(applicant.email)},'
        '${_csv(applicant.specialization)},'
        '${_csv(applicant.opportunity)},'
        '${_csv(applicant.date)},'
        '${_csv(getStatusText(applicant.status))}',
      );
    }

    final bytes = utf8.encode('\uFEFF$buffer');

    final blob = html.Blob([bytes], 'text/csv;charset=utf-8');

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'تقرير_المتقدمين.csv')
      ..click();

    html.Url.revokeObjectUrl(url);

    _showMessage('تم تنزيل تقرير المتقدمين بنجاح');
  }

  String _csv(String value) {
    return '"${value.replaceAll('"', '""')}"';
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: const Color(0xFFF6F8FC),
        child: Container(
          color: const Color(0xFFF6F8FC),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatistics(),
                const SizedBox(height: 24),
                _buildFilters(),
                const SizedBox(height: 18),
                _buildTable(),
                const SizedBox(height: 16),
                _buildPagination(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: const Color(0xFFF6F8FC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // زر الرجوع على الجهة اليسرى
          InkWell(
            onTap: _goBack,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.chevron_left,
                size: 30,
                color: Color(0xFF111928),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // العنوان والعنوان الفرعي على الجهة اليسرى
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'إدارة المتقدمين',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17243A),
                  height: 1.2,
                ),
              ),

              SizedBox(height: 4),

              Text(
                'متابعة وإدارة جميع طلبات المتقدمين للفرص التدريبية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8A99AD),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // ============================================================
  // Statistics
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            number: '248',
            title: 'إجمالي المتقدمين',
            icon: Icons.groups_rounded,
            iconColor: const Color(0xFF0D6EFD),
            iconBackground: const Color(0xFFE8F1FF),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(
            number: '98',
            title: 'قيد المراجعة',
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFFFFA000),
            iconBackground: const Color(0xFFFFF2D9),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(
            number: '45',
            title: 'في المقابلة',
            icon: Icons.groups_rounded,
            iconColor: const Color(0xFF0D6EFD),
            iconBackground: const Color(0xFFE8F1FF),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(
            number: '30',
            title: 'مقبول',
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF16A765),
            iconBackground: const Color(0xFFE2F7EE),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _statCard(
            number: '75',
            title: 'مرفوض',
            icon: Icons.cancel_rounded,
            iconColor: const Color(0xFFF04444),
            iconBackground: const Color(0xFFFFE5E5),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String number,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE1E8F2),
        ), // لون الحدود المطابق لكود التقييمات
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // الرقم بالخط والألوان المطابقة لشاشة التقييمات
              Text(
                number,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17243A), // لون النصوص الداكن في التقييمات
                ),
              ),
              const SizedBox(height: 2),
              // العنوان الفرعي بالخط والألوان المطابقة
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF596579), // لون النصوص الفرعية في التقييمات
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // ============================================================
  // Filters
  // ============================================================

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex: 2, child: _searchField()),
          const SizedBox(width: 12),
          Expanded(
            child: _filterDropdown(
              label: 'الفترة الزمنية',
              value: selectedPeriod,
              items: const [
                'آخر فترة زمنية',
                'آخر أسبوع',
                'آخر شهر',
                'آخر 3 أشهر',
                'آخر 6 أشهر',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedPeriod = value;
                  currentPage = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _filterDropdown(
              label: 'الفرصة التدريبية',
              value: selectedOpportunity,
              items: const [
                'جميع الفرص التدريبية',
                'تطوير البرمجيات',
                'التسويق',
                'شبكات',
                'تحليل البيانات',
                'إدارة المشاريع',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedOpportunity = value;
                  currentPage = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _filterDropdown(
              label: 'التخصص',
              value: selectedSpecialization,
              items: const [
                'جميع التخصصات',
                'علوم الحاسوب',
                'هندسة برمجيات',
                'إدارة أعمال',
                'هندسة الشبكات',
                'هندسة شبكات',
                'علوم البيانات',
                'التسويق',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedSpecialization = value;
                  currentPage = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _filterDropdown(
              label: 'الحالة',
              value: selectedStatus,
              items: const [
                'الكل',
                'قيد المراجعة',
                'في المقابلة',
                'مقبول',
                'مرفوض',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedStatus = value;
                  currentPage = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 49,
            child: ElevatedButton.icon(
              onPressed: exportReport,
              icon: const Icon(Icons.download_rounded, size: 20),
              label: const Text(
                'تصدير التقرير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Search
  // ============================================================

  Widget _searchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'البحث',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6D82A1),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 49,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFD6E2F2)),
          ),
          child: TextField(
            controller: searchController,
            textDirection: TextDirection.rtl,
            onChanged: _onSearchChanged,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: Color(0xFF173B73),
            ),
            decoration: InputDecoration(
              hintText: 'ابحث عن طالب...',
              hintStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xFF91A2BA),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF173B73),
                size: 22,
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      tooltip: 'مسح البحث',
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF91A2BA),
                        size: 19,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Dropdown
  // ============================================================

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6D82A1),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFD6E2F2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF173B73),
              ),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF173B73),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Color(0xFF173B73),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Table
  // ============================================================

  Widget _buildTable() {
    final data = currentApplicants;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            _tableHeader(),

            if (data.isEmpty)
              _emptyState()
            else
              ...data.map((applicant) => _buildTableRow(applicant)),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const SizedBox(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 45, color: Color(0xFF9AABC0)),
            SizedBox(height: 10),
            Text(
              'لا توجد نتائج مطابقة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF617693),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'جرّب البحث باسم آخر أو غيّر الفلاتر',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xFF91A2BA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFFF0F5FB),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _HeaderCell('الطالب')),
          Expanded(flex: 2, child: _HeaderCell('التخصص')),
          Expanded(flex: 2, child: _HeaderCell('الفرصة التدريبية')),
          Expanded(flex: 2, child: _HeaderCell('تاريخ التقديم')),
          Expanded(flex: 2, child: _HeaderCell('الحالة')),
          Expanded(flex: 2, child: _HeaderCell('إجراءات')),
        ],
      ),
    );
  }

  Widget _buildTableRow(Applicant applicant) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EEF6))),
      ),
      child: Row(
        children: [
          // الطالب
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F1FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF0D6EFD),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF173B73),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        applicant.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: Color(0xFF8497B2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // التخصص
          Expanded(
            flex: 2,
            child: Text(
              applicant.specialization,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xFF405978),
              ),
            ),
          ),

          // الفرصة
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(
                  Icons.business_center_outlined,
                  color: Color(0xFF0D6EFD),
                  size: 18,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    applicant.opportunity,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Color(0xFF405978),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // التاريخ
          Expanded(
            flex: 2,
            child: Text(
              applicant.date,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xFF405978),
              ),
            ),
          ),

          // الحالة
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: _statusBadge(applicant.status),
            ),
          ),

          // الإجراءات
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _actionButton(
                  icon: Icons.more_horiz_rounded,
                  tooltip: 'المزيد',
                  onPressed: () {
                    _showMoreOptions(applicant);
                  },
                ),
                const SizedBox(width: 7),
                _actionButton(
                  icon: Icons.visibility_outlined,
                  tooltip: 'عرض بيانات الطالب',
                  onPressed: () {
                    _openApplicantDetails(applicant);
                  },
                ),
                const SizedBox(width: 7),
                _actionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'تعديل الطالب',
                  onPressed: () {
                    _openEditApplicant(applicant);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Action Button
  // ============================================================

  Widget _actionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFD8E5F5)),
          ),
          child: Icon(icon, color: const Color(0xFF0D6EFD), size: 19),
        ),
      ),
    );
  }

  // ============================================================
  // Status
  // ============================================================

  Widget _statusBadge(ApplicantStatus status) {
    Color background;
    Color foreground;
    IconData icon;
    String text;

    switch (status) {
      case ApplicantStatus.review:
        background = const Color(0xFFFFF1D9);
        foreground = const Color(0xFFFFA000);
        icon = Icons.access_time_rounded;
        text = 'قيد المراجعة';
        break;

      case ApplicantStatus.interview:
        background = const Color(0xFFE8F1FF);
        foreground = const Color(0xFF0D6EFD);
        icon = Icons.groups_rounded;
        text = 'في المقابلة';
        break;

      case ApplicantStatus.accepted:
        background = const Color(0xFFE1F7ED);
        foreground = const Color(0xFF16A765);
        icon = Icons.check_circle_rounded;
        text = 'مقبول';
        break;

      case ApplicantStatus.rejected:
        background = const Color(0xFFFFE4E4);
        foreground = const Color(0xFFF04444);
        icon = Icons.cancel_rounded;
        text = 'مرفوض';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 15),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Pagination
  // ============================================================

  Widget _buildPagination() {
    final total = filteredApplicants.length;

    final start = total == 0 ? 0 : ((currentPage - 1) * rowsPerPage) + 1;

    final end = total == 0
        ? 0
        : ((currentPage * rowsPerPage) > total
              ? total
              : currentPage * rowsPerPage);

    return Row(
      children: [
        Text(
          'عرض $start-$end من $total متقدم',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: Color(0xFF7186A2),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),

        // السابق
        _pageButton(
          icon: Icons.chevron_right_rounded,
          enabled: currentPage > 1,
          onPressed: currentPage > 1
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),

        const SizedBox(width: 7),

        ..._buildPageNumbers(),

        const SizedBox(width: 7),

        // التالي
        _pageButton(
          icon: Icons.chevron_left_rounded,
          enabled: currentPage < totalPages,
          onPressed: currentPage < totalPages
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<int> pages = [];

    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      if (currentPage <= 3) {
        pages.addAll([1, 2, 3, 4, 5]);
      } else if (currentPage >= totalPages - 2) {
        pages.addAll([
          totalPages - 4,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ]);
      } else {
        pages.addAll([
          currentPage - 2,
          currentPage - 1,
          currentPage,
          currentPage + 1,
          currentPage + 2,
        ]);
      }
    }

    return pages.map((page) {
      final selected = page == currentPage;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () {
            setState(() {
              currentPage = page;
            });
          },
          borderRadius: BorderRadius.circular(9),
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0D6EFD) : Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: selected
                    ? const Color(0xFF0D6EFD)
                    : const Color(0xFFD8E5F5),
              ),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : const Color(0xFF355579),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _pageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFD8E5F5)),
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF31567F) : const Color(0xFFB5C0CD),
        ),
      ),
    );
  }

  // ============================================================
  // Details
  // ============================================================

  void _openApplicantDetails(Applicant applicant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ApplicantDetailsScreen(applicant: applicant),
      ),
    );
  }

  // ============================================================
  // Edit
  // ============================================================

  void _openEditApplicant(Applicant applicant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditApplicantScreen(applicant: applicant),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // ============================================================
  // More
  // ============================================================

  void _showMoreOptions(Applicant applicant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5DEE9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    applicant.name,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF173B73),
                    ),
                  ),
                  const SizedBox(height: 18),

                  _moreOption(
                    icon: Icons.visibility_outlined,
                    title: 'عرض بيانات الطالب',
                    onTap: () {
                      Navigator.pop(context);
                      _openApplicantDetails(applicant);
                    },
                  ),

                  _moreOption(
                    icon: Icons.edit_outlined,
                    title: 'تعديل بيانات الطالب',
                    onTap: () {
                      Navigator.pop(context);
                      _openEditApplicant(applicant);
                    },
                  ),

                  _moreOption(
                    icon: Icons.email_outlined,
                    title: 'إرسال رسالة للطالب',
                    onTap: () {
                      Navigator.pop(context);
                      _showMessage(
                        'سيتم فتح إرسال رسالة إلى ${applicant.name}',
                      );
                    },
                  ),

                  _moreOption(
                    icon: Icons.calendar_month_outlined,
                    title: 'جدولة مقابلة',
                    onTap: () {
                      Navigator.pop(context);
                      _showMessage('تم تجهيز جدولة مقابلة للطالب');
                    },
                  ),

                  _moreOption(
                    icon: Icons.download_outlined,
                    title: 'تحميل بيانات الطالب',
                    onTap: () {
                      Navigator.pop(context);
                      _downloadApplicant(applicant);
                    },
                  ),

                  _moreOption(
                    icon: Icons.delete_outline_rounded,
                    title: 'حذف الطلب',
                    danger: true,
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDelete(applicant);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _moreOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        margin: const EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(
          color: danger ? const Color(0xFFFFF1F1) : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: danger ? const Color(0xFFF04444) : const Color(0xFF0D6EFD),
              size: 21,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: danger
                    ? const Color(0xFFF04444)
                    : const Color(0xFF304C70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Download Applicant
  // ============================================================

  void _downloadApplicant(Applicant applicant) {
    final content =
        '''
الاسم: ${applicant.name}
البريد الإلكتروني: ${applicant.email}
التخصص: ${applicant.specialization}
الفرصة التدريبية: ${applicant.opportunity}
تاريخ التقديم: ${applicant.date}
الحالة: ${getStatusText(applicant.status)}
''';

    final bytes = utf8.encode('\uFEFF$content');

    final blob = html.Blob([bytes], 'text/plain;charset=utf-8');

    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', '${applicant.name}_بيانات.txt')
      ..click();

    html.Url.revokeObjectUrl(url);

    _showMessage('تم تنزيل بيانات الطالب');
  }

  // ============================================================
  // Delete
  // ============================================================

  void _confirmDelete(Applicant applicant) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'حذف الطلب',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              'هل أنت متأكد من حذف طلب ${applicant.name}؟',
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  setState(() {
                    applicants.removeWhere((item) => item.id == applicant.id);

                    if (currentPage > totalPages) {
                      currentPage = totalPages;
                    }
                  });

                  _showMessage('تم حذف الطلب');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF04444),
                  foregroundColor: Colors.white,
                ),
                child: const Text('حذف', style: TextStyle(fontFamily: 'Cairo')),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // Message
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
      ),
    );
  }
}

// ==================================================================
// شاشة تفاصيل الطالب
// ==================================================================

class ApplicantDetailsScreen extends StatelessWidget {
  final Applicant applicant;

  const ApplicantDetailsScreen({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF173B73),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'بيانات الطالب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF173B73),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFDCE7F5)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F1FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF0D6EFD),
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      applicant.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF173B73),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      applicant.email,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Color(0xFF8295AF),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _detailRow('التخصص', applicant.specialization),
                    _detailRow('الفرصة التدريبية', applicant.opportunity),
                    _detailRow('تاريخ التقديم', applicant.date),
                    _detailRow('الحالة', getStatusText(applicant.status)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.school_outlined,
                      title: 'المؤهل العلمي',
                      value: 'بكالوريوس',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.work_outline_rounded,
                      title: 'الخبرة',
                      value: 'سنتان',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.location_on_outlined,
                      title: 'الموقع',
                      value: 'عمّان',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EEF6))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A8DA8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF173B73),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D6EFD), size: 26),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: Color(0xFF8295AF),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF173B73),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// شاشة تعديل الطالب
// ==================================================================

class EditApplicantScreen extends StatefulWidget {
  final Applicant applicant;

  const EditApplicantScreen({super.key, required this.applicant});

  @override
  State<EditApplicantScreen> createState() => _EditApplicantScreenState();
}

class _EditApplicantScreenState extends State<EditApplicantScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  late String specialization;
  late String opportunity;
  late ApplicantStatus status;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.applicant.name);

    emailController = TextEditingController(text: widget.applicant.email);

    specialization = widget.applicant.specialization;
    opportunity = widget.applicant.opportunity;
    status = widget.applicant.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى تعبئة اسم الطالب والبريد الإلكتروني',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }

    widget.applicant.name = name;
    widget.applicant.email = email;
    widget.applicant.specialization = specialization;
    widget.applicant.opportunity = opportunity;
    widget.applicant.status = status;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF173B73),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'تعديل بيانات الطالب',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF173B73),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFDCE7F5)),
                    ),
                    child: Column(
                      children: [
                        _input(label: 'اسم الطالب', controller: nameController),
                        const SizedBox(height: 18),
                        _input(
                          label: 'البريد الإلكتروني',
                          controller: emailController,
                        ),
                        const SizedBox(height: 18),
                        _dropdown(
                          label: 'التخصص',
                          value: specialization,
                          items: const [
                            'علوم الحاسوب',
                            'هندسة برمجيات',
                            'إدارة أعمال',
                            'هندسة الشبكات',
                            'هندسة شبكات',
                            'علوم البيانات',
                            'التسويق',
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              specialization = value;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        _dropdown(
                          label: 'الفرصة التدريبية',
                          value: opportunity,
                          items: const [
                            'تطوير البرمجيات',
                            'التسويق',
                            'شبكات',
                            'تحليل البيانات',
                            'إدارة المشاريع',
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              opportunity = value;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        _dropdown(
                          label: 'الحالة',
                          value: getStatusText(status),
                          items: const [
                            'قيد المراجعة',
                            'في المقابلة',
                            'مقبول',
                            'مرفوض',
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              status = getStatusFromText(value);
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  side: const BorderSide(
                                    color: Color(0xFFD6E2F2),
                                  ),
                                ),
                                child: const Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xFF516984),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D6EFD),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(52),
                                ),
                                child: const Text(
                                  'حفظ التعديلات',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF526A87),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Color(0xFF173B73),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FBFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFDCE7F5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFFDCE7F5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF526A87),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFD),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFDCE7F5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================================================================
// Model
// ==================================================================

enum ApplicantStatus { review, interview, accepted, rejected }

class Applicant {
  final int id;

  String name;
  String email;
  String specialization;
  String opportunity;
  String date;
  ApplicantStatus status;

  Applicant({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.opportunity,
    required this.date,
    required this.status,
  });
}

// ==================================================================
// Helpers
// ==================================================================

String getStatusText(ApplicantStatus status) {
  switch (status) {
    case ApplicantStatus.review:
      return 'قيد المراجعة';

    case ApplicantStatus.interview:
      return 'في المقابلة';

    case ApplicantStatus.accepted:
      return 'مقبول';

    case ApplicantStatus.rejected:
      return 'مرفوض';
  }
}

ApplicantStatus getStatusFromText(String text) {
  switch (text) {
    case 'في المقابلة':
      return ApplicantStatus.interview;

    case 'مقبول':
      return ApplicantStatus.accepted;

    case 'مرفوض':
      return ApplicantStatus.rejected;

    default:
      return ApplicantStatus.review;
  }
}

// ==================================================================
// Header Cell
// ==================================================================

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Color(0xFF173B73),
      ),
    );
  }
}
