import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/saved_training_store.dart';
import 'company_details_screen.dart';

class SavedTrainingScreen extends StatefulWidget {
  const SavedTrainingScreen({super.key});

  @override
  State<SavedTrainingScreen> createState() => _SavedTrainingScreenState();
}

class _SavedTrainingScreenState extends State<SavedTrainingScreen> {
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color lightPurpleBg = Color(0xFFF3F0FF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final savedCompanies = SavedTrainingStore.savedCompanies;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'المحفوظات',
            style: TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: textDark,
          ),
        ),

        body: savedCompanies.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedCompanies.length,
                itemBuilder: (context, index) {
                  final company = savedCompanies[index];

                  return _buildSavedCompanyCard(company);
                },
              ),

        bottomNavigationBar: const AppBottomNavBar(
          selectedIndex: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: lightPurpleBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 45,
                color: primaryPurple,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'لا توجد شركات محفوظة',
              style: TextStyle(
                color: textDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'احفظي الشركات التي تهمك للرجوع إليها لاحقًا.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textMuted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCompanyCard(
    Map<String, dynamic> company,
  ) {
    final companyName =
        company['name']?.toString() ?? 'شركة';

    final slogan =
        company['slogan']?.toString() ?? 'فرصة تدريب ميداني';

    final location =
        company['location']?.toString() ?? 'غير محدد';

    final category =
        company['category']?.toString() ?? 'تدريب ميداني';

    final imageUrl =
        company['image']?.toString() ??
        company['imageUrl']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompanyDetailsScreen(
                company: company,
              ),
            ),
          );

          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _buildCompanyLogo(
                company,
                imageUrl,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      slogan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: textMuted,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 16,
                          color: primaryPurple,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          category,
                          style: const TextStyle(
                            color: primaryPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(
    Map<String, dynamic> company,
    String? imageUrl,
  ) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          imageUrl,
          width: 65,
          height: 65,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _fallbackLogo();
          },
        ),
      );
    }

    return _fallbackLogo();
  }

  Widget _fallbackLogo() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: lightPurpleBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.business_rounded,
        color: primaryPurple,
        size: 32,
      ),
    );
  }
}