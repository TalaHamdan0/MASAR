import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/services/api_service.dart';
import 'core/services/auth_session.dart';
import 'core/theme/uni_dashboard_theme.dart';
import 'core/state/university_dashboard_preferences.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/profile/home_screen.dart';

import 'company_dashboard/screens/company_login_screen.dart';
import 'university_dashboard/screens/university_login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MasarStudentApp());

  _checkBackendConnection();
}

Future<void> _checkBackendConnection() async {
  try {
    final message = await ApiService.checkConnection();

    debugPrint('MASAR API: CONNECTED - $message');
  } catch (error) {
    debugPrint('MASAR API: FAILED - $error');
  }
}

class MasarStudentApp extends StatelessWidget {
  const MasarStudentApp({super.key});

  Widget _studentPage(Widget page) {
    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      return const LoginScreen();
    }

    return page;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UniversityDashboardPreferences.instance,
      builder: (context, _) {
        final preferences = UniversityDashboardPreferences.instance;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            _MasarNavigationObserver(),
          ],
          title: 'MASAR',
          locale: Locale(preferences.languageCode),
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: UniDashboardTheme.lightTheme,
          darkTheme: UniDashboardTheme.darkTheme,
          themeMode: preferences.materialThemeMode,
          home: const DashboardSelectorScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/create-account': (context) => const CreateAccountScreen(),
            '/complete-profile': (context) =>
                _studentPage(const CompleteProfileScreen()),
            '/home': (context) => _studentPage(const HomeScreen()),
            '/company-login': (context) => const CompanyLoginScreen(),
            '/university-login': (context) => const UniversityLoginScreen(),
          },
        );
      },
    );
  }
}

class DashboardSelectorScreen extends StatelessWidget {
  const DashboardSelectorScreen({super.key});

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color primaryGreen = Color(0xFF2EAD72);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.route_rounded,
                    size: 65,
                    color: primaryBlue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'MASAR',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اختار لوحة التحكم التي تريد فتحها',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _dashboardButton(
                    context,
                    title: 'تطبيق الطالب',
                    subtitle: 'الفرص التدريبية والمسار المهني',
                    icon: Icons.school_outlined,
                    color: primaryBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SplashScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _dashboardButton(
                    context,
                    title: 'لوحة تحكم الشركة',
                    subtitle: 'الفرص والمتقدمون والمتدربون',
                    icon: Icons.business_outlined,
                    color: primaryGreen,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/company-login',
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _dashboardButton(
                    context,
                    title: 'لوحة تحكم الجامعة',
                    subtitle: 'الطلاب والتدريب والتقارير',
                    icon: Icons.account_balance_outlined,
                    color: const Color(0xFF7C3AED),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/university-login',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MasarNavigationObserver extends NavigatorObserver {
  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    debugPrint(
      'MASAR NAV: PUSH ${route.settings.name} '
      'after ${previousRoute?.settings.name}',
    );

    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) {
    debugPrint(
      'MASAR NAV: REPLACE ${oldRoute?.settings.name} '
      'with ${newRoute?.settings.name}',
    );

    super.didReplace(
      newRoute: newRoute,
      oldRoute: oldRoute,
    );
  }
}