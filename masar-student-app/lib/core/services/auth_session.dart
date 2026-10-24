import '../models/student_model.dart';
import '../models/skill_model.dart';
import '../models/soft_skill_model.dart';
import '../models/certificate_model.dart';
import '../models/project_model.dart';

class AuthSession {
  static String? _accessToken;
  static int? _profileVersion;
  static String? _studentEmail;

  static String? get accessToken => _accessToken;
  static int? get profileVersion => _profileVersion;

  static void clear() {
    _accessToken = null;
    _profileVersion = null;
    _studentEmail = null;
  }

  // حفظ الجلسة بعد نجاح إنشاء الحساب أو تسجيل الدخول.
  static Student start(Map<String, dynamic> data) {
    final token = data['accessToken'];
    final profile = data['student'];

    if (token is! String ||
        token.trim().isEmpty ||
        profile is! Map<String, dynamic>) {
      throw const FormatException(
        'بيانات جلسة الدخول غير مكتملة.',
      );
    }

    final student = _parseStudent(profile);
    final version = _readVersion(profile);

    _accessToken = token;
    _profileVersion = version;
    _studentEmail = student.email;

    return student;
  }

  // تحديث الجلسة بعد حفظ الملف المهني بنجاح في الباك إند.
  static Student updateProfile(Map<String, dynamic> data) {
    if (_accessToken == null) {
      throw const FormatException('لا توجد جلسة دخول.');
    }

    final student = _parseStudent(data);
    final version = _readVersion(data);

    if (student.email != _studentEmail) {
      throw const FormatException(
        'بيانات الملف لا تطابق الحساب الحالي.',
      );
    }

    _profileVersion = version;

    return student;
  }

  static int _readVersion(Map<String, dynamic> data) {
    final version = data['version'];

    if (version is! int || version < 0) {
      throw const FormatException(
        'رقم نسخة الملف غير صالح.',
      );
    }

    return version;
  }

  static Student _parseStudent(Map<String, dynamic> data) {
    final id = _text(data, 'id');
    final name = _text(data, 'name');
    final email = _text(data, 'email');

    if (id.isEmpty || name.isEmpty || email.isEmpty) {
      throw const FormatException(
        'بيانات الطالب الأساسية غير مكتملة.',
      );
    }

    final careerPathId = data['careerPathId'];

    if (careerPathId != null && careerPathId is! String) {
      throw const FormatException(
        'بيانات المسار المهني غير صالحة.',
      );
    }

    return Student(
      id: id,
      name: name,
      email: email,
      university: _text(data, 'university'),
      major: _text(data, 'major'),
      academicYear: _text(data, 'academicYear'),
      gpa: _text(data, 'gpa'),
      careerPathId: careerPathId as String?,
      skills: _items(data, 'skills').map((item) {
        return Skill(
          id: _text(item, 'id'),
          name: _text(item, 'name'),
          level: _level(item),
          status: _text(
            item,
            'status',
            fallback: 'Not Assessed',
          ),
        );
      }).toList(),
      softSkills: _items(data, 'softSkills').map((item) {
        return SoftSkill(
          id: _text(item, 'id'),
          name: _text(item, 'name'),
          level: _level(item),
        );
      }).toList(),
      certificates: _items(data, 'certificates').map((item) {
        return Certificate(
          id: _text(item, 'id'),
          title: _text(item, 'title'),
          issuer: _text(item, 'issuer'),
          date: _text(item, 'date'),
        );
      }).toList(),
      projects: _items(data, 'projects').map((item) {
        final technologies = item['technologies'] ?? [];
        final githubUrl = item['githubUrl'];

        if (technologies is! List ||
            technologies.any((value) => value is! String) ||
            (githubUrl != null && githubUrl is! String)) {
          throw const FormatException(
            'بيانات المشروع غير صالحة.',
          );
        }

        return Project(
          id: _text(item, 'id'),
          name: _text(item, 'name'),
          description: _text(item, 'description'),
          technologies: technologies.cast<String>().toList(),
          githubUrl: githubUrl as String?,
        );
      }).toList(),
    );
  }

  static String _text(
    Map<String, dynamic> data,
    String key, {
    String fallback = '',
  }) {
    final value = data[key];

    if (value == null) {
      return fallback;
    }

    if (value is! String) {
      throw FormatException('قيمة $key غير صالحة.');
    }

    return value;
  }

  static int _level(Map<String, dynamic> data) {
    final value = data['level'] ?? 0;

    if (value is! int || value < 0 || value > 100) {
      throw const FormatException(
        'مستوى المهارة غير صالح.',
      );
    }

    return value;
  }

  static List<Map<String, dynamic>> _items(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];

    if (value == null) {
      return [];
    }

    if (value is! List) {
      throw FormatException('قائمة $key غير صالحة.');
    }

    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException(
          'عنصر داخل $key غير صالح.',
        );
      }

      return item;
    }).toList();
  }
}