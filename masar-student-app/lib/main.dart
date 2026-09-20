import 'package:flutter/material.dart';

import 'theme/masar_theme.dart';
import 'screens/training_screens/training_dashboard_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/complete_profile_screen.dart';

// Home
import 'screens/profile/home_screen.dart';

// Training
import 'screens/training_screens/company_selection_screen.dart';

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

      // اتجاه التطبيق RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // أول شاشة
      home: const SplashScreen(),

      // Routes
      routes: {
        '/login': (context) => const LoginScreen(),

        '/create-account': (context) =>
            const CreateAccountScreen(),

        '/complete-profile': (context) =>
            const CompleteProfileScreen(),

        '/home': (context) =>
            const HomeScreen(),

        // التدريب الميداني
        '/training': (context) =>
            const SelectCompanyScreen(),
      },
    );
  }
}