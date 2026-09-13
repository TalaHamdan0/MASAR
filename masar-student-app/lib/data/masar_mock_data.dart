import 'package:masar_student_app/core/models/student_model.dart';
import 'package:masar_student_app/core/models/skill_model.dart';
import 'package:masar_student_app/core/models/career_path_model.dart';
import 'package:masar_student_app/core/models/soft_skill_model.dart';
import 'package:masar_student_app/core/models/certificate_model.dart';

class MasarMockData {
  // ============================================================
  // CAREER PATHS
  // ============================================================

  static const List<CareerPath> careerPaths = [
    CareerPath(
      id: 'data_analyst',
      title: 'Data Analyst',
      description:
          'تحليل البيانات واستخراج المعلومات التي تساعد في اتخاذ القرارات.',
      requiredSkills: [
        'Python',
        'SQL',
        'Excel',
        'Power BI',
        'الإحصاء',
      ],
    ),

    CareerPath(
      id: 'data_scientist',
      title: 'Data Scientist',
      description:
          'استخدام البيانات والإحصاء والتعلم الآلي لحل المشكلات والتنبؤ بالنتائج.',
      requiredSkills: [
        'Python',
        'SQL',
        'الإحصاء',
        'Machine Learning',
        'Data Visualization',
      ],
    ),

    CareerPath(
      id: 'ml_engineer',
      title: 'ML Engineer',
      description:
          'تطوير وتطبيق نماذج التعلم الآلي ودمجها داخل الأنظمة.',
      requiredSkills: [
        'Python',
        'Machine Learning',
        'Deep Learning',
        'Git',
        'APIs',
      ],
    ),
  ];

  // ============================================================
  // TECHNICAL SKILLS
  // ============================================================

  static const List<Skill> skills = [
    Skill(
      id: 'python',
      name: 'Python',
      level: 80,
      status: 'Strong',
    ),

    Skill(
      id: 'excel',
      name: 'Excel',
      level: 90,
      status: 'Strong',
    ),

    Skill(
      id: 'sql',
      name: 'SQL',
      level: 30,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'power_bi',
      name: 'Power BI',
      level: 20,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'statistics',
      name: 'الإحصاء',
      level: 40,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'machine_learning',
      name: 'Machine Learning',
      level: 25,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'data_visualization',
      name: 'Data Visualization',
      level: 45,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'deep_learning',
      name: 'Deep Learning',
      level: 10,
      status: 'Beginner',
    ),

    Skill(
      id: 'git',
      name: 'Git',
      level: 35,
      status: 'Needs Improvement',
    ),

    Skill(
      id: 'apis',
      name: 'APIs',
      level: 20,
      status: 'Needs Improvement',
    ),
  ];

  // ============================================================
  // SOFT SKILLS
  // ============================================================

  static const List<SoftSkill> softSkills = [
    SoftSkill(
      id: 'communication',
      name: 'Communication',
      level: 80,
    ),

    SoftSkill(
      id: 'teamwork',
      name: 'Teamwork',
      level: 85,
    ),

    SoftSkill(
      id: 'problem_solving',
      name: 'Problem Solving',
      level: 75,
    ),

    SoftSkill(
      id: 'time_management',
      name: 'Time Management',
      level: 70,
    ),

    SoftSkill(
      id: 'leadership',
      name: 'Leadership',
      level: 60,
    ),
  ];

  // ============================================================
  // CERTIFICATES
  // ============================================================

  static const List<Certificate> certificates = [
    Certificate(
      id: 'cert_001',
      title: 'IBM Data Science Professional Certificate',
      issuer: 'IBM',
      date: '2026-09-12',
    ),

    Certificate(
      id: 'cert_002',
      title: 'Python for Data Science',
      issuer: 'IBM',
      date: '2026-08-20',
    ),
  ];

  // ============================================================
  // STUDENT
  // ============================================================

  static const Student student = Student(
    id: 'student_001',
    name: 'ليان أحمد',
    major: 'علم البيانات',
    university: 'جامعة الأردن',
    academicYear: 'السنة الثالثة',
    email: 'layan.ahmad@masar-demo.com',
    careerPathId: 'data_analyst',
    gpa: '3.2',
    skills: skills,
    softSkills: softSkills,
    certificates: certificates,
  );

  // ============================================================
  // READINESS SCORE
  // ============================================================

  static const int readinessScore = 72;

  static const int skillsScore = 70;

  static const int projectsScore = 60;

  static const int certificationsScore = 80;

  static const int eligibilityScore = 100;

  // ============================================================
  // SELECTED CAREER PATH
  // ============================================================

  static CareerPath get selectedCareerPath {
    return careerPaths.firstWhere(
      (path) => path.id == student.careerPathId,
    );
  }

  // ============================================================
  // SKILLS FOR SELECTED CAREER PATH
  // ============================================================

  static List<Skill> get selectedCareerSkills {
    return skills
        .where(
          (skill) =>
              selectedCareerPath.requiredSkills.contains(skill.name),
        )
        .toList();
  }

  // ============================================================
  // FIND SKILL BY ID
  // ============================================================

  static Skill? getSkillById(String id) {
    try {
      return skills.firstWhere(
        (skill) => skill.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // FIND CAREER PATH BY ID
  // ============================================================

  static CareerPath? getCareerPathById(String id) {
    try {
      return careerPaths.firstWhere(
        (path) => path.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}