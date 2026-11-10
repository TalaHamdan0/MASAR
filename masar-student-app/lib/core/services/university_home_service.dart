import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'university_auth_service.dart';

class UniversityHomeService {
  Future<Map<String, dynamic>> fetchHome() async {
    // Get the token saved after university login
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityAuthException(
        'انتهت جلسة الدخول. يرجى تسجيل الدخول مرة أخرى.',
      );
    }

    // Use the same API base URL as university login
    final baseUrl = UniversityAuthService.baseUrl.replaceFirst(
      RegExp(r'/$'),
      '',
    );

    late http.Response response;

    try {
      response = await http
          .get(
            Uri.parse('$baseUrl/api/v1/university/home'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const UniversityAuthException(
        'انتهت مهلة الاتصال بالخادم. حاولي مرة أخرى.',
      );
    } catch (_) {
      throw const UniversityAuthException(
        'تعذر الاتصال بالخادم. تأكدي من تشغيل Flask.',
      );
    }

    // Convert the JSON response into a Dart Map
    dynamic decodedResponse;

    try {
      decodedResponse = jsonDecode(response.body);
    } catch (_) {
      throw const UniversityAuthException('استجابة الخادم غير مفهومة.');
    }

    if (decodedResponse is! Map<String, dynamic>) {
      throw const UniversityAuthException('صيغة البيانات المستلمة غير صحيحة.');
    }

    // Handle API errors
    if (response.statusCode != 200) {
      final error = decodedResponse['error'];

      final message = error is Map ? error['message']?.toString() : null;

      throw UniversityAuthException(message ?? 'تعذر تحميل بيانات الصفحة.');
    }

    // Extract the data object
    final data = decodedResponse['data'];

    if (data is! Map) {
      throw const UniversityAuthException('لم يتم العثور على بيانات الصفحة.');
    }

    return Map<String, dynamic>.from(data);
  }
}
