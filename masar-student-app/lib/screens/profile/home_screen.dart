import 'package:flutter/material.dart';
import 'package:masar_student_app/data/masar_mock_data.dart';
import 'package:masar_student_app/theme/masar_theme.dart';
import 'package:masar_student_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:masar_student_app/screens/profile/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MasarMockData.profileMockData;



final internship =
    MasarMockData
        .internshipOpportunities
        .first;

    return Scaffold(
      backgroundColor:
          MasarColors.background,

      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,

          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [

                // =========================
                // Header
                // =========================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            'مرحبًا بك في مسار، ${profile['name']}',
                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  MasarColors.darkBlue,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            'مسارك المهني: ${profile['careerPath']}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: MasarColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationsScreen(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.notifications_none,
                        size: 28,
                        color:
                            MasarColors.darkBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // =========================
                // Career Assessment
                // =========================

                _HomeCard(
                  color:
                      MasarColors.lightBlue,

                  icon: Icons
                      .track_changes_outlined,

                  iconColor:
                      MasarColors.primaryGreen,

                  title:
                      'تقييمك المهني',

                  description:
                      'اكتشف نقاط قوتك والفجوات في مهاراتك.',

                  buttonText:
                      'ابدأ التقييم',

                  buttonColor:
                      MasarColors.primaryBlue,

                  onPressed: () {
                    // Skill assessment screen
                    // will be connected later.
                  },
                ),

                const SizedBox(height: 20),

                // =========================
                // Recommended Opportunity
                // =========================

                const Text(
                  'فرصة مقترحة لك',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        MasarColors.darkBlue,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(18),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                10,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: MasarColors
                                    .lightGreen,
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),

                              child: const Icon(
                                Icons.work_outline,
                                color:
                                    MasarColors
                                        .primaryGreen,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    internship.title,
                                    style:
                                        const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          MasarColors
                                              .darkBlue,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    internship
                                        .companyName,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      color:
                                          MasarColors
                                              .textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: MasarColors
                                    .lightGreen,
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),

                              child: Text(
                                '${internship.matchPercentage}% تطابق',
                                style:
                                    const TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      MasarColors
                                          .darkGreen,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        OutlinedButton(
                          onPressed: () {
                            // Internship details
                            // will be connected later.
                          },

                          child:
                              const Text(
                            'عرض الفرصة',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // Progress
                // =========================

                const Text(
                  'تقدمك',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        MasarColors.darkBlue,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(18),

                    child: Row(
                      children: [

                        Expanded(
                          child: _ProgressItem(
                            title: 'المهارات',
                            value: '62%',
                          ),
                        ),

                        Expanded(
                          child: _ProgressItem(
                            title: 'المشاريع',
                            value: '3',
                          ),
                        ),

                        Expanded(
                          child: _ProgressItem(
                            title: 'الشهادات',
                            value: '2',
                          ),
                        ),

                        Expanded(
                          child: _ProgressItem(
                            title:
                                'الملف الشخصي',
                            value: '90%',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // Next Step
                // =========================

                _HomeCard(
                  color:
                      MasarColors.lightGreen,

                  icon: Icons.trending_up,

                  iconColor:
                      MasarColors.primaryGreen,

                  title:
                      'خطوتك التالية',

                  description:
                      'طوّر مهارة SQL\nإنها إحدى المهارات التي تحتاجها لمسارك المهني.',

                  buttonText:
                      'عرض المسار',

                  buttonColor:
                      MasarColors.primaryGreen,

                  onPressed: () {
                    // Roadmap screen
                    // will be connected later.
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // =========================
      // Bottom Navigation
      // =========================

      bottomNavigationBar: const AppBottomNavBar(
        selectedIndex: 0,
      ),
    );
  }
}

// ======================================================
// Reusable Home Card
// ======================================================

class _HomeCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const _HomeCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,

      child: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Icon(
              icon,
              size: 30,
              color: iconColor,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
                color:
                    MasarColors.darkBlue,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color:
                    MasarColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor,
                ),
                child: Text(
                  buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ======================================================
// Progress Item
// ======================================================

class _ProgressItem extends StatelessWidget {
  final String title;
  final String value;

  const _ProgressItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
            color:
                MasarColors.primaryBlue,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color:
                MasarColors.textSecondary,
          ),
        ),
      ],
    );
  }
}