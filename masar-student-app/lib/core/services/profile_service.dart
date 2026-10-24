import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student_model.dart';
import 'api_service.dart';
import 'auth_session.dart';

class ProfileService {
  // جلب الملف الشخصي للطالب المسجّل دخوله.
  static Future<Map<String, dynamic>> getMyProfile() {
    return _request();
  }

  // حفظ البيانات الأكاديمية والمهارات والشهادات والمشاريع.
  static Future<Map<String, dynamic>> saveMyProfile({
    required Student student,
    required int version,
  }) {
    return _request(
      payload: {
        'version': version,
        'major': student.major,
        'academicYear': student.academicYear,
        'gpa': student.gpa,
        'skills': student.skills.map((skill) {
          return {
            'id': skill.id,
            'name': skill.name,
            'level': skill.level,
            'status': skill.status,
          };
        }).toList(),
        'softSkills': student.softSkills.map((skill) {
          return {
            'id': skill.id,
            'name': skill.name,
            'level': skill.level,
          };
        }).toList(),
        'certificates': student.certificates.map((certificate) {
          return {
            'id': certificate.id,
            'title': certificate.title,
            'issuer': certificate.issuer,
            'date': certificate.date,
          };
        }).toList(),
        'projects': student.projects.map((project) {
          return {
            'id': project.id,
            'name': project.name,
            'description': project.description,
            'technologies': List<String>.of(
              project.technologies,
            ),
            'githubUrl': project.githubUrl,
          };
        }).toList(),
      },
    );
  }

  static Future<Map<String, dynamic>> _request({
    Map<String, dynamic>? payload,
  }) async {
    final token = AuthSession.accessToken;

    if (token == null || token.isEmpty) {
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
      final http.Response response;

      if (payload == null) {
        response = await http
            .get(
              Uri.parse(
                '${ApiService.baseUrl}/api/v1/students/me',
              ),
              headers: headers,
            )
            .timeout(const Duration(seconds: 20));
      } else {
        response = await http
            .put(
              Uri.parse(
                '${ApiService.baseUrl}/api/v1/students/me/profile',
              ),
              headers: headers,
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 20));
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
        // تتم معالجة الاستجابات غير الصالحة حسب حالة الطلب.
      }

      if (response.statusCode != 200) {
        final error = decoded?['error'];

        if (error is Map<String, dynamic> &&
            error['message'] is String &&
            (error['message'] as String).trim().isNotEmpty) {
          throw ApiException(error['message'] as String);
        }

        switch (response.statusCode) {
          case 401:
            throw const ApiException(
              'الجلسة غير صالحة؛ سجّلي الدخول مجددًا.',
            );

          case 403:
            throw const ApiException(
              'غير مسموح بتعديل هذا الملف.',
            );

          case 409:
            throw const ApiException(
              'تغيّر الملف من جلسة أخرى. احتفظي بتعديلاتك '
              'وراجعي أحدث نسخة قبل الحفظ.',
            );

          case 404:
          case 405:
          case 503:
            throw const ApiException(
              'خدمة الملف الشخصي غير جاهزة في الباكند بعد.',
            );

          case 400:
          case 422:
            throw const ApiException(
              'راجعي بيانات الملف الشخصي.',
            );

          default:
            throw const ApiException(
              'تعذر إكمال طلب الملف الشخصي حاليًا.',
            );
        }
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
}