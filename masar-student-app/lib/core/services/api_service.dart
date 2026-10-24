import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5001',
  );

  static Future<String> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/v1/health'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw const ApiException(
          'تعذر الاتصال بالباكند.',
        );
      }

      final data = _decodeObject(response);

      if (data['status'] != 'ok' ||
          data['message'] is! String) {
        throw const ApiException(
          'استجابة فحص الاتصال غير متوقعة.',
        );
      }

      return data['message'] as String;
    } on TimeoutException {
      throw const ApiException(
        'انتهت مهلة الاتصال بالباكند.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول للباكند. تأكدي أنه شغّال.',
      );
    }
  }

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    required bool rememberMe,
    String? universityId,
  }) {
    final payload = <String, dynamic>{
      'identifier': identifier.trim(),
      'password': password,
      'rememberMe': rememberMe,
    };

    if (universityId != null &&
        universityId.trim().isNotEmpty) {
      payload['universityId'] = universityId.trim();
    }

    return _sendAuthRequest(
      path: '/api/v1/auth/login',
      payload: payload,
      expectedStatus: 200,
      operation: 'تسجيل الدخول',
    );
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String studentNumber,
    required String universityName,
    required String email,
    required String password,
  }) async {
    final universityId = await _resolveUniversityId(
      universityName,
    );

    return _sendAuthRequest(
      path: '/api/v1/auth/register',
      expectedStatus: 201,
      operation: 'إنشاء الحساب',
      payload: {
        'name': name.trim(),
        'studentNumber': studentNumber.trim(),
        'universityId': universityId,
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );
  }

  static Future<String> _resolveUniversityId(
    String universityName,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/v1/universities'),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiException(
          _errorMessage(
            response,
            operation: 'تحميل الجامعات',
          ),
        );
      }

      final body = _decodeObject(response);
      final universities = body['data'];

      if (universities is! List) {
        throw const ApiException(
          'قائمة الجامعات التي رجعت من الباكند غير صالحة.',
        );
      }

      final matchingIds = <String>[];

      for (final university in universities) {
        if (university is! Map<String, dynamic>) {
          throw const ApiException(
            'بيانات الجامعات غير صالحة.',
          );
        }

        final id = university['id'];
        final name = university['name'];

        if (id is! String ||
            id.trim().isEmpty ||
            name is! String) {
          throw const ApiException(
            'بيانات إحدى الجامعات غير مكتملة.',
          );
        }

        if (name.trim() == universityName.trim()) {
          matchingIds.add(id);
        }
      }

      if (matchingIds.length != 1) {
        throw const ApiException(
          'تعذر تحديد الجامعة المعروضة. يلزم مراجعة قائمة الجامعات في الباكند.',
        );
      }

      return matchingIds.single;
    } on TimeoutException {
      throw const ApiException(
        'انتهت مهلة تحميل الجامعات. حاولي مجددًا.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول للباكند. تأكدي أنه شغّال.',
      );
    }
  }

  static Future<Map<String, dynamic>> _sendAuthRequest({
    required String path,
    required Map<String, dynamic> payload,
    required int expectedStatus,
    required String operation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != expectedStatus) {
        throw ApiException(
          _errorMessage(
            response,
            operation: operation,
          ),
        );
      }

      final body = _decodeObject(response);
      final data = body['data'];

      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          'استجابة الباكند غير مكتملة.',
        );
      }

      final token = data['accessToken'];
      final student = data['student'];

      if (token is! String ||
          token.trim().isEmpty ||
          student is! Map<String, dynamic>) {
        throw const ApiException(
          'لم يرجع الباكند جلسة وبيانات طالب صالحة.',
        );
      }

      return data;
    } on TimeoutException {
      throw ApiException(
        'انتهت مهلة $operation. لم يصل تأكيد من الباكند.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول للباكند. تأكدي أنه شغّال.',
      );
    }
  }

  static Map<String, dynamic> _decodeObject(
    http.Response response,
  ) {
    try {
      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      throw const ApiException(
        'الباكند رجّع استجابة غير صالحة.',
      );
    }

    throw const ApiException(
      'صيغة استجابة الباكند غير متوقعة.',
    );
  }

  static String _errorMessage(
    http.Response response, {
    required String operation,
  }) {
    try {
      final body = _decodeObject(response);
      final error = body['error'];

      if (error is Map<String, dynamic>) {
        final message = error['message'];

        if (message is String &&
            message.trim().isNotEmpty) {
          return message;
        }
      }
    } on ApiException {
      // نستخدم رسالة مناسبة إذا لم تكن الاستجابة JSON.
    }

    switch (response.statusCode) {
      case 400:
      case 422:
        return 'راجعي البيانات المدخلة.';
      case 401:
        return 'بيانات تسجيل الدخول غير صحيحة.';
      case 403:
        return 'هذه العملية غير مسموحة لهذا الحساب.';
      case 404:
      case 405:
        return 'خدمة $operation لسه غير مجهّزة في الباكند.';
      case 409:
        return 'البريد أو الرقم الجامعي مستخدم في هذه الجامعة.';
      case 429:
        return 'محاولات كثيرة. انتظري قليلًا وحاولي مجددًا.';
      default:
        return 'تعذر إكمال $operation حاليًا.';
    }
  }
}