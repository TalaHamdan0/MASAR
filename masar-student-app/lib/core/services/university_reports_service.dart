import 'dart:convert';
import 'package:http/http.dart' as http;
import 'university_auth_service.dart';

class UniversityReportsException implements Exception {
  final String message;

  const UniversityReportsException(this.message);

  @override
  String toString() => message;
}

class UniversityReportsService {
  static Future<Map<String, dynamic>> fetchReports({
    required String period,
  }) async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityReportsException(
        'جلسة الدخول غير موجودة، يرجى تسجيل الدخول مرة أخرى.',
      );
    }

    final baseUrl = UniversityAuthService.baseUrl.endsWith('/')
        ? UniversityAuthService.baseUrl.substring(
            0,
            UniversityAuthService.baseUrl.length - 1,
          )
        : UniversityAuthService.baseUrl;

    final periodKeys = {
      'هذا الأسبوع': 'this_week',
      'هذا الشهر': 'this_month',
      'هذا الفصل': 'this_semester',
      'هذا العام': 'this_year',
    };

    final periodKey = periodKeys[period] ?? 'this_month';

    final uri = Uri.parse(
      '$baseUrl/api/v1/university/reports',
    ).replace(
      queryParameters: {
        'period': periodKey,
      },
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
      final message =
          error is Map ? error['message']?.toString() : null;

      throw UniversityReportsException(
        message ?? 'حدث خطأ أثناء تحميل التقارير.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityReportsException(
        'استجابة الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }
}