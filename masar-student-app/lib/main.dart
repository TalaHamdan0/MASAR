import 'package:flutter/material.dart';
import 'university_dashboard/screens/university_login_screen.dart';

void main() {
  runApp(const MasarUniversityApp());
}

class MasarUniversityApp extends StatelessWidget {
  const MasarUniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MASAR University Dashboard',
      theme: ThemeData(
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: const UniversityLoginScreen(),
    );
  }
}