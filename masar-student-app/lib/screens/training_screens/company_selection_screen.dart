import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../theme/masar_theme.dart';
import 'my_applications_screen.dart';
import 'saved_training_screen.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({super.key});

  @override
  State<SelectCompanyScreen> createState() =>
      _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String? _selectedTrainingTrack;
  String? _selectedLocation;

  static const List<String> _trainingTracks = [
    'تطوير تطبيقات الموبايل',
    'تطوير الواجهات الأمامية',
    'تطوير الباكند',
    'تطوير الويب المتكامل',
    'تحليل البيانات',
    'علم البيانات',
    'الذكاء الاصطناعي وتعلم الآلة',
    'الأمن السيبراني',
    'الشبكات',
    'الحوسبة السحابية وDevOps',
    'ضمان الجودة واختبار البرمجيات',
    'تصميم UI/UX',
    'إدارة قواعد البيانات',
  ];

  static const List<String> _locations = [
    'عمّان',
    'إربد',
    'الزرقاء',
    'البلقاء',
    'مادبا',
    'الكرك',
    'الطفيلة',
    'معان',
    'العقبة',
    'جرش',
    'عجلون',
    'المفرق',
  ];

  bool get _hasActiveFilters {
    return _selectedTrainingTrack != null ||
        _selectedLocation != null ||
        _searchController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openApplications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyApplicationsScreen(),
      ),
    );
  }

  void _openSavedTraining() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SavedTrainingScreen(),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedTrainingTrack = null;
      _selectedLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 14),
                  _buildTrainingActions(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 14),
                  _buildFilterSection(),
                  if (_hasActiveFilters) ...[
                    const SizedBox(height: 8),
                    _buildClearFiltersButton(),
                  ],
                  const SizedBox(height: 24),
                  _buildRecommendedSection(),
                  const SizedBox(height: 24),
                  _buildAllOffersSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 2,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: MasarColors.textPrimary,
                size: 20,
              ),
              tooltip: 'العودة للرئيسية',
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'التدريب الميداني',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'اكتشف فرص التدريب وتعرّف على ما يمكنك تعلمه.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'طلباتي',
            icon: Icons.description_outlined,
            onPressed: _openApplications,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            title: 'المحفوظات',
            icon: Icons.bookmark_rounded,
            onPressed: _openSavedTraining,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 19,
        color: MasarColors.primaryBlue,
      ),
      label: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: MasarColors.primaryBlue,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: MasarColors.lightBlue,
        foregroundColor: MasarColors.primaryBlue,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        side: const BorderSide(
          color: MasarColors.primaryBlue,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن شركة أو فرصة تدريب...',
          hintStyle: const TextStyle(
            color: MasarColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: MasarColors.textSecondary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: MasarColors.textSecondary,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownFilter(
            label: 'المجال',
            icon: Icons.route_outlined,
            value: _selectedTrainingTrack,
            items: _trainingTracks,
            onChanged: (value) {
              setState(() {
                _selectedTrainingTrack = value;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdownFilter(
            label: 'المحافظة',
            icon: Icons.location_on_outlined,
            value: _selectedLocation,
            items: _locations,
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: value != null
              ? MasarColors.primaryBlue
              : MasarColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: MasarColors.textSecondary,
          ),
          hint: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: MasarColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MasarColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          style: const TextStyle(
            fontSize: 12,
            color: MasarColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: _clearFilters,
        icon: const Icon(
          Icons.close,
          size: 15,
        ),
        label: const Text(
          'مسح الفلاتر',
          style: TextStyle(fontSize: 12),
        ),
        style: TextButton.styleFrom(
          foregroundColor: MasarColors.primaryBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'فرص مناسبة لمسارك',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'هنا تظهر فرص التدريب المرتبطة بمسارك المهني.',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: MasarColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        _buildUnavailableCard(
          icon: Icons.route_outlined,
          message: 'لم تُحمّل الفرص المناسبة لمسارك بعد.',
        ),
      ],
    );
  }

  Widget _buildAllOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'جميع فرص التدريب',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildUnavailableCard(
          icon: Icons.business_outlined,
          message: 'لم تُحمّل فرص التدريب بعد.',
        ),
      ],
    );
  }

  Widget _buildUnavailableCard({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 36,
            color: MasarColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}