import 'skill_model.dart';
import 'soft_skill_model.dart';
import 'certificate_model.dart';
import 'project_model.dart';

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
  final List<Project> projects;

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
    required this.projects,
  });

  Student copyWith({
    String? id,
    String? name,
    String? major,
    String? university,
    String? academicYear,
    String? email,
    String? careerPathId,
    String? gpa,
    List<Skill>? skills,
    List<SoftSkill>? softSkills,
    List<Certificate>? certificates,
    List<Project>? projects,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      major: major ?? this.major,
      university: university ?? this.university,
      academicYear: academicYear ?? this.academicYear,
      email: email ?? this.email,
      careerPathId: careerPathId ?? this.careerPathId,
      gpa: gpa ?? this.gpa,
      skills: skills ?? this.skills,
      softSkills: softSkills ?? this.softSkills,
      certificates: certificates ?? this.certificates,
      projects: projects ?? this.projects,
    );
  }
}