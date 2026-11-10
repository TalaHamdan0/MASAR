<<<<<<< HEAD

import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
=======
import 'package:flutter/material.dart';


import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_notifications_service.dart';


class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onCountsChanged;

  const NotificationsScreen({super.key, this.onCountsChanged});
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

<<<<<<< HEAD
class _NotificationsScreenState
    extends State<NotificationsScreen> {
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
=======

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'الكل';

  List<Map<String, dynamic>> notifications = [];

  bool isLoading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }


  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result =
          await UniversityNotificationsService.fetchNotifications();

      final notificationsData =
          result['notifications'] as List? ?? [];

      final loadedNotifications = notificationsData.map((item) {
        final notification =
            Map<String, dynamic>.from(item as Map);

        notification['time'] = _formatTime(
          notification['createdAt']?.toString(),
        );

        return notification;
      }).toList();

      if (!mounted) return;

      setState(() {
        notifications = loadedNotifications;
        isLoading = false;
      });
      widget.onCountsChanged?.call();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }


  String _formatTime(String? value) {
    if (value == null || value.isEmpty) {
      return '—';
    }

    final createdAt = DateTime.tryParse(value);

    if (createdAt == null) {
      return '—';
    }

    final difference =
        DateTime.now().difference(createdAt.toLocal());

    if (difference.isNegative || difference.inMinutes < 1) {
      return 'الآن';
    }

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    }

    if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    }

    if (difference.inDays == 1) {
      return 'أمس';
    }

    return 'قبل ${difference.inDays} أيام';
  }


  int get unreadCount =>
      notifications.where((item) => item['read'] != true).length;

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'غير مقروءة') {
      return notifications
<<<<<<< HEAD
          .where((item) => item['read'] == false)
=======
          .where((item) => item['read'] != true)
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          .toList();
    }

    return notifications;
  }

<<<<<<< HEAD
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
      case 'opportunity':
        return MasarColors.primaryBlue;
      case 'report':
        return MasarColors.warning;
      case 'training':
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
=======

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: UniText(message),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

<<<<<<< HEAD
  void showNotificationDetails(
    Map<String, dynamic> notification,
  ) {
    markAsRead(notification);

    final color = _notificationColor(notification['type']);
=======

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
      case 'opportunity':
        return UniColors.primaryBlue;

      case 'report':
        return UniColors.warning;

      case 'training':
      case 'completed':
        return UniColors.primaryGreen;

      default:
        return UniColors.textSecondary;
    }
  }


  Future<void> markAsRead(
    Map<String, dynamic> notification,
  ) async {
    if (notification['read'] == true) {
      return;
    }

    final notificationId =
        notification['id']?.toString();

    if (notificationId == null || notificationId.isEmpty) {
      return;
    }

    try {
      await UniversityNotificationsService.markAsRead(
        notificationId,
      );

      if (!mounted) return;

      setState(() {
        notification['read'] = true;
      });
      widget.onCountsChanged?.call();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'تعذر تحديد الإشعار كمقروء: $e',
      );
    }
  }


  Future<void> markAllAsRead() async {
    if (unreadCount == 0) {
      return;
    }

    try {
      await UniversityNotificationsService.markAllAsRead();

      if (!mounted) return;

      setState(() {
        for (final notification in notifications) {
          notification['read'] = true;
        }
      });
      widget.onCountsChanged?.call();

      _showMessage('تم تحديد جميع الإشعارات كمقروءة');
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'تعذر تحديث الإشعارات: $e',
      );
    }
  }


  void showNotificationDetails(
    Map<String, dynamic> notification,
  ) {
    // Mark the notification as read when it is opened.
    markAsRead(notification);

    final color = _notificationColor(
      notification['type'].toString(),
    );
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
<<<<<<< HEAD
                            _notificationIcon(notification['type']),
=======
                            _notificationIcon(
                              notification['type'].toString(),
                            ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            color: color,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
<<<<<<< HEAD
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: MasarColors.textPrimary,
=======
                          child: UniText(
                            notification['title'].toString(),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: UniColors.textPrimary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            ),
                          ),
                        ),
                      ],
                    ),
<<<<<<< HEAD
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
=======

                    const SizedBox(height: 22),

                    UniText(
                      notification['message'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.8,
                        color: UniColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 15),

                    UniText(
                      notification['time'].toString(),
                      style: TextStyle(
                        fontSize: 11,
                        color: UniColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                          backgroundColor: MasarColors.primaryBlue,
=======
                          backgroundColor: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
<<<<<<< HEAD
                        child: const Text('إغلاق'),
=======
                        child: const UniText('إغلاق'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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

<<<<<<< HEAD
  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    final bool isRead = notification['read'] as bool;
    final color = _notificationColor(notification['type']);
=======

  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    final bool isRead = notification['read'] == true;

    final color = _notificationColor(
      notification['type'].toString(),
    );
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showNotificationDetails(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: isRead ? MasarColors.white : MasarColors.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead
                ? MasarColors.border
                : MasarColors.primaryBlue.withOpacity(0.18),
=======
          color: isRead
              ? UniColors.white
              : UniColors.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead
                ? UniColors.border
                : UniColors.primaryBlue.withOpacity(0.18),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
<<<<<<< HEAD
                _notificationIcon(notification['type']),
=======
                _notificationIcon(
                  notification['type'].toString(),
                ),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                color: color,
                size: 23,
              ),
            ),
<<<<<<< HEAD
            const SizedBox(width: 15),
=======

            const SizedBox(width: 15),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
<<<<<<< HEAD
                        child: Text(
                          notification['title'],
=======
                        child: UniText(
                          notification['title'].toString(),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
<<<<<<< HEAD
                            color: MasarColors.textPrimary,
                          ),
                        ),
                      ),
=======
                            color: UniColors.textPrimary,
                          ),
                        ),
                      ),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
<<<<<<< HEAD
                            color: MasarColors.primaryBlue,
=======
                            color: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
<<<<<<< HEAD
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
=======

                  const SizedBox(height: 7),

                  UniText(
                    notification['message'].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: UniColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  UniText(
                    notification['time'].toString(),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    ),
                  ),
                ],
              ),
            ),
<<<<<<< HEAD
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'خيارات',
              icon: Icon(
                Icons.more_vert_rounded,
                color: MasarColors.textSecondary,
=======

            const SizedBox(width: 8),

            PopupMenuButton<String>(
              tooltip: UniLocalizations.translate('خيارات'),
              icon: Icon(
                Icons.more_vert_rounded,
                color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
                    child: Text('تحديد كمقروء'),
=======
                    child: UniText('تحديد كمقروء'),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
=======

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
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
<<<<<<< HEAD
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
=======
              ? UniColors.primaryBlue
              : UniColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? UniColors.primaryBlue
                : UniColors.border,
          ),
        ),
        child: UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected
                ? Colors.white
<<<<<<< HEAD
                : MasarColors.textSecondary,
=======
                : UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: MasarColors.background,
=======

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UniColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 50,
            color: UniColors.textSecondary,
          ),
          const SizedBox(height: 12),
          UniText(
            selectedFilter == 'غير مقروءة'
                ? 'لا توجد إشعارات غير مقروءة'
                : 'لا توجد إشعارات حاليًا',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: UniColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNotificationsContent() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: UniColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: UniColors.border),
        ),
        child: Column(
          children: [
            UniText(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UniColors.error,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const UniText('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (filteredNotifications.isEmpty) {
      return _emptyState();
    }

    return Column(
      children: filteredNotifications
          .map(_notificationCard)
          .toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
=======
              // Page title and mark-all action.
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        Text(
=======
                        UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          'الإشعارات',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
<<<<<<< HEAD
                            color: MasarColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'تابع آخر المستجدات والإجراءات المطلوبة',
                          style: TextStyle(
                            fontSize: 13,
                            color: MasarColors.textSecondary,
=======
                            color: UniColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        UniText(
                          'تابع آخر المستجدات والإجراءات المطلوبة',
                          style: TextStyle(
                            fontSize: 13,
                            color: UniColors.textSecondary,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                          ),
                        ),
                      ],
                    ),
                  ),
<<<<<<< HEAD
                  if (unreadCount > 0)
=======

                  if (unreadCount > 0 && !isLoading)
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    TextButton.icon(
                      onPressed: markAllAsRead,
                      icon: const Icon(
                        Icons.done_all_rounded,
                        size: 18,
                      ),
<<<<<<< HEAD
                      label: const Text('تحديد الكل كمقروء'),
                      style: TextButton.styleFrom(
                        foregroundColor: MasarColors.primaryBlue,
=======
                      label: const UniText('تحديد الكل كمقروء'),
                      style: TextButton.styleFrom(
                        foregroundColor: UniColors.primaryBlue,
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                      ),
                    ),
                ],
              ),
<<<<<<< HEAD
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: MasarColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: MasarColors.border),
=======

              const SizedBox(height: 24),

              // Unread notifications summary.
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                ),
                child: Row(
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
                        Icons.notifications_active_outlined,
<<<<<<< HEAD
                        color: MasarColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
=======
                        color: UniColors.primaryBlue,
                      ),
                    ),

                    const SizedBox(width: 14),

>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
<<<<<<< HEAD
                          Text(
=======
                          UniText(
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
                            '$unreadCount إشعارات غير مقروءة',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
<<<<<<< HEAD
                              color: MasarColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'تحتاج بعض الإشعارات إلى مراجعة أو إجراء',
                            style: TextStyle(
                              fontSize: 11,
                              color: MasarColors.textSecondary,
=======
                              color: UniColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          UniText(
                            'تحتاج بعض الإشعارات إلى مراجعة أو إجراء',
                            style: TextStyle(
                              fontSize: 11,
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
<<<<<<< HEAD
              const SizedBox(height: 18),
=======

              const SizedBox(height: 18),

              // Notification filters.
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
              Row(
                children: [
                  _filterButton('الكل'),
                  const SizedBox(width: 8),
                  _filterButton('غير مقروءة'),
                ],
              ),
<<<<<<< HEAD
              const SizedBox(height: 18),
              if (filteredNotifications.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  decoration: BoxDecoration(
                    color: MasarColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: MasarColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 50,
                        color: MasarColors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'لا توجد إشعارات غير مقروءة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MasarColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: filteredNotifications
                      .map(_notificationCard)
                      .toList(),
                ),
=======

              const SizedBox(height: 18),

              // Loading, error, empty state, or notifications.
              _buildNotificationsContent(),
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 38eb30f71e32f602569a8b62a5c766b4bd5d0b96
