import 'dart:convert';
import 'package:http/http.dart' as http;

import 'university_auth_service.dart';

class UniversityStudentsService {
  static Future<Map<String, dynamic>> fetchStudents() async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityAuthException(
        'يرجى تسجيل الدخول أولًا.',
      );
    }

    final uri = Uri.parse(
      '${UniversityAuthService.baseUrl}/api/v1/university/students',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = decoded is Map ? decoded['error'] : null;

      final message = error is Map
          ? error['message']?.toString()
          : null;

      throw UniversityAuthException(
        message ?? 'حدث خطأ أثناء تحميل بيانات الطلاب.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityAuthException(
        'استجابة السيرفر غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(
      decoded['data'] as Map,
    );
  }
}