class SavedTrainingStore {
  static final List<Map<String, dynamic>> savedCompanies = [];

  static bool isSaved(Map<String, dynamic> company) {
    final name = company['name']?.toString();

    return savedCompanies.any(
      (savedCompany) => savedCompany['name']?.toString() == name,
    );
  }

  static void toggleSaved(Map<String, dynamic> company) {
    final name = company['name']?.toString();

    final index = savedCompanies.indexWhere(
      (savedCompany) => savedCompany['name']?.toString() == name,
    );

    if (index >= 0) {
      savedCompanies.removeAt(index);
    } else {
      savedCompanies.add(company);
    }
  }
}