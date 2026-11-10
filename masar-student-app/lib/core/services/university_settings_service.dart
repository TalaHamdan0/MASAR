import 'dart:convert';
import 'package:http/http.dart' as http;
import 'university_auth_service.dart';

class UniversitySettingsException implements Exception {
  final String message;
  const UniversitySettingsException(this.message);
  @override
  String toString() => message;
}

class UniversitySettingsService {
  static String get _baseUrl {
    final value = UniversityAuthService.baseUrl;
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static Map<String, String> get _headers {
    final token = UniversityAuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw const UniversitySettingsException(
        'جلسة الدخول غير موجودة، يرجى تسجيل الدخول مرة أخرى.',
      );
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<Map<String, dynamic>> _decodeResponse(
    http.Response response,
  ) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw const UniversitySettingsException('استجابة الخادم غير صالحة.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded is Map ? decoded['error'] : null;
      final message = error is Map ? error['message']?.toString() : null;
      throw UniversitySettingsException(
        message ?? 'حدث خطأ أثناء تنفيذ العملية.',
      );
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw const UniversitySettingsException('استجابة الخادم غير صحيحة.');
    }
    return Map<String, dynamic>.from(decoded['data'] as Map);
  }

  static Future<Map<String, dynamic>> fetchSettings() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/api/v1/university/settings'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 15));
      return await _decodeResponse(response);
    } on UniversitySettingsException {
      rethrow;
    } catch (e) {
      throw UniversitySettingsException('تعذر تحميل الإعدادات: $e');
    }
  }

  static Future<void> updateNotificationSetting({
    required String setting,
    required bool value,
  }) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$_baseUrl/api/v1/university/settings/notifications'),
            headers: _headers,
            body: jsonEncode({setting: value}),
          )
          .timeout(const Duration(seconds: 15));
      await _decodeResponse(response);
    } on UniversitySettingsException {
      rethrow;
    } catch (e) {
      throw UniversitySettingsException('تعذر حفظ إعداد الإشعار: $e');
    }
  }

  static Future<void> updateGeneralSetting({
    required String setting,
    required String value,
  }) async {
    if (setting != 'languageCode' && setting != 'themeMode') {
      throw const UniversitySettingsException('إعداد عام غير مدعوم.');
    }
    try {
      final response = await http
          .patch(
            Uri.parse('$_baseUrl/api/v1/university/settings/preferences'),
            headers: _headers,
            body: jsonEncode({setting: value}),
          )
          .timeout(const Duration(seconds: 15));
      await _decodeResponse(response);
    } on UniversitySettingsException {
      rethrow;
    } catch (e) {
      throw UniversitySettingsException('تعذر حفظ الإعداد العام: $e');
    }
  }
}
