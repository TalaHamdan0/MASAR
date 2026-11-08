import 'package:flutter/material.dart';


import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/services/university_notifications_service.dart';


class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onCountsChanged;

  const NotificationsScreen({super.key, this.onCountsChanged});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}


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


  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'غير مقروءة') {
      return notifications
          .where((item) => item['read'] != true)
          .toList();
    }

    return notifications;
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: UniText(message),
        behavior: SnackBarBehavior.floating,
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

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
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
                            _notificationIcon(
                              notification['type'].toString(),
                            ),
                            color: color,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: UniText(
                            notification['title'].toString(),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: UniColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

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

                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UniColors.primaryBlue,
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
                        child: const UniText('إغلاق'),
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
    final bool isRead = notification['read'] == true;

    final color = _notificationColor(
      notification['type'].toString(),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showNotificationDetails(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isRead
              ? UniColors.white
              : UniColors.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRead
                ? UniColors.border
                : UniColors.primaryBlue.withOpacity(0.18),
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
                _notificationIcon(
                  notification['type'].toString(),
                ),
                color: color,
                size: 23,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: UniText(
                          notification['title'].toString(),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                            color: UniColors.textPrimary,
                          ),
                        ),
                      ),

                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: UniColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

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
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            PopupMenuButton<String>(
              tooltip: UniLocalizations.translate('خيارات'),
              icon: Icon(
                Icons.more_vert_rounded,
                color: UniColors.textSecondary,
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
                    child: UniText('تحديد كمقروء'),
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
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected
                ? Colors.white
                : UniColors.textSecondary,
          ),
        ),
      ),
    );
  }


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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title and mark-all action.
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UniText(
                          'الإشعارات',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: UniColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        UniText(
                          'تابع آخر المستجدات والإجراءات المطلوبة',
                          style: TextStyle(
                            fontSize: 13,
                            color: UniColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (unreadCount > 0 && !isLoading)
                    TextButton.icon(
                      onPressed: markAllAsRead,
                      icon: const Icon(
                        Icons.done_all_rounded,
                        size: 18,
                      ),
                      label: const UniText('تحديد الكل كمقروء'),
                      style: TextButton.styleFrom(
                        foregroundColor: UniColors.primaryBlue,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Unread notifications summary.
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: UniColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: UniColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: UniColors.lightBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: UniColors.primaryBlue,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UniText(
                            '$unreadCount إشعارات غير مقروءة',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: UniColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          UniText(
                            'تحتاج بعض الإشعارات إلى مراجعة أو إجراء',
                            style: TextStyle(
                              fontSize: 11,
                              color: UniColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Notification filters.
              Row(
                children: [
                  _filterButton('الكل'),
                  const SizedBox(width: 8),
                  _filterButton('غير مقروءة'),
                ],
              ),

              const SizedBox(height: 18),

              // Loading, error, empty state, or notifications.
              _buildNotificationsContent(),
            ],
          ),
        ),
      ),
    );
  }
}