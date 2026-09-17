import 'package:flutter/material.dart';
//import 'package:masar_student_app/screens/career/my_cv_screen.dart';
import 'theme/masar_theme.dart';
import 'screens/career/skill_mirror_screen.dart';
//import 'screens/training_screens/training_dashboard_screen.dart';
//import 'screens/training_screens/company_selection_screen.dart';
import 'screens/profile/home_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/complete_profile_screen.dart';

void main() {
  runApp(const MasarApp());
}

class MasarApp extends StatelessWidget {
  const MasarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'مسار',

      theme: MasarTheme.lightTheme,

      // اللغة العربية
      locale: const Locale('ar'),

      // اتجاه التطبيق من اليمين لليسار
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: SplashScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/complete-profile': (context) => const CompleteProfileScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
