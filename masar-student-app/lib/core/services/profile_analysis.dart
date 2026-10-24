import '../models/student_model.dart';
import '../models/career_path_model.dart';

/// تحليل تغطية بيانات الملف لمتطلبات المسار، وليس قياس الإتقان.
class ProfileAnalysis {
  final String? studentId;
  final CareerPath? path;
  final List<String> requiredSkills;
  final Set<String> profileSkills;

  ProfileAnalysis._(
    this.studentId,
    this.path,
    List<String> required,
    Set<String> profile,
  )   : requiredSkills = List.unmodifiable(required),
        profileSkills = Set.unmodifiable(profile);

  static String normalize(String value) {
    return value.trim().toLowerCase();
  }

  factory ProfileAnalysis.fromProfile(
    Student? student,
    CareerPath? path,
  ) {
    final required = <String, String>{};

    for (final skill in path?.requiredSkills ?? <String>[]) {
      final key = normalize(skill);

      if (key.isNotEmpty) {
        required.putIfAbsent(key, () => skill.trim());
      }
    }

    final profile = <String>{};

    if (student != null) {
      profile.addAll(
        student.skills.map((skill) => normalize(skill.name)),
      );

      for (final project in student.projects) {
        profile.addAll(
          project.technologies.map(normalize),
        );
      }
    }

    profile.remove('');

    return ProfileAnalysis._(
      student?.id,
      path,
      required.values.toList(),
      profile,
    );
  }

  bool get canAnalyze {
    return studentId != null &&
        path != null &&
        requiredSkills.isNotEmpty &&
        profileSkills.isNotEmpty;
  }

  String? get unavailableReason {
    if (studentId == null) {
      return 'سجّل الدخول وأكمل ملفك المهني أولًا.';
    }

    if (path == null) {
      return 'اختر مسارك المهني من الرئيسية أولًا.';
    }

    if (requiredSkills.isEmpty) {
      return 'متطلبات هذا المسار غير متاحة بعد.';
    }

    if (profileSkills.isEmpty) {
      return 'أضف مهاراتك وتقنيات مشاريعك إلى ملفك أولًا.';
    }

    return null;
  }

  bool covers(String skill) {
    return profileSkills.contains(normalize(skill));
  }

  List<String> get coveredSkills {
    return requiredSkills.where(covers).toList();
  }

  List<String> get missingSkills {
    return requiredSkills
        .where((skill) => !covers(skill))
        .toList();
  }

  int? get coverageScore {
    if (!canAnalyze) return null;

    return (
      coveredSkills.length / requiredSkills.length * 100
    ).round();
  }

  String get fingerprint {
    final profile = profileSkills.toList()..sort();

    final required = requiredSkills
        .map(normalize)
        .toList()
      ..sort();

    return '$studentId|${path?.id}|'
        '${profile.join(";")}|${required.join(";")}';
  }
}