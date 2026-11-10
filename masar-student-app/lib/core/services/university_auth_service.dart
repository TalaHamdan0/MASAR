import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UniversityAuthException implements Exception {
  final String message;

  const UniversityAuthException(this.message);
}

class UniversityAuthService {
  static const String baseUrl = String.fromEnvironment(
    'MASAR_API_URL',
    defaultValue: 'http://127.0.0.1:5003',
  );

  static String? accessToken;

  static Map<String, dynamic>? currentStaff;

  Future<Map<String, dynamic>> login(String identifier) async {
    late http.Response response;

    try {
      response = await http
          .post(
            Uri.parse('$baseUrl/api/v1/university/auth/login'),

            headers: {'Content-Type': 'application/json'},

            body: jsonEncode({'identifier': identifier}),
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const UniversityAuthException(
        'انتهت مهلة الاتصال بالباكند. حاولي مرة أخرى.',
      );
    } catch (_) {
      throw const UniversityAuthException(
        'تعذر الاتصال بالباكند. تأكدي أنه يعمل.',
      );
    }

    Map<String, dynamic> responseData;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }

      responseData = decoded;
    } catch (_) {
      throw const UniversityAuthException('استجابة الباكند غير صالحة.');
    }

    if (response.statusCode != 200) {
      final error = responseData['error'];

      String message = 'تعذر تسجيل الدخول.';

      if (error is Map) {
        message = error['message']?.toString() ?? message;
      }

      throw UniversityAuthException(message);
    }

    final data = responseData['data'];

    if (data is! Map<String, dynamic>) {
      throw const UniversityAuthException('بيانات تسجيل الدخول غير مكتملة.');
    }

    final token = data['accessToken'];

    final staff = data['universityStaff'];

    if (token is! String || token.isEmpty || staff is! Map<String, dynamic>) {
      throw const UniversityAuthException(
        'لم يتم استلام بيانات الجلسة بشكل صحيح.',
      );
    }

    accessToken = token;

    currentStaff = Map<String, dynamic>.from(staff);

    return currentStaff!;
  }

  static Future<void> logout() async {
    final token = accessToken;
    try {
      if (token != null && token.isNotEmpty) {
        await http
            .post(
              Uri.parse('$baseUrl/api/v1/university/auth/logout'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(const Duration(seconds: 8));
      }
    } catch (_) {
      // The local session must still be cleared if the server is unavailable.
    } finally {
      clearSession();
    }
  }

  static void clearSession() {
    accessToken = null;

    currentStaff = null;
  }
}
