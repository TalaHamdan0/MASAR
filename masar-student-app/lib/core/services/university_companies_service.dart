import 'dart:convert';
import 'package:http/http.dart' as http;

import 'university_auth_service.dart';

class UniversityCompaniesException implements Exception {
  final String message;

  const UniversityCompaniesException(this.message);

  @override
  String toString() => message;
}

class UniversityCompaniesService {
  static Future<Map<String, dynamic>> fetchCompanies() async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityCompaniesException(
        'انتهت جلسة الدخول. سجّلي الدخول مرة أخرى.',
      );
    }

    final baseUrl = UniversityAuthService.baseUrl.endsWith('/')
        ? UniversityAuthService.baseUrl.substring(
            0,
            UniversityAuthService.baseUrl.length - 1,
          )
        : UniversityAuthService.baseUrl;

    final uri = Uri.parse('$baseUrl/api/v1/university/companies');

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

      throw UniversityCompaniesException(
        message ?? 'حدث خطأ أثناء تحميل الشركات.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityCompaniesException(
        'البيانات المستلمة من الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }
}