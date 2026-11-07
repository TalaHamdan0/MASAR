import 'dart:convert';
import 'package:http/http.dart' as http;
import 'university_auth_service.dart';

class UniversityDashboardService {
  static Future<Map<String, int>> fetchBadgeCounts() async {
    final token = UniversityAuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw StateError('جلسة الدخول غير موجودة.');
    }

    final configuredBaseUrl = UniversityAuthService.baseUrl;
    final baseUrl = configuredBaseUrl.endsWith('/')
        ? configuredBaseUrl.substring(0, configuredBaseUrl.length - 1)
        : configuredBaseUrl;

    final response = await http
        .get(
          Uri.parse('$baseUrl/api/v1/university/dashboard/badges'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 12));

    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 ||
        decoded is! Map ||
        decoded['data'] is! Map) {
      final error = decoded is Map ? decoded['error'] : null;
      final message = error is Map ? error['message']?.toString() : null;
      throw StateError(message ?? 'تعذر تحميل أعداد لوحة التحكم.');
    }

    final data = decoded['data'] as Map;
    return {
      'pendingApplications':
          int.tryParse('${data['pendingApplications'] ?? 0}') ?? 0,
      'unreadNotifications':
          int.tryParse('${data['unreadNotifications'] ?? 0}') ?? 0,
    };
  }
}
