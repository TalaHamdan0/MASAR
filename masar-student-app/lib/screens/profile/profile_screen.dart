import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/masar_mock_data.dart';
import '../../theme/masar_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'about_masar_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = MasarMockData.profileMockData;

    return Scaffold(
      backgroundColor: MasarColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('الملف الشخصي'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),
          child: Column(
            children: [
              // ==================================================
              // PROFILE IMAGE
              // ==================================================

              CircleAvatar(
                radius: 42,
                backgroundColor: MasarColors.lightBlue,
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: MasarColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // STUDENT NAME
              // ==================================================

              Text(
                profile['name'],
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 4),

              // ==================================================
              // MAJOR
              // ==================================================

              Text(
                profile['major'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // EDIT PROFILE
              // ==================================================

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const EditProfileScreen(),
                      ),
                    );

                    setState(() {});
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('تعديل الملف الشخصي'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ),
                    foregroundColor:
                        MasarColors.primaryBlue,
                    side: const BorderSide(
                      color: MasarColors.primaryBlue,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // ACCOUNT
              // ==================================================

              const _SectionTitle(
                title: 'الحساب',
              ),

              _ProfileTile(
                icon: Icons.lock_outline,
                title: 'تغيير كلمة المرور',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChangePasswordScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // PRIVACY
              // ==================================================

              const _SectionTitle(
                title: 'الخصوصية',
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        color: MasarColors.darkBlue,
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Text(
                          'إظهار الملف المهني للشركات',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MasarColors.textPrimary,
                          ),
                        ),
                      ),

                      Switch(
                        value: MasarMockData
                            .profileVisibleToCompanies,
                        activeTrackColor:
                            MasarColors.primaryGreen,
                        onChanged: (value) {
                          setState(() {
                            MasarMockData
                                    .profileVisibleToCompanies =
                                value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // ABOUT APP
              // ==================================================

              const _SectionTitle(
                title: 'حول التطبيق',
              ),

              _ProfileTile(
                icon: Icons.info_outline,
                title: 'عن مسار',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AboutMasarScreen(),
                    ),
                  );
                },
              ),

              _ProfileTile(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // ==================================================
              // LOGOUT
              // ==================================================

              TextButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  color: MasarColors.error,
                ),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: MasarColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 4,
      ),
    );
  }

  // ==============================================================
  // LOGOUT DIALOG
  // ==============================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم تسجيل الخروج',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: MasarColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ================================================================
// SECTION TITLE
// ================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

// ================================================================
// PROFILE TILE
// ================================================================

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.chevron_left,
          color: MasarColors.textSecondary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          icon,
          color: MasarColors.darkBlue,
        ),
        onTap: onTap,
      ),
    );
  }
}