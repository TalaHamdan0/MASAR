import 'package:flutter/material.dart';

import '../../theme/masar_theme.dart';

// ============================================================
// الشاشات
// ============================================================

import '../../company_dashboard/screens/company_home_screen.dart';
import '../../company_dashboard/screens/internships_screen.dart';
import '../../company_dashboard/screens/applicants_screen.dart';
import '../../company_dashboard/screens/smart_matching_screen.dart';
import '../../company_dashboard/screens/interviews_screen.dart';
import '../../company_dashboard/screens/trainees_screen.dart';
import '../../company_dashboard/screens/evaluations_screen.dart';
import '../../company_dashboard/screens/company_reports_screen.dart';
import '../../company_dashboard/screens/company_settings_screen.dart';
import '../../company_dashboard/screens/company_login_screen.dart';

// ============================================================
// Company Dashboard Sidebar
// ============================================================

class CompanyDashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  const CompanyDashboardSidebar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
  });

  // ============================================================
  // فتح شاشة بشكل مستقل
  // ============================================================

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // ============================================================
  // نافذة تأكيد تسجيل الخروج
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            title: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFEA580C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: MasarColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                height: 1.7,
                color: MasarColors.textSecondary,
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MasarColors.textPrimary,
                          side: const BorderSide(color: MasarColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const CompanyLoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF159947),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'تأكيد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 285,
        decoration: const BoxDecoration(
          color: MasarColors.white,
          border: Border(left: BorderSide(color: MasarColors.border, width: 1)),
        ),
        child: Column(
          children: [
            // ======================================================
            // الشعار
            // ======================================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  // ==================================================
                  // شعار MASAR الحقيقي
                  // ==================================================

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/masar_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.route_rounded,
                            color: MasarColors.primaryBlue,
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MASAR',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: MasarColors.primaryBlue,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Company Dashboard',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            color: MasarColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // ======================================================
            // القائمة
            // ======================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    // ------------------------------------------------
                    // الرئيسية
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 0,
                      icon: Icons.grid_view_rounded,
                      title: 'الرئيسية',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(0);
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // الفرص التدريبية
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 1,
                      icon: Icons.business_center_rounded,
                      title: 'الفرص التدريبية',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(1);
                        } else {
                          _openScreen(context, const InternshipsScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // إدارة المتقدمين
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 2,
                      icon: Icons.groups_rounded,
                      title: 'إدارة المتقدمين',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(2);
                        } else {
                          _openScreen(context, const ApplicantsScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // المطابقة الذكية
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 3,
                      icon: Icons.auto_awesome_rounded,
                      title: 'المطابقة الذكية',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(3);
                        } else {
                          _openScreen(context, const SmartMatchingScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // المقابلات
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 4,
                      icon: Icons.calendar_month_rounded,
                      title: 'المقابلات',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(4);
                        } else {
                          _openScreen(context, const InterviewsScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // المتدربين
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 5,
                      icon: Icons.groups_2_rounded,
                      title: 'المتدربين',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(5);
                        } else {
                          _openScreen(context, const TraineesScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // التقييمات
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 6,
                      icon: Icons.rate_review_rounded,
                      title: 'التقييمات',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(6);
                        } else {
                          _openScreen(context, const EvaluationsScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // التقارير
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 7,
                      icon: Icons.bar_chart_rounded,
                      title: 'التقارير',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(7);
                        } else {
                          _openScreen(context, const CompanyReportsScreen());
                        }
                      },
                    ),

                    // ------------------------------------------------
                    // إعدادات الشركة
                    // ------------------------------------------------
                    _buildMenuItem(
                      context: context,
                      index: 8,
                      icon: Icons.settings_rounded,
                      title: 'إعدادات الشركة',
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(8);
                        } else {
                          _openScreen(context, const CompanySettingsScreen());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ======================================================
            // اسم الشركة فقط (بدون زر أو رابط)
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xfff8fafc),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MasarColors.border),
                ),
                child: Row(
                  children: [
                    // أيقونة الشركة
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: MasarColors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: MasarColors.primaryBlue,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شركة التقنية',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: MasarColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Company Admin',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 9,
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ======================================================
            // تسجيل الخروج
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe9f9f1),
                    foregroundColor: const Color(0xff159947),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // عنصر القائمة
  // ============================================================

  Widget _buildMenuItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isSelected ? MasarColors.lightBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: isSelected
                      ? MasarColors.primaryBlue
                      : MasarColors.textSecondary,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected
                          ? MasarColors.primaryBlue
                          : MasarColors.textPrimary,
                    ),
                  ),
                ),

                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: MasarColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
