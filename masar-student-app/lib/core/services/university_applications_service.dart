import 'dart:convert';
import 'package:http/http.dart' as http;

import 'university_auth_service.dart';

class UniversityApplicationsException implements Exception {
  final String message;

  const UniversityApplicationsException(this.message);

  @override
  String toString() => message;
}

class UniversityApplicationsService {
  static Future<Map<String, dynamic>> fetchApplications() async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityApplicationsException(
        'انتهت جلسة الدخول. سجّلي الدخول مرة أخرى.',
      );
    }

    final baseUrl = UniversityAuthService.baseUrl.endsWith('/')
        ? UniversityAuthService.baseUrl.substring(
            0,
            UniversityAuthService.baseUrl.length - 1,
          )
        : UniversityAuthService.baseUrl;

    final uri = Uri.parse('$baseUrl/api/v1/university/applications');

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

      throw UniversityApplicationsException(
        message ?? 'حدث خطأ أثناء تحميل طلبات التدريب.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityApplicationsException(
        'البيانات المستلمة من الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }
}
