import 'package:flutter/material.dart';
import 'saved_training_screen.dart';
import '../../../theme/masar_theme.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import 'company_details_screen.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({super.key});

  @override
  State<SelectCompanyScreen> createState() =>
      _SelectCompanyScreenState();
}

class _SelectCompanyScreenState
    extends State<SelectCompanyScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  // ============================================================
  // SEARCH STATE
  // ============================================================

  bool _isSearching = false;

  // ============================================================
  // FILTER VALUES
  // ============================================================

  String? _selectedSpecialization;
  String? _selectedTrainingTrack;
  String? _selectedLocation;

  // ============================================================
  // FILTER OPTIONS
  // ============================================================

  final List<String> _specializations = const [
    'علم الحاسوب',
    'هندسة البرمجيات',
    'علم البيانات',
    'نظم المعلومات',
    'هندسة الحاسوب',
    'الأمن السيبراني',
  ];

  final List<String> _trainingTracks = const [
    'Database',
    'Data Analysis',
    'Artificial Intelligence',
    'Machine Learning',
    'Web Development',
    'Software Development',
    'Cybersecurity',
    'Mobile Development',
  ];

  final List<String> _locations = const [
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

  // ============================================================
  // COMPANIES MOCK DATA
  // ============================================================

  final List<Map<String, dynamic>> _companies = const [
    {
      'name': 'Meta',
      'slogan': 'شريك في بناء المستقبل',
      'interns': '+50 متدرب',
      'category': 'تقنية',
      'location': 'عمّان',
      'icon': Icons.all_inclusive,
      'iconColor': Color(0xFF0081FB),
      'bgColor': Colors.white,
      'specializations': [
        'علم الحاسوب',
        'هندسة البرمجيات',
        'علم البيانات',
        'هندسة الحاسوب',
      ],
      'trainingTracks': [
        'Data Analysis',
        'Artificial Intelligence',
        'Machine Learning',
        'Software Development',
        'Web Development',
      ],
    },
    {
      'name': 'Orange',
      'slogan': 'فرص أكبر لغد أذكى',
      'interns': '+30 متدرب',
      'category': 'اتصالات',
      'location': 'عمّان',
      'icon': Icons.square,
      'iconColor': Color(0xFFFF6600),
      'bgColor': Color(0xFFFF6600),
      'specializations': [
        'علم الحاسوب',
        'هندسة البرمجيات',
        'هندسة الحاسوب',
        'نظم المعلومات',
      ],
      'trainingTracks': [
        'Database',
        'Software Development',
        'Web Development',
        'Cybersecurity',
        'Mobile Development',
      ],
    },
    {
      'name': 'Microsoft',
      'slogan': 'تمكين كل شخص وكل مؤسسة',
      'interns': '+40 متدرب',
      'category': 'تقنية',
      'location': 'عمّان',
      'isMicrosoft': true,
      'bgColor': Colors.white,
      'specializations': [
        'علم الحاسوب',
        'هندسة البرمجيات',
        'علم البيانات',
        'هندسة الحاسوب',
        'نظم المعلومات',
      ],
      'trainingTracks': [
        'Artificial Intelligence',
        'Machine Learning',
        'Data Analysis',
        'Software Development',
        'Web Development',
      ],
    },
    {
      'name': 'البنك العربي',
      'slogan': 'معاً نحو مستقبل أفضل',
      'interns': '+25 متدرب',
      'category': 'بنوك وخدمات مالية',
      'location': 'عمّان',
      'isArabBank': true,
      'bgColor': Color(0xFF003366),
      'specializations': [
        'علم الحاسوب',
        'نظم المعلومات',
        'علم البيانات',
        'هندسة الحاسوب',
      ],
      'trainingTracks': [
        'Database',
        'Data Analysis',
        'Cybersecurity',
        'Software Development',
      ],
    },
    {
      'name': 'Zain',
      'slogan': 'عالم أجمل ممكن',
      'interns': '+35 متدرب',
      'category': 'اتصالات',
      'location': 'عمّان',
      'isZain': true,
      'bgColor': Colors.white,
      'specializations': [
        'علم الحاسوب',
        'هندسة البرمجيات',
        'هندسة الحاسوب',
        'نظم المعلومات',
      ],
      'trainingTracks': [
        'Database',
        'Software Development',
        'Web Development',
        'Mobile Development',
        'Cybersecurity',
      ],
    },
    {
      'name': 'amazon',
      'slogan': 'ابتكار اليوم من أجل غد أفضل',
      'interns': '+40 متدرب',
      'category': 'تقنية',
      'location': 'عمّان / عن بعد',
      'isAmazon': true,
      'bgColor': Colors.white,
      'specializations': [
        'علم الحاسوب',
        'هندسة البرمجيات',
        'علم البيانات',
        'هندسة الحاسوب',
      ],
      'trainingTracks': [
        'Database',
        'Data Analysis',
        'Artificial Intelligence',
        'Machine Learning',
        'Software Development',
        'Web Development',
      ],
    },
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (!mounted) return;

      setState(() {});
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTERED COMPANIES
  // ============================================================

  List<Map<String, dynamic>> get _filteredCompanies {
    if (_isSearching &&
        _searchController.text.trim().isEmpty) {
      return [];
    }

    final String searchText =
        _searchController.text.trim().toLowerCase();

    return _companies.where((company) {
      // --------------------------------------------------------
      // SEARCH
      // --------------------------------------------------------

      final String companyName =
          company['name'].toString().toLowerCase();

      final String slogan =
          company['slogan'].toString().toLowerCase();

      final bool matchesSearch =
          !_isSearching ||
          searchText.isEmpty ||
          companyName.contains(searchText) ||
          slogan.contains(searchText);

      // --------------------------------------------------------
      // SPECIALIZATION
      // --------------------------------------------------------

      final List<dynamic> specializations =
          company['specializations'] ?? [];

      final bool matchesSpecialization =
          _selectedSpecialization == null ||
          specializations.contains(
            _selectedSpecialization,
          );

      // --------------------------------------------------------
      // TRAINING TRACK
      // --------------------------------------------------------

      final List<dynamic> trainingTracks =
          company['trainingTracks'] ?? [];

      final bool matchesTrainingTrack =
          _selectedTrainingTrack == null ||
          trainingTracks.contains(
            _selectedTrainingTrack,
          );

      // --------------------------------------------------------
      // LOCATION
      // --------------------------------------------------------

      final String companyLocation =
          company['location'].toString();

      final bool matchesLocation =
          _selectedLocation == null ||
          companyLocation.contains(
            _selectedLocation!,
          );

      return matchesSearch &&
          matchesSpecialization &&
          matchesTrainingTrack &&
          matchesLocation;
    }).toList();
  }

  // ============================================================
  // ACTIVE FILTERS
  // ============================================================

  bool get _hasActiveFilters {
    return _selectedSpecialization != null ||
        _selectedTrainingTrack != null ||
        _selectedLocation != null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final companies = _filteredCompanies;

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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),

                  const SizedBox(height: 14),

                  // ==================================================
                  // SAVED TRAINING BUTTON
                  // ==================================================

                  _buildSavedTrainingButton(),

                  const SizedBox(height: 16),

                  _buildSearchBar(),

                  const SizedBox(height: 14),

                  _buildFilterSection(),

                  if (_hasActiveFilters) ...[
                    const SizedBox(height: 8),
                    _buildClearFiltersButton(),
                  ],

                  const SizedBox(height: 16),

                  if (companies.isEmpty)
                    _buildEmptyState()
                  else
                    Column(
                      children: companies
                          .map(
                            (company) =>
                                _buildCompanyCard(company),
                          )
                          .toList(),
                    ),

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

  // ============================================================
  // TITLE
  // ============================================================

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'التدريب الميداني',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: MasarColors.textPrimary,
          ),
        ),

        SizedBox(height: 4),

        Text(
          'اكتشف الشركات المتاحة للتدريب في مجال تخصصك',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SAVED TRAINING BUTTON
  // ============================================================

  Widget _buildSavedTrainingButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const SavedTrainingScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.bookmark_rounded,
          size: 20,
          color: MasarColors.primaryBlue,
        ),
        label: const Text(
          'المحفوظات',
          style: TextStyle(
            fontSize: 14,
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
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

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

        onChanged: (value) {
          setState(() {
            _isSearching = true;
          });
        },

        decoration: InputDecoration(
          hintText: 'ابحث عن شركة ...',
          hintStyle: const TextStyle(
            color: MasarColors.textSecondary,
            fontSize: 13,
          ),

          prefixIcon: const Icon(
            Icons.search,
            color: MasarColors.textSecondary,
            size: 20,
          ),

          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _isSearching = true;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color:
                            MasarColors.textSecondary,
                      ),
                    )
                  : null,

          border: InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER SECTION
  // ============================================================

  Widget _buildFilterSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownFilter(
            label: 'التخصص',
            icon: Icons.school_outlined,
            value: _selectedSpecialization,
            items: _specializations,
            onChanged: (value) {
              setState(() {
                _selectedSpecialization = value;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildDropdownFilter(
            label: 'المسار',
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
            label: 'الموقع',
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

  // ============================================================
  // DROPDOWN
  // ============================================================

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
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(11),
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

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color:
                MasarColors.textSecondary,
          ),

          hint: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color:
                    MasarColors.textSecondary,
              ),

              const SizedBox(width: 4),

              Flexible(
                child: Text(
                  label,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color:
                        MasarColors.textPrimary,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          style: const TextStyle(
            fontSize: 10.5,
            color:
                MasarColors.textPrimary,
            fontWeight:
                FontWeight.w500,
          ),

          dropdownColor: Colors.white,

          borderRadius:
              BorderRadius.circular(12),

          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow:
                    TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  Widget _buildClearFiltersButton() {
    return Align(
      alignment:
          AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _selectedSpecialization =
                null;
            _selectedTrainingTrack =
                null;
            _selectedLocation = null;
          });
        },

        icon: const Icon(
          Icons.close,
          size: 15,
        ),

        label: const Text(
          'مسح الفلاتر',
          style: TextStyle(
            fontSize: 12,
          ),
        ),

        style: TextButton.styleFrom(
          foregroundColor:
              MasarColors.primaryBlue,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    final bool searchHasText =
        _searchController.text
            .trim()
            .isNotEmpty;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            searchHasText
                ? Icons.search_off_rounded
                : Icons.business_outlined,
            size: 42,
            color:
                MasarColors.textSecondary,
          ),

          const SizedBox(height: 12),

          Text(
            searchHasText
                ? 'لم يتم العثور على الشركة'
                : 'لا توجد شركات مطابقة',
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
              color:
                  MasarColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            searchHasText
                ? 'تأكد من اسم الشركة أو جرّب البحث باسم آخر.'
                : 'جرّب تغيير التخصص أو المسار التدريبي أو الموقع.',
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color:
                  MasarColors.textSecondary,
            ),
          ),

          if (searchHasText ||
              _isSearching) ...[
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _isSearching = false;
                });
              },

              icon: const Icon(
                Icons.business_outlined,
                size: 17,
              ),

              label: const Text(
                'عرض كل الشركات',
              ),

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    MasarColors.primaryBlue,
                side: const BorderSide(
                  color:
                      MasarColors.primaryBlue,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    9,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // COMPANY CARD
  // ============================================================

  Widget _buildCompanyCard(
    Map<String, dynamic> company,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: MasarColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          // ====================================================
          // LOGO
          // ====================================================

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  company['bgColor'] ??
                      Colors.white,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                color:
                    MasarColors.border,
              ),
            ),
            child: Center(
              child:
                  _buildCustomCompanyLogo(
                company,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ====================================================
          // INFO
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  company['name'],
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                    color:
                        MasarColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  company['slogan'],
                  style:
                      const TextStyle(
                    fontSize: 11,
                    color:
                        MasarColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildInfoBadge(
                      Icons
                          .people_outline_rounded,
                      company['interns'],
                    ),

                    _buildInfoBadge(
                      Icons
                          .business_outlined,
                      company['category'],
                    ),

                    _buildInfoBadge(
                      Icons
                          .location_on_outlined,
                      company['location'],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ====================================================
          // CHOOSE COMPANY
          // ====================================================

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CompanyDetailsScreen(
                    company: company,
                  ),
                ),
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  MasarColors.lightBlue,
              foregroundColor:
                  MasarColors.primaryBlue,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              minimumSize:
                  Size.zero,
              tapTargetSize:
                  MaterialTapTargetSize
                      .shrinkWrap,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  8,
                ),
              ),
            ),

            child: const Text(
              'اختر الشركة',
              style: TextStyle(
                color:
                    MasarColors.primaryBlue,
                fontSize: 11,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPANY LOGOS
  // ============================================================

  Widget _buildCustomCompanyLogo(
    Map<String, dynamic> company,
  ) {
    // ----------------------------------------------------------
    // ZAIN
    // ----------------------------------------------------------

    if (company['isZain'] == true ||
        company['name'] == 'Zain') {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(
              painter:
                  _ZainRealLogoPainter(),
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'zain',
            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  FontWeight.w900,
              color:
                  MasarColors.textPrimary,
              letterSpacing: 0.5,
              fontStyle:
                  FontStyle.italic,
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------------------
    // MICROSOFT
    // ----------------------------------------------------------

    if (company['isMicrosoft'] == true) {
      return SizedBox(
        width: 24,
        height: 24,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          physics:
              const NeverScrollableScrollPhysics(),
          children: [
            Container(
              color:
                  const Color(0xFFF25022),
            ),
            Container(
              color:
                  const Color(0xFF7FBA00),
            ),
            Container(
              color:
                  const Color(0xFF00A4EF),
            ),
            Container(
              color:
                  const Color(0xFFFFB900),
            ),
          ],
        ),
      );
    }

    // ----------------------------------------------------------
    // AMAZON
    // ----------------------------------------------------------

    if (company['isAmazon'] == true) {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Text(
            'a',
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.w900,
              color: Colors.black,
              height: 0.9,
            ),
          ),

          Container(
            width: 16,
            height: 3,
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFFF9900),
              borderRadius:
                  BorderRadius.circular(2),
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------------------
    // ARAB BANK
    // ----------------------------------------------------------

    if (company['isArabBank'] == true) {
      return const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 24,
          ),

          SizedBox(height: 1),

          Text(
            'ARAB BANK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 5.5,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------------------
    // META / ORANGE
    // ----------------------------------------------------------

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          company['icon'] as IconData? ??
              Icons.business,
          color:
              company['iconColor'] ??
                  MasarColors
                      .primaryBlue,
          size: 22,
        ),

        const SizedBox(height: 2),

        Text(
          company['name'] ?? '',
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 9,
            color: company['bgColor'] ==
                    const Color(
                      0xFFFF6600,
                    )
                ? Colors.white
                : MasarColors
                    .textPrimary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO BADGE
  // ============================================================

  Widget _buildInfoBadge(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color:
              MasarColors.textSecondary,
        ),

        const SizedBox(width: 2),

        Text(
          text,
          style:
              const TextStyle(
            fontSize: 10,
            color:
                MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// ZAIN LOGO PAINTER
// ================================================================

class _ZainRealLogoPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    final gradient =
        const SweepGradient(
      colors: [
        Color(0xFF8B5CF6),
        Color(0xFFEC4899),
        Color(0xFF06B6D4),
        Color(0xFF10B981),
        Color(0xFF8B5CF6),
      ],
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(rect)
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap =
          StrokeCap.round;

    final path = Path();

    path.moveTo(
      size.width * 0.2,
      size.height * 0.8,
    );

    path.cubicTo(
      size.width * 0.05,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.05,
      size.width * 0.8,
      size.height * 0.35,
    );

    path.cubicTo(
      size.width * 0.9,
      size.height * 0.65,
      size.width * 0.3,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.5,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}