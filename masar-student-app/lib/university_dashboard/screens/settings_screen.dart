import 'package:flutter/material.dart';


import '../../core/theme/uni_dashboard_theme.dart';
import '../../core/localization/uni_text.dart';
import '../../core/state/university_dashboard_preferences.dart';
import '../../core/services/university_settings_service.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool applicationNotifications = true;
  bool reportNotifications = true;
  bool trainingNotifications = true;

  bool _isLoading = true;
  String? _errorMessage;

  String _languageCode = 'ar';
  String _themeMode = 'LIGHT';

  Map<String, dynamic> _profile = {};

  final Set<String> _savingSettings = {};


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }


  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result =
          await UniversitySettingsService.fetchSettings();

      final profileData = result['profile'];
      final preferencesData = result['preferences'];

      final profile = profileData is Map
          ? Map<String, dynamic>.from(profileData)
          : <String, dynamic>{};

      final preferences = preferencesData is Map
          ? Map<String, dynamic>.from(preferencesData)
          : <String, dynamic>{};

      if (!mounted) return;

      setState(() {
        _profile = profile;

        applicationNotifications =
            preferences['applicationNotifications'] == true;

        reportNotifications =
            preferences['reportNotifications'] == true;

        trainingNotifications =
            preferences['trainingNotifications'] == true;

        _languageCode =
            (preferences['languageCode']?.toString() ?? 'ar').toLowerCase();

        _themeMode =
            (preferences['themeMode']?.toString() ?? 'LIGHT').toUpperCase();

        _isLoading = false;
      });

      UniversityDashboardPreferences.instance.apply(
        languageCode: _languageCode,
        themeMode: _themeMode,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }


  Future<void> _updateNotificationSetting({
    required String setting,
    required bool value,
  }) async {
    setState(() {
      _savingSettings.add(setting);
    });

    try {
      await UniversitySettingsService.updateNotificationSetting(
        setting: setting,
        value: value,
      );

      if (!mounted) return;

      setState(() {
        switch (setting) {
          case 'applicationNotifications':
            applicationNotifications = value;
            break;

          case 'reportNotifications':
            reportNotifications = value;
            break;

          case 'trainingNotifications':
            trainingNotifications = value;
            break;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: UniText('تم حفظ الإعدادات بنجاح'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: UniText('تعذر حفظ الإعدادات: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingSettings.remove(setting);
        });
      }
    }
  }


  Future<void> _updateGeneralPreference({
    required String setting,
    required String value,
  }) async {
    if (_savingSettings.contains(setting)) return;
    setState(() => _savingSettings.add(setting));

    try {
      await UniversitySettingsService.updateGeneralSetting(
        setting: setting,
        value: value,
      );
      if (!mounted) return;

      setState(() {
        if (setting == 'languageCode') {
          _languageCode = value;
        } else if (setting == 'themeMode') {
          _themeMode = value;
        }
      });

      UniversityDashboardPreferences.instance.apply(
        languageCode: setting == 'languageCode' ? value : null,
        themeMode: setting == 'themeMode' ? value : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: UniText('تم حفظ الإعدادات بنجاح'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: UniText('تعذر حفظ الإعدادات: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingSettings.remove(setting));
    }
  }

  Future<void> _chooseLanguage() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: Directionality.of(context),
        child: AlertDialog(
          title: const UniText('لغة النظام'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'ar',
                groupValue: _languageCode,
                title: const UniText('العربية'),
                onChanged: (value) => Navigator.pop(dialogContext, value),
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: _languageCode,
                title: const Text('English'),
                onChanged: (value) => Navigator.pop(dialogContext, value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const UniText('إلغاء'),
            ),
          ],
        ),
      ),
    );
    if (selected != null && selected != _languageCode) {
      await _updateGeneralPreference(setting: 'languageCode', value: selected);
    }
  }

  Future<void> _chooseTheme() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: Directionality.of(context),
        child: AlertDialog(
          title: const UniText('مظهر النظام'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'LIGHT',
                groupValue: _themeMode,
                title: const UniText('الوضع الفاتح'),
                onChanged: (value) => Navigator.pop(dialogContext, value),
              ),
              RadioListTile<String>(
                value: 'DARK',
                groupValue: _themeMode,
                title: const UniText('الوضع الداكن'),
                onChanged: (value) => Navigator.pop(dialogContext, value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const UniText('إلغاء'),
            ),
          ],
        ),
      ),
    );
    if (selected != null && selected != _themeMode) {
      await _updateGeneralPreference(setting: 'themeMode', value: selected);
    }
  }

  String get _languageName {
    return _languageCode.toLowerCase() == 'en'
        ? 'English'
        : 'العربية';
  }


  String get _themeName {
    return _themeMode.toUpperCase() == 'DARK'
        ? 'الوضع الداكن'
        : 'الوضع الفاتح';
  }


  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UniText(
          'الإعدادات',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: UniColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        UniText(
          'إدارة إعدادات بوابة الجامعة وتفضيلات النظام',
          style: TextStyle(
            fontSize: 14,
            color: UniColors.textSecondary,
          ),
        ),
      ],
    );
  }


  Widget _buildAccountSection() {
    return _settingsCard(
      title: 'الحساب',
      icon: Icons.person_outline_rounded,
      children: [
        _profileRow(
          icon: Icons.person_rounded,
          title: 'مسؤول التدريب',
          value: _profile['fullName']?.toString() ?? '—',
        ),
        const Divider(height: 1),
        _profileRow(
          icon: Icons.badge_outlined,
          title: 'الرقم الوظيفي',
          value: _profile['staffNumber']?.toString() ?? '—',
        ),
        const Divider(height: 1),
        _profileRow(
          icon: Icons.account_balance_outlined,
          title: 'الجامعة',
          value: _profile['universityName']?.toString() ?? '—',
        ),
      ],
    );
  }


  Widget _buildNotificationSection() {
    return _settingsCard(
      title: 'الإشعارات',
      icon: Icons.notifications_none_rounded,
      children: [
        _switchTile(
          icon: Icons.assignment_outlined,
          title: 'طلبات التدريب',
          subtitle: 'استلام إشعار عند وصول طلب تدريب جديد',
          value: applicationNotifications,
          isSaving: _savingSettings.contains(
            'applicationNotifications',
          ),
          onChanged: (value) {
            _updateNotificationSetting(
              setting: 'applicationNotifications',
              value: value,
            );
          },
        ),

        const Divider(height: 1),

        _switchTile(
          icon: Icons.description_outlined,
          title: 'التقارير',
          subtitle: 'التنبيه عند وجود تقرير تدريبي يحتاج إلى مراجعة',
          value: reportNotifications,
          isSaving: _savingSettings.contains(
            'reportNotifications',
          ),
          onChanged: (value) {
            _updateNotificationSetting(
              setting: 'reportNotifications',
              value: value,
            );
          },
        ),

        const Divider(height: 1),

        _switchTile(
          icon: Icons.school_outlined,
          title: 'التدريبات',
          subtitle: 'إشعارات حول حالة التدريبات الحالية',
          value: trainingNotifications,
          isSaving: _savingSettings.contains(
            'trainingNotifications',
          ),
          onChanged: (value) {
            _updateNotificationSetting(
              setting: 'trainingNotifications',
              value: value,
            );
          },
        ),
      ],
    );
  }


  Widget _buildGeneralSection() {
    return _settingsCard(
      title: 'الإعدادات العامة',
      icon: Icons.tune_rounded,
      children: [
        _optionTile(
          icon: Icons.language_rounded,
          title: 'لغة النظام',
          subtitle: _languageName,
          trailing: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left_rounded
                : Icons.chevron_right_rounded,
            color: UniColors.textSecondary,
          ),
          onTap: _savingSettings.contains('languageCode') ? null : _chooseLanguage,
        ),

        const Divider(height: 1),

        _optionTile(
          icon: Icons.palette_outlined,
          title: 'مظهر النظام',
          subtitle: _themeName,
          trailing: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left_rounded
                : Icons.chevron_right_rounded,
            color: UniColors.textSecondary,
          ),
          onTap: _savingSettings.contains('themeMode') ? null : _chooseTheme,
        ),
      ],
    );
  }


  Widget _buildAboutSection() {
    return _settingsCard(
      title: 'عن النظام',
      icon: Icons.info_outline_rounded,
      children: [
        _optionTile(
          icon: Icons.apps_rounded,
          title: 'منصة مسار',
          subtitle: 'بوابة إدارة ومتابعة برامج التدريب الميداني',
          trailing: UniText(
            'v1.0.0',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: UniColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }


  Widget _settingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: UniColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: UniColors.border,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: UniColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: UniColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: UniColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: UniColors.border,
          ),

          ...children,
        ],
      ),
    );
  }


  Widget _profileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 17,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: UniColors.textSecondary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: UniText(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: UniColors.textPrimary,
              ),
            ),
          ),
          Flexible(
            child: UniText(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                color: UniColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isSaving,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: UniColors.primaryBlue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                UniText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: isSaving ? null : onChanged,
            activeColor: UniColors.primaryGreen,
          ),
        ],
      ),
    );
  }


  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 17,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: UniColors.primaryBlue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UniText(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: UniColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                UniText(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: UniColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        color: UniColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitle(),

              const SizedBox(height: 24),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: UniColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: UniColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      UniText(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: UniColors.error,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _loadSettings,
                        child: const UniText('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              else ...[
                _buildAccountSection(),

                const SizedBox(height: 20),

                _buildNotificationSection(),

                const SizedBox(height: 20),

                _buildGeneralSection(),

                const SizedBox(height: 20),

                _buildAboutSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}