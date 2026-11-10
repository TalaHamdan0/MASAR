import 'package:flutter/material.dart';

import 'core/services/api_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/complete_profile_screen.dart';
import 'screens/profile/home_screen.dart';
import 'theme/masar_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('MASAR BOOT: main_student');

  runApp(const MasarStudentMobileApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('MASAR BOOT: FIRST FRAME');
    _checkBackendConnection();
  });
}

Future<void> _checkBackendConnection() async {
  try {
    final message = await ApiService.checkConnection();

    debugPrint('MASAR API: CONNECTED - $message');
  } catch (error) {
    debugPrint('MASAR API: FAILED - $error');
  }
}

class MasarStudentMobileApp extends StatelessWidget {
  const MasarStudentMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MASAR',
      theme: MasarTheme.lightTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/create-account': (_) => const CreateAccountScreen(),
        '/complete-profile': (_) => const CompleteProfileScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}