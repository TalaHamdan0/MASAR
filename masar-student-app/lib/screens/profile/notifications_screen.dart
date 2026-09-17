import 'package:flutter/material.dart';

import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        title: const Text(
          'الإشعارات',
        ),
      ),

            //leading: IconButton(
            //icon: const Icon(Icons.arrow_back_ios_new),
            //onPressed: () {
              //Navigator.pop(context);
            //},
          //),

      body: Directionality(
        textDirection: TextDirection.rtl,

        child: ListView.builder(
          padding: const EdgeInsets.all(20),

          itemCount:
              MasarMockData.notifications.length,

          itemBuilder: (context, index) {
            final notification =
                MasarMockData.notifications[index];

            return _NotificationCard(
              title: notification['title'],
              message: notification['message'],
              time: notification['time'],
              type: notification['type'],
            );
          },
        ),
      ),
    );
  }
}


// ======================================================
// Notification Card
// ======================================================

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String type;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // Icon
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                shape: BoxShape.circle,
              ),

              child: Icon(
                _getIcon(),
                color: _getIconColor(),
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          MasarColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color:
                          MasarColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color:
                          MasarColors.textSecondary,
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

  IconData _getIcon() {
    switch (type) {
      case 'opportunity':
        return Icons.work_outline;

      case 'application':
        return Icons.notifications_active_outlined;

      case 'roadmap':
        return Icons.route_outlined;

      case 'training':
        return Icons.school_outlined;

      default:
        return Icons.notifications_none;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'opportunity':
        return MasarColors.primaryGreen;

      case 'application':
        return MasarColors.primaryBlue;

      case 'roadmap':
        return MasarColors.primaryGreen;

      case 'training':
        return MasarColors.primaryBlue;

      default:
        return MasarColors.primaryBlue;
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case 'opportunity':
        return MasarColors.lightGreen;

      case 'application':
        return MasarColors.lightBlue;

      case 'roadmap':
        return MasarColors.lightGreen;

      case 'training':
        return MasarColors.lightBlue;

      default:
        return MasarColors.lightBlue;
    }
  }
}