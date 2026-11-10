
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'university_auth_service.dart';


class UniversityNotificationsException implements Exception {
  final String message;

  const UniversityNotificationsException(this.message);

  @override
  String toString() => message;
}


class UniversityNotificationsService {
  static Future<Map<String, dynamic>> _request(
    String path, {
    String method = 'GET',
  }) async {
    final token = UniversityAuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw const UniversityNotificationsException(
        'جلسة الدخول غير موجودة، يرجى تسجيل الدخول مرة أخرى.',
      );
    }

    final baseUrl = UniversityAuthService.baseUrl.endsWith('/')
        ? UniversityAuthService.baseUrl.substring(
            0,
            UniversityAuthService.baseUrl.length - 1,
          )
        : UniversityAuthService.baseUrl;

    final uri = Uri.parse('$baseUrl/api/v1/university$path');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    late http.Response response;

    if (method == 'PATCH') {
      response = await http.patch(
        uri,
        headers: headers,
      );
    } else {
      response = await http.get(
        uri,
        headers: headers,
      );
    }

    final decoded = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      final error = decoded is Map ? decoded['error'] : null;

      final message =
          error is Map ? error['message']?.toString() : null;

      throw UniversityNotificationsException(
        message ?? 'حدث خطأ أثناء تنفيذ العملية.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversityNotificationsException(
        'استجابة الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }


  static Future<Map<String, dynamic>> fetchNotifications() async {
    return _request('/notifications');
  }


  static Future<void> markAsRead(String notificationId) async {
    await _request(
      '/notifications/$notificationId/read',
      method: 'PATCH',
    );
  }


  static Future<void> markAllAsRead() async {
    await _request(
      '/notifications/read-all',
      method: 'PATCH',
    );
  }
}
