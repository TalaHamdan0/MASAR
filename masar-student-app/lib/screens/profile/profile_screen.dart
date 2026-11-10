
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/services/api_service.dart';
import '../../core/services/auth_session.dart';
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
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isRefreshing = true;
        _error = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final token = AuthSession.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('يرجى تسجيل الدخول أولًا.');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiService.baseUrl}/api/v1/students/me',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is! Map<String, dynamic>) {
        throw Exception('استجابة الخادم غير صالحة.');
      }

      if (response.statusCode != 200) {
        final error = decoded['error'];
        String message = 'تعذر تحميل الملف الشخصي.';

        if (error is Map && error['message'] != null) {
          message = error['message'].toString();
        }

        throw Exception(message);
      }

      final data = decoded['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('بيانات الطالب غير صالحة.');
      }

      if (!mounted) return;

      setState(() {
        _profile = data;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    if (!mounted) return;

    await _loadProfile(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return Scaffold(
      backgroundColor: MasarColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            tooltip: 'تحديث الملف الشخصي',
            onPressed: _isRefreshing || _isLoading
                ? null
                : () => _loadProfile(refresh: true),
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : profile == null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: () =>
                        _loadProfile(refresh: true),
                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        100,
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 42,
                            backgroundColor:
                                MasarColors.lightBlue,
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: MasarColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _displayValue(
                              profile['name'],
                              'اسم الطالب',
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _displayValue(
                              profile['major'],
                              'التخصص غير محدد',
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _openEditProfile,
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                              label: const Text(
                                'تعديل الملف الشخصي',
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  50,
                                ),
                                foregroundColor:
                                    MasarColors.primaryBlue,
                                side: const BorderSide(
                                  color:
                                      MasarColors.primaryBlue,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                color: MasarColors.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 28),
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
                                  builder: (_) =>
                                      const ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const _SectionTitle(
                            title: 'الخصوصية',
                          ),
                          Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
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
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            MasarColors.textPrimary,
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
                                  builder: (_) =>
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
                                  builder: (_) =>
                                      const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          TextButton.icon(
                            onPressed: () =>
                                _showLogoutDialog(context),
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
      ),
      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 4,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: MasarColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              _error ?? 'تعذر تحميل الملف الشخصي.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: MasarColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadProfile(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  String _displayValue(dynamic value, String fallback) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
                Navigator.pop(dialogContext);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                AuthSession.clear();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
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
