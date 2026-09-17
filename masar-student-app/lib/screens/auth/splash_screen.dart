import 'package:flutter/material.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.white,

      body: SafeArea(
        child: Stack(
          children: [
            // =========================
            // Logo & App Name
            // =========================
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // MASAR Logo
                  Image.asset(
                    'assets/images/masar_logo.png',
                    width: 145,
                    height: 145,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  // App Name
                  const Text(
                    'MASAR',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MasarColors.darkBlue,
                      letterSpacing: 2.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  const Text(
                    'Your Academic & Career Path',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: MasarColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // Footer
            // =========================
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: const Text(
                'Connecting Students • Universities • Companies',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MasarColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}