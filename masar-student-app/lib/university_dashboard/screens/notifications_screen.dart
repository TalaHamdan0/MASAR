
import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';
import '../../core/widgets/uni_dashboard_sidebar.dart';
import '../../core/widgets/uni_dashboard_header.dart';

import 'university_home_screen.dart';
import 'students_screen.dart';
import 'companies_screen.dart';
import 'applications_screen.dart';
import 'current_trainings_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'university_login_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // الإشعارات = index 6
  int selectedIndex = 6;

  String selectedFilter = 'الكل';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'طلب تدريب جديد',
      'message':
          'قام أحمد محمد علي بالتقديم على فرصة تدريب مطور Flutter.',
      'time': 'منذ 15 دقيقة',
      'type': 'application',
      'read': false,
    },
    {
      'title': 'تقرير يحتاج إلى مراجعة',
      'message':
          'تم رفع تقرير تدريبي جديد من الطالب محمد يوسف.',
      'time': 'منذ 45 دقيقة',
      'type': 'report',
      'read': false,
    },
    {
      'title': 'طالب قريب من إكمال التدريب',
      'message':
          'رنا سمير أكملت 245 ساعة من أصل 280 ساعة تدريبية.',
      'time': 'منذ ساعتين',
      'type': 'training',
      'read': false,
    },
    {
      'title': 'فرصة تدريب جديدة',
      'message':
          'تمت إضافة فرصة تدريب جديدة من شركة التقنية المتقدمة.',
      'time': 'اليوم، 10:30 ص',
      'type': 'opportunity',
      'read': true,
    },
    {
      'title': 'إكمال تدريب',
      'message':
          'أكمل الطالب نور علي جميع الساعات المطلوبة للتدريب.',
      'time': 'أمس، 04:20 م',
      'type': 'completed',
      'read': true,
    },
    {
      'title': 'طلب تدريب جديد',
      'message':
          'قامت ليان أحمد بالتقديم على فرصة UI/UX Designer.',
      'time': 'أمس، 12:10 م',
      'type': 'application',
      'read': true,
    },
    {
      'title': 'تقرير يحتاج إلى مراجعة',
      'message':
          'تم رفع تقرير أسبوعي جديد من الطالب تالا حمدان.',
      'time': 'قبل يومين',
      'type': 'report',
      'read': true,
    },
    {
      'title': 'تحديث حالة التدريب',
      'message':
          'تم تحديث حالة تدريب محمد يوسف إلى "متأخر".',
      'time': 'قبل 3 أيام',
      'type': 'training',
      'read': true,
    },
  ];

  int get unreadCount =>
      notifications.where((item) => item['read'] == false).length;

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'غير مقروءة') {
      return notifications
          .where((item) => item['read'] == false)
          .toList();
    }

    return notifications;
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
        return;

      case 7:
        screen = const SettingsScreen();
        break;

      default:
        return;
    }

    // توحيد التنقل مع باقي صفحات الـ Dashboard
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  IconData _notificationIcon(String type) {
    switch (type) {
      case 'application':
        return Icons.assignment_outlined;
      case 'report':
        return Icons.description_outlined;
      case 'training':
        return Icons.school_outlined;
      case 'opportunity':
        return Icons.work_outline_rounded;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _notificationColor(String type) {
    switch (type) {
      case 'application':
        return MasarColors.primaryBlue;
      case 'report':
        return MasarColors.warning;
      case 'training':
        return MasarColors.primaryGreen;
      case 'opportunity':
        return MasarColors.primaryBlue;
      case 'completed':
        return MasarColors.primaryGreen;
      default:
        return MasarColors.textSecondary;
    }
  }

  void markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['read'] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showNotificationDetails(
    Map<String, dynamic> notification,
  ) {
    markAsRead(notification);

    final color = _notificationColor(notification['type']);

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.10),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _notificationIcon(
                              notification['type'],
                            ),
                            color: color,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: MasarColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.8,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              MasarColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إغلاق'),
                      ),
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

  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    final bool isRead = notification['read'];
    final color =
        _notificationColor(notification['type']);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        showNotificationDetails(notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isRead
              ? MasarColors.white
              : MasarColors.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead
                ? MasarColors.border
                : MasarColors.primaryBlue
                    .withOpacity(0.18),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _notificationIcon(notification['type']),
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                            color:
                                MasarColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                MasarColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 10.5,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              icon: Icon(
                Icons.more_vert_rounded,
                color: MasarColors.textSecondary,
              ),
              onSelected: (value) {
                if (value == 'read') {
                  markAsRead(notification);
                }
              },
              itemBuilder: (context) => [
                if (!isRead)
                  const PopupMenuItem(
                    value: 'read',
                    child: Text('تحديد كمقروء'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String title) {
    final bool selected = selectedFilter == title;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? MasarColors.primaryBlue
              : MasarColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? MasarColors.primaryBlue
                : MasarColors.border,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected
                ? Colors.white
                : MasarColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text(
              'هل أنت متأكد أنك تريد تسجيل الخروج من لوحة الجامعة؟',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      MasarColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const UniversityLoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MasarColors.background,
        body: Row(
          // مهم جداً: هذا يثبت ترتيب الـ Row
          // بحيث يبقى السايد بار على اليمين.
          textDirection: TextDirection.ltr,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const UniDashboardHeader(
                      title: 'الإشعارات',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          24,
                          28,
                          35,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الإشعارات',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.w800,
                                        color: MasarColors
                                            .textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'تابع آخر المستجدات والإجراءات المطلوبة',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: MasarColors
                                            .textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (unreadCount > 0)
                                  TextButton.icon(
                                    onPressed:
                                        markAllAsRead,
                                    icon: const Icon(
                                      Icons.done_all_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'تحديد الكل كمقروء',
                                    ),
                                    style:
                                        TextButton.styleFrom(
                                      foregroundColor:
                                          MasarColors
                                              .primaryBlue,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color:
                                    MasarColors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                border: Border.all(
                                  color:
                                      MasarColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration:
                                        BoxDecoration(
                                      color: MasarColors
                                          .lightBlue,
                                      borderRadius:
                                          BorderRadius.circular(
                                              14),
                                    ),
                                    child: Icon(
                                      Icons
                                          .notifications_active_outlined,
                                      color: MasarColors
                                          .primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        '$unreadCount إشعارات غير مقروءة',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w800,
                                          color: MasarColors
                                              .textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'تحتاج بعض الإشعارات إلى مراجعة أو إجراء',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: MasarColors
                                              .textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _filterButton('الكل'),
                                const SizedBox(width: 8),
                                _filterButton('غير مقروءة'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            if (filteredNotifications.isEmpty)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 80,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      MasarColors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                          18),
                                  border: Border.all(
                                    color:
                                        MasarColors.border,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons
                                          .notifications_none_rounded,
                                      size: 50,
                                      color: MasarColors
                                          .textSecondary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'لا توجد إشعارات غير مقروءة',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w600,
                                        color: MasarColors
                                            .textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Column(
                                children:
                                    filteredNotifications
                                        .map(
                                          _notificationCard,
                                        )
                                        .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // السايد بار ثابت على اليمين
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
