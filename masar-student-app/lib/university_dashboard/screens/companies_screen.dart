<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
=======
import 'package:flutter/material.dart';

import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_companies_service.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedField = 'الكل';
  String selectedStatus = 'الكل';

<<<<<<< HEAD
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
      'traineeList': ['تالا حمدان', 'محمد يوسف', 'سارة خالد'],
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
      'traineeList': ['ليان أحمد', 'نور علي'],
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
      'traineeList': ['رنا سمير', 'أحمد محمد', 'عمر فهد'],
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
      'traineeList': ['محمد يوسف', 'خالد أحمد'],
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
      'traineeList': ['نور علي', 'سارة خالد'],
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
      'description': 'شركة تعمل في تطوير مواقع الويب والمنصات الرقمية.',
      'opportunityList': [
        'Frontend Developer Intern',
        'Backend Developer Intern',
      ],
      'traineeList': ['أحمد محمد'],
    },
  ];
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCompanies {
    final query = searchController.text.trim().toLowerCase();

    return companies.where((company) {
<<<<<<< HEAD
      final matchesSearch = query.isEmpty ||
=======
      final matchesSearch =
          query.isEmpty ||
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              Text(
=======
              UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                'إدارة الشركات',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
<<<<<<< HEAD
                  color: MasarColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'إدارة الجهات التدريبية ومتابعة الشركات المسجلة في المنصة',
                style: TextStyle(
                  fontSize: 13,
                  color: MasarColors.textSecondary,
                ),
=======
                  color: UniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              UniText(
                'إدارة الجهات التدريبية ومتابعة الشركات المسجلة في المنصة',
                style: TextStyle(fontSize: 13, color: UniColors.textSecondary),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                          '72',
                          'شركة',
                          Icons.business_center_rounded,
                          MasarColors.primaryGreen,
                          MasarColors.lightGreen,
=======
                          _getNumber('availableCompanies').toString(),
                          'شركة',
                          Icons.business_center_rounded,
                          UniColors.primaryGreen,
                          UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'الشركات النشطة',
<<<<<<< HEAD
                          '72',
                          'شركة',
                          Icons.business_rounded,
                          MasarColors.primaryBlue,
                          MasarColors.lightBlue,
=======
                          _getNumber('activeCompanies').toString(),
                          'شركة',
                          Icons.business_rounded,
                          UniColors.primaryBlue,
                          UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'إجمالي الفرص',
<<<<<<< HEAD
                          '143',
                          'فرصة تدريب',
                          Icons.work_rounded,
                          MasarColors.primaryBlue,
                          MasarColors.lightBlue,
=======
                          _getNumber('totalOffers').toString(),
                          'فرصة تدريب',
                          Icons.work_rounded,
                          UniColors.primaryBlue,
                          UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'الطلاب المتدربون',
<<<<<<< HEAD
                          '386',
                          'طالب',
                          Icons.people_alt_rounded,
                          MasarColors.primaryGreen,
                          MasarColors.lightGreen,
=======
                          _getNumber('trainees').toString(),
                          'طالب',
                          Icons.people_alt_rounded,
                          UniColors.primaryGreen,
                          UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                  color: MasarColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MasarColors.border),
=======
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 750;

                    final search = TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
<<<<<<< HEAD
                        hintText: 'ابحث باسم الشركة أو المجال أو الموقع...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: MasarColors.background,
=======
                        hintText: UniLocalizations.translate(
                          'ابحث باسم الشركة أو المجال أو الموقع...',
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                        labelText: 'المجال',
                        filled: true,
                        fillColor: MasarColors.background,
=======
                        labelText: UniLocalizations.translate('المجال'),
                        filled: true,
                        fillColor: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
<<<<<<< HEAD
                      items: const [
                        DropdownMenuItem(
                          value: 'الكل',
                          child: Text('كل المجالات'),
                        ),
                        DropdownMenuItem(
                          value: 'تحليل البيانات',
                          child: Text('تحليل البيانات'),
                        ),
                        DropdownMenuItem(
                          value: 'التصميم',
                          child: Text('التصميم'),
                        ),
                        DropdownMenuItem(
                          value: 'تطوير البرمجيات',
                          child: Text('تطوير البرمجيات'),
                        ),
                        DropdownMenuItem(
                          value: 'الأمن السيبراني',
                          child: Text('الأمن السيبراني'),
                        ),
                        DropdownMenuItem(
                          value: 'ضمان الجودة',
                          child: Text('ضمان الجودة'),
                        ),
                        DropdownMenuItem(
                          value: 'تطوير الويب',
                          child: Text('تطوير الويب'),
                        ),
                      ],
=======
                      items: fieldOptions.map((field) {
                        return DropdownMenuItem<String>(
                          value: field,
                          child: UniText(
                            field == 'الكل' ? 'كل المجالات' : field,
                          ),
                        );
                      }).toList(),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      onChanged: (value) {
                        setState(() => selectedField = value ?? 'الكل');
                      },
                    );

                    final statusDropdown = DropdownButtonFormField<String>(
                      value: selectedStatus,
                      isExpanded: true,
                      decoration: InputDecoration(
<<<<<<< HEAD
                        labelText: 'حالة الشركة',
                        filled: true,
                        fillColor: MasarColors.background,
=======
                        labelText: UniLocalizations.translate('حالة الشركة'),
                        filled: true,
                        fillColor: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'الكل',
<<<<<<< HEAD
                          child: Text('كل الحالات'),
                        ),
                        DropdownMenuItem(
                          value: 'نشطة',
                          child: Text('نشطة'),
                        ),
                        DropdownMenuItem(
                          value: 'متوقفة مؤقتًا',
                          child: Text('متوقفة مؤقتًا'),
=======
                          child: UniText('كل الحالات'),
                        ),
                        DropdownMenuItem(value: 'نشطة', child: UniText('نشطة')),
                        DropdownMenuItem(
                          value: 'متوقفة مؤقتًا',
                          child: UniText('متوقفة مؤقتًا'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                  color: MasarColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MasarColors.border),
=======
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
<<<<<<< HEAD
                          child: Text(
=======
                          child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            'الشركات المتاحة للتدريب',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
<<<<<<< HEAD
                              color: MasarColors.textPrimary,
=======
                              color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
<<<<<<< HEAD
                            color: MasarColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
=======
                            color: UniColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            '${displayedCompanies.length}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
<<<<<<< HEAD
                              color: MasarColors.primaryGreen,
=======
                              color: UniColors.primaryGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
<<<<<<< HEAD
                    if (displayedCompanies.isEmpty)
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 42,
<<<<<<< HEAD
                                color: MasarColors.textSecondary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'لا توجد شركات مطابقة للبحث',
                                style: TextStyle(
                                  color: MasarColors.textSecondary,
=======
                                color: UniColors.textSecondary,
                              ),
                              const SizedBox(height: 10),
                              UniText(
                                'لا توجد شركات مطابقة للبحث',
                                style: TextStyle(
                                  color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                                child: const Text('إعادة ضبط الفلاتر'),
=======
                                child: const UniText('إعادة ضبط الفلاتر'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                                headingRowColor:
                                    WidgetStateProperty.all(
                                  MasarColors.background,
=======
                                headingRowColor: WidgetStateProperty.all(
                                  UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                ),
                                columnSpacing: 24,
                                horizontalMargin: 12,
                                columns: const [
<<<<<<< HEAD
                                  DataColumn(label: Text('الشركة')),
                                  DataColumn(label: Text('التدريب المتوفر')),
                                  DataColumn(label: Text('الموقع')),
                                  DataColumn(label: Text('المتدربون')),
                                  DataColumn(label: Text('الحالة')),
                                  DataColumn(label: Text('التفاصيل')),
=======
                                  DataColumn(label: UniText('الشركة')),
                                  DataColumn(label: UniText('التدريب المتوفر')),
                                  DataColumn(label: UniText('الموقع')),
                                  DataColumn(label: UniText('المتدربون')),
                                  DataColumn(label: UniText('الحالة')),
                                  DataColumn(label: UniText('التفاصيل')),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                                                color: MasarColors.lightBlue,
=======
                                                color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: Icon(
                                                Icons.business_rounded,
                                                size: 19,
<<<<<<< HEAD
                                                color:
                                                    MasarColors.primaryBlue,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            Text(
                                              company['name'].toString(),
                                              style: const TextStyle(
=======
                                                color: UniColors.primaryBlue,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            UniText(
                                              company['name'].toString(),
                                              style: TextStyle(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 250,
<<<<<<< HEAD
                                          child: Text(
=======
                                          child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                            opportunities.join('، '),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.5,
<<<<<<< HEAD
                                              color: MasarColors.textPrimary,
=======
                                              color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                                              color:
                                                  MasarColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(company['location'].toString()),
=======
                                              color: UniColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            UniText(
                                              company['location'].toString(),
                                            ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                          ],
                                        ),
                                      ),
                                      DataCell(
<<<<<<< HEAD
                                        Text(
                                          '${company['trainees']}',
                                          style: const TextStyle(
=======
                                        UniText(
                                          '${company['trainees']}',
                                          style: TextStyle(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                                          tooltip: 'عرض التفاصيل',
=======
                                          tooltip: UniLocalizations.translate(
                                            'عرض التفاصيل',
                                          ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                          onPressed: () =>
                                              showCompanyDetails(company),
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
<<<<<<< HEAD
                                            color: MasarColors.primaryBlue,
=======
                                            color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
          textDirection: TextDirection.rtl,
=======
          textDirection: Directionality.of(context),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          child: AlertDialog(
            title: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
<<<<<<< HEAD
                    color: MasarColors.lightBlue,
=======
                    color: UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.business_rounded,
<<<<<<< HEAD
                    color: MasarColors.primaryBlue,
=======
                    color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
<<<<<<< HEAD
                  child: Text(
=======
                  child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    company['name'].toString(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
<<<<<<< HEAD
                      color: MasarColors.textPrimary,
=======
                      color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                    Text(
=======
                    UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      'نبذة عن الشركة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
<<<<<<< HEAD
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
=======
                        color: UniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      company['description'].toString(),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.6,
<<<<<<< HEAD
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
=======
                        color: UniColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      'التدريبات المتوفرة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
<<<<<<< HEAD
                        color: MasarColors.textPrimary,
=======
                        color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                          color: MasarColors.background,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: MasarColors.border),
=======
                          color: UniColors.background,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 19,
<<<<<<< HEAD
                              color: MasarColors.primaryBlue,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
=======
                              color: UniColors.primaryBlue,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                                opportunity.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
<<<<<<< HEAD
                                  color: MasarColors.textPrimary,
=======
                                  color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                            MasarColors.primaryBlue,
                            MasarColors.lightBlue,
=======
                            UniColors.primaryBlue,
                            UniColors.lightBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoBox(
                            'المتدربون',
                            '${company['trainees']}',
                            Icons.people_alt_rounded,
<<<<<<< HEAD
                            MasarColors.primaryGreen,
                            MasarColors.lightGreen,
=======
                            UniColors.primaryGreen,
                            UniColors.lightGreen,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
<<<<<<< HEAD
                    Text(
=======
                    UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      'الطلاب المتدربون',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
<<<<<<< HEAD
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            color: MasarColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            trainee.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: MasarColors.primaryGreen,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
<<<<<<< HEAD
                child: const Text('إغلاق'),
=======
                child: const UniText('إغلاق'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
              color: MasarColors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: MasarColors.primaryBlue,
            ),
=======
              color: UniColors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: UniColors.primaryBlue),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 115,
<<<<<<< HEAD
            child: Text(
=======
            child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              '$title:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
<<<<<<< HEAD
                color: MasarColors.textSecondary,
=======
                color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ),
          ),
          Expanded(
<<<<<<< HEAD
            child: Text(
=======
            child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
<<<<<<< HEAD
                color: MasarColors.textPrimary,
=======
                color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
=======
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
<<<<<<< HEAD
                    color: MasarColors.textPrimary,
=======
                    color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
        color: MasarColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MasarColors.border),
=======
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MasarColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
=======
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: UniColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
<<<<<<< HEAD
                    color: MasarColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: MasarColors.textSecondary,
=======
                    color: UniColors.textPrimary,
                  ),
                ),
                UniText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
            ? MasarColors.lightGreen
            : MasarColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
=======
            ? UniColors.lightGreen
            : UniColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        status,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
<<<<<<< HEAD
          color: active ? MasarColors.primaryGreen : MasarColors.warning,
=======
          color: active ? UniColors.primaryGreen : UniColors.warning,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ),
      ),
    );
  }
}
