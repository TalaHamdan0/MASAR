class DemoMode {
  static const bool enabled = bool.fromEnvironment(
    'MASAR_DEMO',
    defaultValue: false,
  );

  static const String studentEmail =
      'student@masar.example.invalid';

  static const String studentNumber = '9000000001';

  static const String studentPassword = 'Masar@2026';
}