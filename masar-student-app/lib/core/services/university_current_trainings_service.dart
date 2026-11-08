import 'dart:convert';
import 'package:http/http.dart' as http;
import 'university_auth_service.dart';

class UniversityCurrentTrainingsException implements Exception {
  final String message;

  const UniversityCurrentTrainingsException(this.message);

  @override
  String toString() => message;
}

class UniversityCurrentTrainingsService {
  static Future<Map<String, dynamic>> fetchTrainings() async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityCurrentTrainingsException(
        'جلسة الدخول غير موجودة، يرجى تسجيل الدخول مرة أخرى.',
      );
    }

    final baseUrl = UniversityAuthService.baseUrl.endsWith('/')
        ? UniversityAuthService.baseUrl.substring(
            0,
            UniversityAuthService.baseUrl.length - 1,
          )
        : UniversityAuthService.baseUrl;

    final uri = Uri.parse('$baseUrl/api/v1/university/current-trainings');

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
      final message = error is Map ? error['message']?.toString() : null;

      throw UniversityCurrentTrainingsException(
        message ?? 'حدث خطأ أثناء تحميل التدريبات الحالية.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityCurrentTrainingsException(
        'استجابة الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }
}
