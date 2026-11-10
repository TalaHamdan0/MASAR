import 'package:flutter/material.dart';

enum NotificationFilter { all, unread, read }

class CompanyNotificationsScreen extends StatefulWidget {
  const CompanyNotificationsScreen({super.key});

  @override
  State<CompanyNotificationsScreen> createState() =>
      _CompanyNotificationsScreenState();
}

class _CompanyNotificationsScreenState
    extends State<CompanyNotificationsScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;
  bool _isLoadingMore = false;
  bool _hasLoadedMore = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تقديم جديد: الطالب أحمد خالد',
      'subtitle': 'قدم على فرصة (التصميم)',
      'time': 'منذ دقائق',
      'tag': 'Match Found',
      'isRead': false,
    },
    {
      'title': 'تقديم جديد: الطالبة سارة الخالدي',
      'subtitle': 'قدمت على (علوم البيانات)',
      'time': 'منذ 5 دقائق',
      'tag': 'Interview Update',
      'isRead': false,
    },
    {
      'title': 'تقديم جديد لفرصة تطوير البرمجيات',
      'subtitle': 'نورة خالد',
      'time': 'منذ 10 دقائق',
      'tag': 'New Applicant',
      'isRead': true,
    },
    {
      'title': 'مطابقة ذكية: 5 مرشحين جدد',
      'subtitle': 'مرشحون يطابقون متطلبات فرصة (مهندس شبكات)',
      'time': 'منذ 45 دقيقة',
      'tag': 'Match Found',
      'isRead': false,
    },
    {
      'title': 'مطابقة ذكية: 5 مرشحين جدد',
      'subtitle': 'يطابقون فرصة (تطوير البرمجيات)',
      'time': 'منذ ساعة',
      'tag': 'Interview Update',
      'isRead': true,
    },
    {
      'title': 'قبول العرض الوظيفي',
      'subtitle': 'رغد علي وافقت على العرض المقدم لفرصة (تحليل البيانات)',
      'time': 'منذ ساعة',
      'tag': 'Status Update',
      'isRead': false,
    },
    {
      'title': 'تقديم جديد لفرصة إدارة المشاريع',
      'subtitle': 'عمر التميمي قدم على فرصة (منسق مشاريع IT)',
      'time': 'منذ ساعتين',
      'tag': 'New Applicant',
      'isRead': true,
    },
    {
      'title': 'انسحاب متقدم من الفرصة',
      'subtitle': 'فيصل العتيبي انسحب من فرصة (تحليل البيانات)',
      'time': 'منذ يوم',
      'tag': 'Status Update',
      'isRead': true,
    },
  ];

  // الإشعارات الجديدة المراد إضافتها مرتبة زمنياً
  final List<Map<String, dynamic>> _newNotifications = [
    {
      'title': 'تقرير أسبوعي جديد',
      'subtitle':
          'قام الطالب أحمد محمد برفع التقرير الأسبوعي الثالث لفرصة (تطوير البرمجيات)',
      'time': 'منذ 10 دقائق',
      'tag': 'Report Update',
      'isRead': false,
    },
    {
      'title': 'تذكير بالتقييم',
      'subtitle':
          'يرجى تقييم أداء الطالبة نورة خالد للأسبوع الحالي في فرصة (إدارة المشاريع)',
      'time': 'منذ ساعة',
      'tag': 'Evaluation',
      'isRead': false,
    },
    {
      'title': 'مستند جديد',
      'subtitle':
          'أرفق الطالب عبدالله فيصل ملف (التقرير النهائي) لفرصة (هندسة شبكات)',
      'time': 'منذ 3 ساعات',
      'tag': 'Document Update',
      'isRead': true,
    },
    {
      'title': 'تنبيه انتهاء التدريب',
      'subtitle':
          'ينتهي تدريب الطالبة رغد علي في فرصة (تحليل البيانات) خلال 5 أيام',
      'time': 'منذ يوم',
      'tag': 'Status Update',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_selectedFilter) {
      case NotificationFilter.unread:
        return _notifications.where((n) => n['isRead'] == false).toList();
      case NotificationFilter.read:
        return _notifications.where((n) => n['isRead'] == true).toList();
      case NotificationFilter.all:
      default:
        return _notifications;
    }
  }

  // محاكاة دالة التحميل
  Future<void> _loadMoreNotifications() async {
    if (_hasLoadedMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // محاكاة الاتصال بالشبكة

    setState(() {
      _notifications.addAll(_newNotifications);
      _isLoadingMore = false;
      _hasLoadedMore = true;
    });
  }

  Color _getTagBgColor(String tag) {
    switch (tag) {
      case 'New Applicant':
        return const Color(0xFFE8F5E9);
      case 'Match Found':
        return const Color(0xFFE3F2FD);
      case 'Report Update':
      case 'Document Update':
        return const Color(0xFFFFF3E0); // أورانج فاتح للتقارير
      case 'Evaluation':
        return const Color(0xFFF3E5F5); // بنفسجي فاتح للتقييم
      case 'Interview Update':
      case 'Status Update':
      default:
        return const Color(0xFFE0F7FA);
    }
  }

  Color _getTagTextColor(String tag) {
    switch (tag) {
      case 'New Applicant':
        return const Color(0xFF2E7D32);
      case 'Match Found':
        return const Color(0xFF1565C0);
      case 'Report Update':
      case 'Document Update':
        return const Color(0xFFE65100);
      case 'Evaluation':
        return const Color(0xFF7B1FA2);
      case 'Interview Update':
      case 'Status Update':
      default:
        return const Color(0xFF00838F);
    }
  }

  IconData _getNotificationIcon(String tag) {
    switch (tag) {
      case 'New Applicant':
        return Icons.person_outline;
      case 'Match Found':
        return Icons.work_outline;
      case 'Report Update':
        return Icons.assignment_outlined;
      case 'Document Update':
        return Icons.insert_drive_file_outlined;
      case 'Evaluation':
        return Icons.star_outline;
      case 'Interview Update':
      case 'Status Update':
      default:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredNotifications;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E3A8A),
          title: const Text(
            'الإشعارات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Column(
          children: [
            // شريط الفلترة
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _buildFilterChip('الكل', NotificationFilter.all),
                  const SizedBox(width: 8),
                  _buildFilterChip('غير المقروءة', NotificationFilter.unread),
                  const SizedBox(width: 8),
                  _buildFilterChip('المقروءة', NotificationFilter.read),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

            // قائمة الإشعارات + زر التحميل في الأسفل
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد إشعارات حالياً',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount:
                          filteredList.length +
                          1, // +1 من أجل ودجت التحميل السفلي
                      separatorBuilder: (context, index) {
                        if (index == filteredList.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return const Divider(
                          height: 1,
                          thickness: 0.8,
                          color: Color(0xFFE5E7EB),
                        );
                      },
                      itemBuilder: (context, index) {
                        // كرت تحميل المزيد في نهاية القائمة
                        if (index == filteredList.length) {
                          return _buildLoadMoreWidget();
                        }

                        final item = filteredList[index];
                        final bool isUnread = !(item['isRead'] as bool);
                        final String tag = item['tag'] as String;

                        return Container(
                          color: isUnread
                              ? const Color(0xFFF0F9FF)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.more_horiz,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _getTagBgColor(tag),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        _getNotificationIcon(tag),
                                        color: _getTagTextColor(tag),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] as String,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13.5,
                                              fontWeight: isUnread
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                              color: const Color(0xFF1F2937),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 12,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['time'] as String,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 10.5,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTagBgColor(tag),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _getTagTextColor(
                                          tag,
                                        ).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _getTagTextColor(tag),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isUnread
                                          ? const Color(0xFF2563EB)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت منطقة التحميل أسفل الصفحة
  Widget _buildLoadMoreWidget() {
    if (_hasLoadedMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'تم عرض جميع الإشعارات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _isLoadingMore
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF1E3A8A),
                ),
              )
            : TextButton.icon(
                onPressed: _loadMoreNotifications,
                icon: const Icon(
                  Icons.arrow_downward_rounded,
                  size: 18,
                  color: Color(0xFF1E3A8A),
                ),
                label: const Text(
                  'تحميل المزيد من الإشعارات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  backgroundColor: const Color(0xFFEFF6FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
      ),
    );
  }

  // ودجت أزرار الفلترة
  Widget _buildFilterChip(String label, NotificationFilter filter) {
    final bool isSelected = _selectedFilter == filter;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF1E3A8A),
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: const Color(0xFFF1F5F9),
      showCheckmark: false,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        }
      },
    );
  }
}
