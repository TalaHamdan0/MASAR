
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/training_service.dart';
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

  Timer? _searchDebounce;

  int? _selectedTrainingTrackId;
  String? _selectedLocation;

  List<TrainingTrack> _trainingTracks = [];
  List<TrainingOffer> _offers = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isLoadingTracks = true;

  String? _offersError;
  String? _tracksError;

  int _currentPage = 0;
  int _totalPages = 0;
  int _totalOffers = 0;
  int _requestVersion = 0;

  static const int _pageSize = 20;

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

  bool get _hasActiveFilters =>
      _selectedTrainingTrackId != null ||
      _selectedLocation != null ||
      _searchController.text.trim().isNotEmpty;

  bool get _hasMore => _currentPage < _totalPages;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _requestVersion++;
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    _loadTracks();
    await _loadOffers();
  }

  Future<void> _loadTracks() async {
    setState(() {
      _isLoadingTracks = true;
      _tracksError = null;
    });

    try {
      final tracks = await TrainingService.getTracks();

      if (!mounted) return;

      setState(() {
        _trainingTracks = tracks;
        _isLoadingTracks = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingTracks = false;
        _tracksError = _errorMessage(error);
      });
    }
  }

  String? _normalizedGovernorate() {
    if (_selectedLocation == 'عمّان') {
      return 'عمان';
    }

    return _selectedLocation;
  }

  Future<void> _loadOffers({
    bool loadMore = false,
  }) async {
    if (loadMore &&
        (_isLoading || _isLoadingMore || !_hasMore)) {
      return;
    }

    final requestId = ++_requestVersion;
    final requestedPage = loadMore ? _currentPage + 1 : 1;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
        _offersError = null;
      } else {
        _isLoading = true;
        _isLoadingMore = false;
        _offersError = null;
      }
    });

    try {
      final result = await TrainingService.getOffers(
        page: requestedPage,
        pageSize: _pageSize,
        search: _searchController.text.trim(),
        governorate: _normalizedGovernorate(),
        trackId: _selectedTrainingTrackId,
      );

      if (!mounted || requestId != _requestVersion) {
        return;
      }

      setState(() {
        if (loadMore) {
          _offers = [..._offers, ...result.offers];
        } else {
          _offers = result.offers;
        }

        _currentPage = result.page;
        _totalPages = result.totalPages;
        _totalOffers = result.total;

        _isLoading = false;
        _isLoadingMore = false;
        _offersError = null;
      });
    } catch (error) {
      if (!mounted || requestId != _requestVersion) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _offersError = _errorMessage(error);
      });
    }
  }

  String _errorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('ApiException: ')) {
      return message.substring('ApiException: '.length);
    }

    return message;
  }

  void _onSearchChanged(String value) {
    setState(() {});

    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () {
        if (mounted) {
          _loadOffers();
        }
      },
    );
  }

  void _onFiltersChanged() {
    _searchDebounce?.cancel();
    _loadOffers();
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
    _searchDebounce?.cancel();

    setState(() {
      _searchController.clear();
      _selectedTrainingTrackId = null;
      _selectedLocation = null;
    });

    _loadOffers();
  }

  // English display names for known Arabic training tracks.
  // The original Oracle track ID remains unchanged for filtering.
  String _englishTrackName(String name) {
    final original = name.trim();

    final normalized = original
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .toLowerCase();

    if (normalized.contains('امن سيبراني') ||
        normalized.contains('الامن السيبراني') ||
        normalized.contains('cyber')) {
      return 'Cybersecurity';
    }

    if (normalized.contains('ذكاء اصطناعي') ||
        normalized.contains('الذكاء الاصطناعي') ||
        normalized.contains('artificial intelligence')) {
      return 'Artificial Intelligence';
    }

    if (normalized.contains('تعلم الاله') ||
        normalized.contains('machine learning')) {
      return 'Machine Learning';
    }

    if (normalized.contains('علم البيانات') ||
        normalized.contains('data science')) {
      return 'Data Science';
    }

    if (normalized.contains('تحليل البيانات') ||
        normalized.contains('data analysis') ||
        normalized.contains('data analytics')) {
      return 'Data Analytics';
    }

    if (normalized.contains('قواعد البيانات') ||
        normalized.contains('database')) {
      return 'Database Management';
    }

    if (normalized.contains('تطوير الويب') ||
        normalized.contains('web development')) {
      return 'Web Development';
    }

    if (normalized.contains('تطوير تطبيقات الهاتف') ||
        normalized.contains('تطبيقات الموبايل') ||
        normalized.contains('mobile development')) {
      return 'Mobile Development';
    }

    if (normalized.contains('تطوير البرمجيات') ||
        normalized.contains('هندسة البرمجيات') ||
        normalized.contains('software')) {
      return 'Software Development';
    }

    if (normalized.contains('شبكات') ||
        normalized.contains('network')) {
      return 'Networking';
    }

    if (normalized.contains('حوسبة سحابية') ||
        normalized.contains('cloud')) {
      return 'Cloud Computing';
    }

    if (normalized.contains('devops')) {
      return 'DevOps';
    }

    if (normalized.contains('واجهات المستخدم') ||
        normalized.contains('تجربة المستخدم') ||
        normalized.contains('ui/ux')) {
      return 'UI/UX Design';
    }

    if (normalized.contains('اختبار البرمجيات') ||
        normalized.contains('ضمان الجودة') ||
        normalized.contains('quality assurance')) {
      return 'Software Testing / QA';
    }

    if (normalized.contains('انترنت الاشياء') ||
        normalized.contains('iot')) {
      return 'Internet of Things';
    }

    if (normalized.contains('نظم المعلومات') ||
        normalized.contains('information systems')) {
      return 'Information Systems';
    }

    if (normalized.contains('دعم فني') ||
        normalized.contains('technical support')) {
      return 'IT Support';
    }

    // Unknown names remain unchanged rather than being mistranslated.
    return original;
  }

  String _workModeEnglish(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not specified';
    }

    final normalized = value.trim().toLowerCase();

    if (normalized == 'onsite' ||
        normalized == 'on-site' ||
        normalized == 'on site' ||
        normalized == 'office' ||
        normalized == 'حضوري' ||
        normalized == 'وجاهي') {
      return 'On-site';
    }

    if (normalized == 'remote' ||
        normalized == 'online' ||
        normalized == 'عن بعد' ||
        normalized == 'عن بُعد') {
      return 'Remote';
    }

    if (normalized == 'hybrid' ||
        normalized == 'mixed' ||
        normalized == 'هجين' ||
        normalized == 'مدمج') {
      return 'Hybrid';
    }

    return value;
  }

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'غير محدد';
    }

    return value.trim();
  }

  String _offerLocation(TrainingOffer offer) {
    final values = <String>[];

    for (final value in [
      offer.governorate,
      offer.city,
    ]) {
      if (value == null || value.trim().isEmpty) {
        continue;
      }

      final normalized = value
          .replaceAll('ّ', '')
          .trim()
          .toLowerCase();

      final exists = values.any(
        (item) =>
            item.replaceAll('ّ', '').trim().toLowerCase() ==
            normalized,
      );

      if (!exists) {
        values.add(value.trim());
      }
    }

    if (values.isNotEmpty) {
      return values.join(' - ');
    }

    return _displayValue(offer.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasarColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  _loadTracks(),
                  _loadOffers(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16, 20, 16, 20,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
        border: Border.all(color: MasarColors.border),
      ),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        onChanged: _onSearchChanged,
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
                    _searchDebounce?.cancel();

                    setState(() {
                      _searchController.clear();
                    });

                    _loadOffers();
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
          child: _buildTrackDropdown(),
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

              _onFiltersChanged();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: _selectedTrainingTrackId != null
              ? MasarColors.primaryBlue
              : MasarColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedTrainingTrackId,
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
              const Icon(
                Icons.route_outlined,
                size: 16,
                color: MasarColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _isLoadingTracks
                      ? 'تحميل المجالات...'
                      : 'المجال',
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
          items: _trainingTracks.map((track) {
            return DropdownMenuItem<int>(
              value: track.id,
              child: Text(
                _englishTrackName(track.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            );
          }).toList(),
          onChanged: _trainingTracks.isEmpty
              ? null
              : (value) {
                  setState(() {
                    _selectedTrainingTrackId = value;
                  });

                  _onFiltersChanged();
                },
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
          onChanged: items.isEmpty ? null : onChanged,
        ),
      ),
    );
  }

  Widget _buildClearFiltersButton() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: _clearFilters,
        icon: const Icon(Icons.close, size: 15),
        label: const Text(
          'مسح الفلاتر',
          style: TextStyle(fontSize: 12),
        ),
        style: TextButton.styleFrom(
          foregroundColor: MasarColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 4),
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
        Row(
          children: [
            const Expanded(
              child: Text(
                'جميع فرص التدريب',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: MasarColors.textPrimary,
                ),
              ),
            ),
            if (!_isLoading && _offersError == null)
              Text(
                '$_totalOffers فرصة',
                style: const TextStyle(
                  fontSize: 12,
                  color: MasarColors.textSecondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (_tracksError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNotice(
              message: 'تعذر تحميل المجالات التدريبية.',
              onRetry: _loadTracks,
            ),
          ),

        if (_isLoading)
          _buildLoadingCard()
        else if (_offersError != null && _offers.isEmpty)
          _buildNotice(
            message: _offersError!,
            onRetry: () => _loadOffers(),
          )
        else if (_offers.isEmpty)
          _buildUnavailableCard(
            icon: Icons.business_outlined,
            message: _hasActiveFilters
                ? 'لا توجد فرص تدريب تطابق البحث أو الفلاتر المحددة.'
                : 'لا توجد فرص تدريب متاحة حاليًا.',
          )
        else ...[
          ..._offers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOfferCard(offer),
            ),
          ),

          if (_offersError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildNotice(
                message: _offersError!,
                onRetry: () =>
                    _loadOffers(loadMore: true),
              ),
            ),

          if (_hasMore) _buildLoadMoreButton(),
        ],
      ],
    );
  }

  // Updated offer card:
  // Company -> Opportunity -> Location -> Mode -> Hours -> Seats.
  Widget _buildOfferCard(TrainingOffer offer) {
    final companyName = _displayValue(offer.companyName);

    final opportunityName = offer.title.trim().isNotEmpty
        ? offer.title.trim()
        : 'فرصة تدريب';

    final location = _offerLocation(offer);

    final workMode = _workModeEnglish(offer.workMode);

    final hours = offer.requiredHours == null
        ? 'غير محدد'
        : '${offer.requiredHours} ساعة';

    final seats = offer.availableSlots == null
        ? 'غير محدد'
        : '${offer.availableSlots} مقاعد';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company name first.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MasarColors.lightBlue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  size: 23,
                  color: MasarColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MasarColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'اسم الشركة',
                      style: TextStyle(
                        fontSize: 11,
                        color: MasarColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(
            height: 1,
            color: MasarColors.border,
          ),

          const SizedBox(height: 14),

          // Training opportunity.
          const Text(
            'فرصة التدريب',
            style: TextStyle(
              fontSize: 11,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            opportunityName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: MasarColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Location and training mode.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOfferDetail(
                  icon: Icons.location_on_outlined,
                  label: 'الموقع',
                  value: location,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOfferDetail(
                  icon: Icons.laptop_outlined,
                  label: 'نوع التدريب',
                  value: workMode,
                  englishValue: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Training hours and available seats.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOfferDetail(
                  icon: Icons.access_time_outlined,
                  label: 'عدد الساعات',
                  value: hours,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOfferDetail(
                  icon: Icons.people_outline,
                  label: 'عدد المقاعد',
                  value: seats,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferDetail({
    required IconData icon,
    required String label,
    required String value,
    bool englishValue = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: MasarColors.primaryBlue,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: MasarColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textDirection: englishValue
                    ? TextDirection.ltr
                    : null,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: MasarColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoadingMore
            ? null
            : () => _loadOffers(loadMore: true),
        style: OutlinedButton.styleFrom(
          foregroundColor: MasarColors.primaryBlue,
          side: const BorderSide(
            color: MasarColors.primaryBlue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: _isLoadingMore
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'تحميل المزيد',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            color: MasarColors.primaryBlue,
          ),
          SizedBox(height: 14),
          Text(
            'جارٍ تحميل فرص التدريب...',
            style: TextStyle(
              fontSize: 13,
              color: MasarColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 30,
            color: MasarColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: MasarColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
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
