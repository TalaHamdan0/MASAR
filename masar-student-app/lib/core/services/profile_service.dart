import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student_model.dart';
import 'api_service.dart';
import 'auth_session.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getMyProfile() {
    return _request(
      path: '/api/v1/students/me',
    );
  }

  static Future<Map<String, dynamic>> getProfileOptions() {
    return _request(
      path: '/api/v1/students/profile-options',
    );
  }

  static Future<Map<String, dynamic>> saveMyProfile({
    required Student student,
    required int version,
    String? programId,
  }) {
    if (programId == null ||
        !RegExp(r'^[1-9][0-9]*$').hasMatch(programId)) {
      throw const ApiException(
        'يرجى اختيار التخصص من قائمة تخصصات الجامعة.',
      );
    }

    if (version < 0) {
      throw const ApiException(
        'نسخة الملف غير صالحة. سجّلي الدخول مجددًا.',
      );
    }

    final nameEn = student.nameEn.trim();

    if (nameEn.isNotEmpty) {
      final validCharacters = RegExp(
        r"^[A-Za-z][A-Za-z .'-]*$",
      ).hasMatch(nameEn);

      final letterCount = RegExp(
        r'[A-Za-z]',
      ).allMatches(nameEn).length;

      if (!validCharacters ||
          letterCount < 2 ||
          nameEn.length > 200) {
        throw const ApiException(
          'أدخلي الاسم بالإنجليزي بحروف صحيحة، '
          'وبحد أقصى 200 حرف.',
        );
      }
    }

    return _request(
      path: '/api/v1/students/me/profile',
      method: 'PUT',
      payload: {
        'version': version,
        if (nameEn.isNotEmpty) 'nameEn': nameEn,
        'programId': programId,
        'academicYear': student.academicYear.trim(),
        'skills': student.skills.map((skill) {
          return {
            'id': skill.id,
            'level': skill.level,
          };
        }).toList(),
        'softSkills': student.softSkills.map((skill) {
          return {
            'id': skill.id,
            'level': skill.level,
          };
        }).toList(),
        'certificates': student.certificates.map((certificate) {
          return {
            'id': _persistedId(certificate.id),
            'title': certificate.title.trim(),
            'issuer': certificate.issuer.trim(),
            'date': certificate.date.trim(),
          };
        }).toList(),
        'projects': student.projects.map((project) {
          return {
            'id': _persistedId(project.id),
            'name': project.name.trim(),
            'description': project.description.trim(),
            'technologies': project.technologies
                .map((technology) => technology.trim())
                .where((technology) => technology.isNotEmpty)
                .toList(),
            'githubUrl': project.githubUrl?.trim(),
          };
        }).toList(),
      },
    );
  }

  static String? _persistedId(String id) {
    if (id.startsWith('local_')) {
      return null;
    }

    if (RegExp(r'^[1-9][0-9]*$').hasMatch(id)) {
      return id;
    }

    return null;
  }

  static Future<Map<String, dynamic>> _request({
    required String path,
    String method = 'GET',
    Map<String, dynamic>? payload,
  }) async {
    final token = AuthSession.accessToken;

    if (token == null || token.trim().isEmpty) {
      throw const ApiException(
        'يرجى تسجيل الدخول للوصول إلى الملف الشخصي.',
      );
    }

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      if (payload != null) 'Content-Type': 'application/json',
    };

    try {
      final uri = Uri.parse('${ApiService.baseUrl}$path');
      final http.Response response;

      if (method == 'GET') {
        response = await http
            .get(
              uri,
              headers: headers,
            )
            .timeout(const Duration(seconds: 20));
      } else if (method == 'PUT') {
        response = await http
            .put(
              uri,
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 20));
      } else {
        throw const ApiException(
          'نوع طلب الملف الشخصي غير مدعوم.',
        );
      }

      if (AuthSession.accessToken != token) {
        throw const ApiException(
          'تغيّرت جلسة الدخول. افتحي الملف من الحساب الحالي.',
        );
      }

      Map<String, dynamic>? decoded;

      try {
        final body = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (body is Map<String, dynamic>) {
          decoded = body;
        }
      } on FormatException {
        decoded = null;
      }

      if (response.statusCode != 200) {
        throw ApiException(
          _errorMessage(
            response.statusCode,
            decoded,
          ),
        );
      }

      final data = decoded?['data'];

      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          'استجابة الملف الشخصي غير مكتملة.',
        );
      }

      return data;
    } on TimeoutException {
      throw const ApiException(
        'انتهت المهلة دون تأكيد العملية. '
        'تحققي من أحدث نسخة قبل إعادة المحاولة.',
      );
    } on http.ClientException {
      throw const ApiException(
        'تعذر الوصول للباكند. لم يصل تأكيد لإتمام العملية.',
      );
    }
  }

  static String _errorMessage(
    int statusCode,
    Map<String, dynamic>? body,
  ) {
    final error = body?['error'];

    if (error is Map<String, dynamic>) {
      final message = error['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (statusCode) {
      case 400:
      case 422:
        return 'راجعي بيانات الملف الشخصي.';

      case 401:
        return 'الجلسة غير صالحة؛ سجّلي الدخول مجددًا.';

      case 403:
        return 'غير مسموح بالوصول إلى هذا الملف.';

      case 404:
      case 405:
        return 'خدمة الملف الشخصي غير مجهّزة في الباكند.';

      case 409:
        return 'تغيّر الملف من جلسة أخرى. احتفظي بتعديلاتك '
            'وراجعي أحدث نسخة قبل الحفظ.';

      case 413:
        return 'حجم بيانات الملف يتجاوز الحد المسموح.';

      case 503:
        return 'خدمة قاعدة البيانات غير متاحة حاليًا.';

      default:
        return 'تعذر إكمال طلب الملف الشخصي حاليًا.';
    }
  }
}