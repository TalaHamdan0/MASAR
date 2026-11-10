import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../theme/masar_theme.dart';
import '../../core/services/training_service.dart';
import 'selection_success_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
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
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // =========================
                  // الهيدر + زر الرجوع
                  // =========================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(selectedIndex: 2),
      ),
    );
  }

  // =========================
  // شريط الفلترة
  // =========================
  Widget _buildFilterTabs() {
    final filters = ['الكل', 'قيد المراجعة', 'مقبول', 'مرفوض'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((filter) {
          final bool isSelected = selectedFilter == filter;

          return InkWell(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? MasarColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : MasarColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================
  // كرت الطلب الحقيقي
  // =========================
  Widget _buildApplicationCard(TrainingApplication app) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MasarColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
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
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.opportunityTitle ?? 'فرصة تدريب',
                            style: const TextStyle(
                              fontSize: 12,
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectionSuccessScreen(
                        selectedCompany: {
                          'name': app.companyName,
                          'role': app.opportunityTitle,
                        },
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: MasarColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: MasarColors.lightBlue,
                ),
                child: const Text(
                  'اختيار هذا التدريب',
                  style: TextStyle(
                    color: MasarColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (app.status.contains('مرفوض'))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'تم رفض طلبك.',
                    style: TextStyle(
                      color: Color(0xFFE53E3E),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'يمكنك التقديم على فرص أخرى.',
                    style: TextStyle(color: Color(0xFFE53E3E), fontSize: 11),
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
  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFFFF9E6);
    Color text = const Color(0xFFD97706);
    IconData icon = Icons.access_time_rounded;

    if (status.contains('مقبول')) {
      bg = const Color(0xFFE6F4EA);
      text = const Color(0xFF1E8E3E);
      icon = Icons.check_circle_rounded;
    } else if (status.contains('مرفوض')) {
      bg = const Color(0xFFFCE8E6);
      text = const Color(0xFFD93025);
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: text),
        ],
      ),
    );
  }

  // =========================
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
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'سيتم إشعارك عند وجود أي تحديث على طلباتك.',
              style: TextStyle(
                fontSize: 12,
                color: MasarColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
