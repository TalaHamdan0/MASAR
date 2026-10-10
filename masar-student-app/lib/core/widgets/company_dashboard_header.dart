import 'package:flutter/material.dart';
import '../../theme/masar_theme.dart';
import '../../company_dashboard/screens/notifications_screen.dart';

class CompanyDashboardHeader extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final String userName;
  final String userRole;
  final bool hasUnreadNotifications;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;

  const CompanyDashboardHeader({
    super.key,
    this.title = 'الرئيسية',
    this.userName = 'سارة المطيري',
    this.userRole = 'رئيسة التوظيف',
    this.hasUnreadNotifications = true,
    this.onSearchChanged,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78.0);

  @override
  State<CompanyDashboardHeader> createState() => _CompanyDashboardHeaderState();
}

class _CompanyDashboardHeaderState extends State<CompanyDashboardHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: MasarColors.white,
          border: Border(bottom: BorderSide(color: MasarColors.border)),
        ),
        child: Row(
          children: [
            // =================================================
            // 1. Dynamic Page Title
            // =================================================
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: MasarColors.textPrimary,
              ),
            ),

            const Spacer(),

            // =================================================
            // 2. Active Search Bar
            // =================================================
            Container(
              width: 300,
              height: 46,
              decoration: BoxDecoration(
                color: MasarColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MasarColors.border),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // لتحديث ظهور زر المسح (x)
                  if (widget.onSearchChanged != null) {
                    widget.onSearchChanged!(value);
                  }
                },
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: MasarColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'البحث عن طالب أو تخصص...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: MasarColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: MasarColors.textSecondary,
                    size: 21,
                  ),
                  // إضافة زر إلغاء/مسح البحث عند كتابة نص
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: MasarColors.textSecondary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                            if (widget.onSearchChanged != null) {
                              widget.onSearchChanged!('');
                            }
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // =================================================
            // 3. Notification Button
            // =================================================
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap:
                  widget.onNotificationPressed ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CompanyNotificationsScreen(),
                      ),
                    );
                  },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: MasarColors.primaryBlue,
                      size: 24,
                    ),
                    if (widget.hasUnreadNotifications)
                      Positioned(
                        top: 7,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: MasarColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),

            // =================================================
            // 4. User Information & Avatar
            // =================================================
            InkWell(
              onTap: widget.onProfilePressed,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: MasarColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.userRole,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: MasarColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 11),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: MasarColors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: MasarColors.primaryBlue,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
