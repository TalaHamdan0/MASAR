
class UniversityMockData {
  UniversityMockData._();

  // =========================
  // University Information
  // =========================

  static const String universityName = 'جامعة مسار';

  static const String universityAdminName = 'د. محمد العبدالله';

  static const String universityAdminId = '1001';

  // =========================
  // Login
  // =========================

  static bool validateAdminId(String id) {
    return id.trim() == universityAdminId;
  }
}

