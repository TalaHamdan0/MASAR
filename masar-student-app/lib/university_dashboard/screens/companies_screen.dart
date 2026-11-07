import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_companies_service.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedField = 'الكل';
  String selectedStatus = 'الكل';

  List<Map<String, dynamic>> companies = [];

  Map<String, dynamic> statistics = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await UniversityCompaniesService.fetchCompanies();

      final companiesData = result['companies'] as List? ?? [];
      final statisticsData = result['statistics'];

      if (!mounted) return;

      setState(() {
        companies = companiesData
            .map((company) => Map<String, dynamic>.from(company as Map))
            .toList();

        statistics = statisticsData is Map
            ? Map<String, dynamic>.from(statisticsData)
            : {};

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  int _getNumber(String key) {
    final value = statistics[key];

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

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
          company['name'].toString().toLowerCase().contains(query) ||
          company['field'].toString().toLowerCase().contains(query) ||
          company['location'].toString().toLowerCase().contains(query);

      final matchesField =
          selectedField == 'الكل' || company['field'] == selectedField;

      final matchesStatus =
          selectedStatus == 'الكل' || company['status'] == selectedStatus;

      return matchesSearch && matchesField && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedCompanies = filteredCompanies;
    final fieldOptions =
        companies
            .map((company) => (company['field'] ?? 'غير محدد').toString())
            .where((field) => field.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    fieldOptions.insert(0, 'الكل');

    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UniText(
                'إدارة الشركات',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: UniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              UniText(
                'إدارة الجهات التدريبية ومتابعة الشركات المسجلة في المنصة',
                style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // إحصائيات الشركات
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 850;
                  final cardWidth = isNarrow
                      ? (constraints.maxWidth - 14) / 2
                      : (constraints.maxWidth - 42) / 4;

                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'الشركات المتاحة للتدريب',
                          _getNumber('availableCompanies').toString(),
                          'شركة',
                          Icons.business_center_rounded,
                          UniColors.primaryGreen,
                          UniColors.lightGreen,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'الشركات النشطة',
                          _getNumber('activeCompanies').toString(),
                          'شركة',
                          Icons.business_rounded,
                          UniColors.primaryBlue,
                          UniColors.lightBlue,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'إجمالي الفرص',
                          _getNumber('totalOffers').toString(),
                          'فرصة تدريب',
                          Icons.work_rounded,
                          UniColors.primaryBlue,
                          UniColors.lightBlue,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'الطلاب المتدربون',
                          _getNumber('trainees').toString(),
                          'طالب',
                          Icons.people_alt_rounded,
                          UniColors.primaryGreen,
                          UniColors.lightGreen,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // البحث والفلاتر
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 750;

                    final search = TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: UniLocalizations.translate(
                          'ابحث باسم الشركة أو المجال أو الموقع...',
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: UniColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );

                    final fieldDropdown = DropdownButtonFormField<String>(
                      value: selectedField,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: UniLocalizations.translate('المجال'),
                        filled: true,
                        fillColor: UniColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: fieldOptions.map((field) {
                        return DropdownMenuItem<String>(
                          value: field,
                          child: UniText(
                            field == 'الكل' ? 'كل المجالات' : field,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedField = value ?? 'الكل');
                      },
                    );

                    final statusDropdown = DropdownButtonFormField<String>(
                      value: selectedStatus,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: UniLocalizations.translate('حالة الشركة'),
                        filled: true,
                        fillColor: UniColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'الكل',
                          child: UniText('كل الحالات'),
                        ),
                        DropdownMenuItem(value: 'نشطة', child: UniText('نشطة')),
                        DropdownMenuItem(
                          value: 'متوقفة مؤقتًا',
                          child: UniText('متوقفة مؤقتًا'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => selectedStatus = value ?? 'الكل');
                      },
                    );

                    if (isNarrow) {
                      return Column(
                        children: [
                          search,
                          const SizedBox(height: 12),
                          fieldDropdown,
                          const SizedBox(height: 12),
                          statusDropdown,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 3, child: search),
                        const SizedBox(width: 12),
                        Expanded(child: fieldDropdown),
                        const SizedBox(width: 12),
                        Expanded(child: statusDropdown),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // جدول الشركات
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: UniText(
                            'الشركات المتاحة للتدريب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: UniColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: UniColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: UniText(
                            '${displayedCompanies.length}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: UniColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(35),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 42,
                                color: UniColors.warning,
                              ),
                              const SizedBox(height: 10),
                              UniText(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: UniColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _loadCompanies,
                                child: const UniText('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (displayedCompanies.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 42,
                                color: UniColors.textSecondary,
                              ),
                              const SizedBox(height: 10),
                              UniText(
                                'لا توجد شركات مطابقة للبحث',
                                style: TextStyle(
                                  color: UniColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    selectedField = 'الكل';
                                    selectedStatus = 'الكل';
                                  });
                                },
                                child: const UniText('إعادة ضبط الفلاتر'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  UniColors.background,
                                ),
                                columnSpacing: 24,
                                horizontalMargin: 12,
                                columns: const [
                                  DataColumn(label: UniText('الشركة')),
                                  DataColumn(label: UniText('التدريب المتوفر')),
                                  DataColumn(label: UniText('الموقع')),
                                  DataColumn(label: UniText('المتدربون')),
                                  DataColumn(label: UniText('الحالة')),
                                  DataColumn(label: UniText('التفاصيل')),
                                ],
                                rows: displayedCompanies.map((company) {
                                  final opportunities =
                                      company['opportunityList'] as List;

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: UniColors.lightBlue,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: Icon(
                                                Icons.business_rounded,
                                                size: 19,
                                                color: UniColors.primaryBlue,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            UniText(
                                              company['name'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 250,
                                          child: UniText(
                                            opportunities.join('، '),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: UniColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: UniColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            UniText(
                                              company['location'].toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        UniText(
                                          '${company['trainees']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        _statusBadge(
                                          company['status'].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          tooltip: UniLocalizations.translate(
                                            'عرض التفاصيل',
                                          ),
                                          onPressed: () =>
                                              showCompanyDetails(company),
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                            color: UniColors.primaryBlue,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCompanyDetails(Map<String, dynamic> company) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final opportunities = company['opportunityList'] as List;
        final trainees = company['traineeList'] as List;

        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: UniColors.lightBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: UniColors.primaryBlue,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: UniText(
                    company['name'].toString(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: UniColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow(
                      'التدريب المتوفر',
                      opportunities.join('، '),
                      Icons.work_outline_rounded,
                    ),
                    _detailRow(
                      'المجال',
                      company['field'].toString(),
                      Icons.category_outlined,
                    ),
                    _detailRow(
                      'الموقع',
                      company['location'].toString(),
                      Icons.location_on_outlined,
                    ),
                    _detailRow(
                      'البريد الإلكتروني',
                      company['email'].toString(),
                      Icons.email_outlined,
                    ),
                    _detailRow(
                      'رقم الهاتف',
                      company['phone'].toString(),
                      Icons.phone_outlined,
                    ),
                    _detailRow(
                      'حالة الشركة',
                      company['status'].toString(),
                      Icons.verified_outlined,
                    ),
                    const SizedBox(height: 8),
                    UniText(
                      'نبذة عن الشركة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: UniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    UniText(
                      company['description'].toString(),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.6,
                        color: UniColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    UniText(
                      'التدريبات المتوفرة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: UniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...opportunities.map(
                      (opportunity) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: UniColors.background,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: UniColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 19,
                              color: UniColors.primaryBlue,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: UniText(
                                opportunity.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: UniColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _infoBox(
                            'التدريبات المتوفرة',
                            '${opportunities.length}',
                            Icons.work_rounded,
                            UniColors.primaryBlue,
                            UniColors.lightBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoBox(
                            'المتدربون',
                            '${company['trainees']}',
                            Icons.people_alt_rounded,
                            UniColors.primaryGreen,
                            UniColors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    UniText(
                      'الطلاب المتدربون',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: UniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (trainees.isEmpty)
                      UniText(
                        'لا يوجد طلاب متدربون حاليًا',
                        style: TextStyle(
                          fontSize: 12,
                          color: UniColors.textSecondary,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: trainees.map((trainee) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: UniColors.lightGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: UniText(
                              trainee.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: UniColors.primaryGreen,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const UniText('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: UniColors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: UniColors.primaryBlue),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 115,
            child: UniText(
              '$title:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: UniColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: UniText(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: UniColors.textPrimary,
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
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                UniText(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
              ],
            ),
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
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                UniText(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
                UniText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final bool active = status == 'نشطة';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? UniColors.lightGreen
            : UniColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
        status,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: active ? UniColors.primaryGreen : UniColors.warning,
        ),
      ),
    );
  }
}
