import 'package:flutter/material.dart';

<<<<<<< HEAD
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../theme/masar_theme.dart';
import '../../core/services/training_service.dart';
=======
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
import 'selection_success_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
<<<<<<< HEAD
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  String selectedFilter = 'الكل';
  bool _isLoading = true;
  List<TrainingApplication> _applications = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  // جلب الطلبات الحقيقية من الـ Backend عبر الـ Service
  Future<void> _fetchApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final applications = await TrainingService.getStudentApplications();
      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e
            .toString()
            .replaceFirst('Exception: ', '')
            .replaceAll('ApiException: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // فلترة الطلبات بناءً على الحالة المحددة
    final filteredList = _applications.where((app) {
      if (selectedFilter == 'الكل') {
        return true;
      }
      if (selectedFilter == 'مقبول') {
        return app.status.contains('مقبول');
      }
      if (selectedFilter == 'مرفوض') {
        return app.status.contains('مرفوض');
      }
      if (selectedFilter == 'قيد المراجعة') {
        return app.status.contains('قيد المراجعة');
      }
      return app.status == selectedFilter;
=======
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
      'hours': '280 ساعة',
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
      'hours': '280 ساعة',
      'date': '2026/09/05',
      'status': 'مقبول',
      'icon': Icons.all_inclusive,
      'iconColor': const Color(0xFF0081FB),
      'bgColor': Colors.white,
    },
    {
      'name': 'Orange',
      'role': 'Software Engineer Intern',
      'location': 'عمان',
      'duration': '3 أشهر',
      'hours': '280 ساعة',
      'date': '2026/08/28',
      'status': 'مرفوض',
      'icon': Icons.square,
      'iconColor': const Color(0xFFFF6600),
      'bgColor': const Color(0xFFFF6600),
    },
    {
      'name': 'Zain',
      'role': 'Marketing Intern',
      'location': 'عمان',
      'duration': '3 أشهر',
      'hours': '280 ساعة',
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
<<<<<<< HEAD
              constraints: const BoxConstraints(maxWidth: 480),
=======
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // =========================
                  // الهيدر + زر الرجوع
                  // =========================
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
=======

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
                                color: MasarColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
<<<<<<< HEAD
=======

                        // يحافظ على العنوان بالنص
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =========================
                  // شريط الفلترة
                  // =========================
<<<<<<< HEAD
=======

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  _buildFilterTabs(),

                  const SizedBox(height: 16),

                  // =========================
<<<<<<< HEAD
                  // قائمة الطلبات (حسب الحالة: تحميل، خطأ، فارغ، أو بيانات)
                  // =========================
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: MasarColors.primaryBlue,
                            ),
                          )
                        : _errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _fetchApplications,
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filteredList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open_rounded,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'لا توجد طلبات تدريب مطابقة.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchApplications,
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
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ),
                ],
              ),
            ),
          ),
        ),
<<<<<<< HEAD
        bottomNavigationBar: const AppBottomNavBar(selectedIndex: 2),
=======

        // =========================
        // Navbar
        // =========================

        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 2,
        ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
    );
  }

  // =========================
  // شريط الفلترة
  // =========================
<<<<<<< HEAD
  Widget _buildFilterTabs() {
    final filters = ['الكل', 'قيد المراجعة', 'مقبول', 'مرفوض'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((filter) {
          final bool isSelected = selectedFilter == filter;
=======

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

          return InkWell(
            onTap: () {
              setState(() {
<<<<<<< HEAD
                selectedFilter = filter;
=======
                if (filter == 'المقبولة') {
                  selectedFilter = 'مقبول';
                } else if (filter == 'المرفوضة') {
                  selectedFilter = 'مرفوض';
                } else {
                  selectedFilter = filter;
                }
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
<<<<<<< HEAD
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? MasarColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(10),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : MasarColors.textSecondary,
=======
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : MasarColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================
<<<<<<< HEAD
  // كرت الطلب الحقيقي
  // =========================
  Widget _buildApplicationCard(TrainingApplication app) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
<<<<<<< HEAD
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
=======
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // =========================
                    // شعار الشركة
                    // =========================

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
<<<<<<< HEAD
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MasarColors.border),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.business_rounded,
                          color: MasarColors.primaryBlue,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.companyName ?? 'شركة تدريب',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MasarColors.textPrimary,
=======
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

                    // =========================
                    // معلومات الشركة
                    // =========================

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
<<<<<<< HEAD
                            app.opportunityTitle ?? 'فرصة تدريب',
                            style: const TextStyle(
                              fontSize: 12,
                              color: MasarColors.textSecondary,
=======
                            app['role'] ?? '',
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: MasarColors
                                  .textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            ),
                          ),
                        ],
                      ),
                    ),
<<<<<<< HEAD
                    _buildStatusBadge(app.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تاريخ التقديم: ${app.appliedDate != null ? app.appliedDate!.substring(0, 10) : 'غير متوفر'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (app.status.contains('مقبول'))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: MasarColors.border)),
=======

                    // =========================
                    // حالة الطلب
                    // =========================

                    _buildStatusBadge(
                      app['status'],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =========================
                // تفاصيل التدريب
                // =========================

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
<<<<<<< HEAD
                      builder: (context) => SelectionSuccessScreen(
                        selectedCompany: {
                          'name': app.companyName,
                          'role': app.opportunityTitle,
                        },
=======
                      builder: (context) =>
                          SelectionSuccessScreen(
                        selectedCompany: app,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      ),
                    ),
                  );
                },
<<<<<<< HEAD
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: MasarColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: MasarColors.lightBlue,
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
                child: const Text(
                  'اختيار هذا التدريب',
                  style: TextStyle(
<<<<<<< HEAD
                    color: MasarColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
=======
                    color:
                        MasarColors.primaryBlue,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ),
                ),
              ),
            ),
<<<<<<< HEAD
          if (app.status.contains('مرفوض'))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
=======

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'تم رفض طلبك.',
                    style: TextStyle(
<<<<<<< HEAD
                      color: Color(0xFFE53E3E),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
=======
                      color:
                          Color(0xFFE53E3E),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'يمكنك التقديم على فرص أخرى.',
<<<<<<< HEAD
                    style: TextStyle(color: Color(0xFFE53E3E), fontSize: 11),
=======
                    style: TextStyle(
                      color:
                          Color(0xFFE53E3E),
                      fontSize: 11,
                    ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFFFF9E6);
    Color text = const Color(0xFFD97706);
    IconData icon = Icons.access_time_rounded;

    if (status.contains('مقبول')) {
      bg = const Color(0xFFE6F4EA);
      text = const Color(0xFF1E8E3E);
      icon = Icons.check_circle_rounded;
    } else if (status.contains('مرفوض')) {
=======

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
      bg = const Color(0xFFFCE8E6);
      text = const Color(0xFFD93025);
      icon = Icons.cancel_rounded;
    }

    return Container(
<<<<<<< HEAD
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
=======
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
<<<<<<< HEAD
              fontWeight: FontWeight.bold,
=======
              fontWeight:
                  FontWeight.bold,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              color: text,
            ),
          ),
          const SizedBox(width: 4),
<<<<<<< HEAD
          Icon(icon, size: 14, color: text),
=======
          Icon(
            icon,
            size: 14,
            color: text,
          ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        ],
      ),
    );
  }

  // =========================
<<<<<<< HEAD
  // صندوق التنبيه
  // =========================
  Widget _buildInfoNoteBox() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MasarColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, color: MasarColors.primaryBlue, size: 20),
=======
  // شعارات الشركات
  // =========================

  Widget _buildCustomCompanyLogo(
    Map<String, dynamic> company,
  ) {
    // =========================
    // Zain
    // =========================

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

    // =========================
    // Microsoft
    // =========================

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

    // =========================
    // Amazon
    // =========================

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

    // =========================
    // Arab Bank
    // =========================

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

    // =========================
    // الشركات الأخرى
    // =========================

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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'سيتم إشعارك عند وجود أي تحديث على طلباتك.',
              style: TextStyle(
                fontSize: 12,
<<<<<<< HEAD
                color: MasarColors.primaryBlue,
                fontWeight: FontWeight.w500,
=======
                color:
                    MasarColors.primaryBlue,
                fontWeight:
                    FontWeight.w500,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              ),
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< HEAD
=======

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

    const gradient = SweepGradient(
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
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
