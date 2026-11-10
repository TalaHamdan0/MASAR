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
  static String _baseUrl() {
    final configuredUrl = UniversityAuthService.baseUrl;
    return configuredUrl.endsWith('/')
        ? configuredUrl.substring(0, configuredUrl.length - 1)
        : configuredUrl;
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } on FormatException {
      // The server may return a non-JSON error page. Handle it below.
    }

    throw const UniversityApplicationsException(
      'استجابة الخادم غير صالحة. حاولي مرة أخرى.',
    );
  }

  static String _errorMessage(Map<String, dynamic> decoded, String fallback) {
    final error = decoded['error'];
    if (error is Map) {
      final message = error['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }
    }
    return fallback;
  }

  static Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String _accessToken() {
    final token = UniversityAuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw const UniversityApplicationsException(
        'انتهت جلسة الدخول. سجّلي الدخول مرة أخرى.',
      );
    }
    return token;
  }

  static Future<Map<String, dynamic>> fetchApplications() async {
    final token = _accessToken();
    final uri = Uri.parse('${_baseUrl()}/api/v1/university/applications');

    late final http.Response response;
    try {
      response = await http.get(uri, headers: _headers(token));
    } catch (error) {
      throw UniversityApplicationsException('تعذر الاتصال بالخادم: $error');
    }

    final decoded = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw UniversityApplicationsException(
        _errorMessage(decoded, 'حدث خطأ أثناء تحميل طلبات التدريب.'),
      );
    }

    if (decoded['data'] is! Map) {
      throw const UniversityApplicationsException(
        'البيانات المستلمة من الخادم غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }

  /// decision must be ACCEPT or REJECT.
  /// The backend verifies that the application belongs to this university
  /// and is still waiting for a university decision.
  static Future<Map<String, dynamic>> updateApplicationDecision({
    required String applicationId,
    required String decision,
  }) async {
    final token = _accessToken();
    final normalizedDecision = decision.trim().toUpperCase();

    if (normalizedDecision != 'ACCEPT' && normalizedDecision != 'REJECT') {
      throw const UniversityApplicationsException('اختيار القرار غير صحيح.');
    }

    final uri = Uri.parse(
      '${_baseUrl()}/api/v1/university/applications/'
      '${Uri.encodeComponent(applicationId)}/decision',
    );

    late final http.Response response;
    try {
      response = await http.patch(
        uri,
        headers: _headers(token),
        body: jsonEncode({'decision': normalizedDecision}),
      );
    } catch (error) {
      throw UniversityApplicationsException(
        'تعذر الاتصال بالخادم أثناء تحديث الطلب: $error',
      );
    }

    final decoded = _decodeResponse(response);

    if (response.statusCode != 200) {
      throw UniversityApplicationsException(
        _errorMessage(decoded, 'تعذر تحديث حالة طلب التدريب.'),
      );
    }

    if (decoded['data'] is! Map) {
      throw const UniversityApplicationsException(
        'استجابة تحديث الطلب غير صحيحة.',
      );
    }

    return Map<String, dynamic>.from(decoded['data'] as Map);
  }
}
