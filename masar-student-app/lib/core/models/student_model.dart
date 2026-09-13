
import 'skill_model.dart';
import 'soft_skill_model.dart';
import 'certificate_model.dart';

class Student {
  final String id;
  final String name;
  final String major;
  final String university;
  final String academicYear;
  final String email;
  final String? careerPathId;
  final String gpa;

  final List<Skill> skills;
  final List<SoftSkill> softSkills;
  final List<Certificate> certificates;

  const Student({
    required this.id,
    required this.name,
    required this.major,
    required this.university,
    required this.academicYear,
    required this.email,
    required this.careerPathId,
    required this.gpa,
    required this.skills,
    required this.softSkills,
    required this.certificates,
  });
}

