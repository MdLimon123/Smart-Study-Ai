import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/base/custom_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_extension/controller/ai_chat_controller.dart';

class AiPersonalization extends StatefulWidget {
  const AiPersonalization({super.key});

  @override
  State<AiPersonalization> createState() => _AiPersonalizationState();
}

class _AiPersonalizationState extends State<AiPersonalization> {
  late final ProfileController _profileController;

  static const List<String> _modelApiIds = [
    'gpt-4o',
    'gemini-pro',
    'claude-3-5-sonnet',
    'qqai',
  ];

  static const List<String> _responseStyleApi = [
    'concise',
    'balanced',
    'detailed',
    'formal',
  ];

  static const List<String> _difficultyApi = [
    'beginner',
    'intermediate',
    'advanced',
    'expert',
  ];

  bool _autoSelect = false;
  int _selectedModel = 0;
  int _selectedStyle = 1;
  double _difficultyLevel = 1;
  String _selectedLanguage = "English";
  final List<String> _selectedSubjects = ["Mathematics", "Physics"];

  final List<String> _difficultyLabels = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Expert",
  ];

  final List<String> _languages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Arabic",
    "Mandarin",
    "Hindi",
    "Portuguese",
  ];

  final List<String> _subjects = [
    "All Subjects",
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "History",
    "CS",
    "Literature",
    "Economics",
  ];

  final List<IconData> _subjectIcons = [
    Icons.all_inclusive_rounded,
    Icons.functions,
    Icons.bolt,
    Icons.science,
    Icons.biotech,
    Icons.history_edu,
    Icons.computer,
    Icons.menu_book,
    Icons.trending_up,
  ];

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
    _loadSavedPreferences();
    _fetchFreshPreferences();
  }

  Future<void> _fetchFreshPreferences() async {
    await _profileController.fetchAiPersonalization();
    if (mounted) {
      setState(() {
        _loadSavedPreferences();
      });
    }
  }

  String _slugToSubject(String slug) {
    switch (slug.toLowerCase()) {
      case 'all_subjects':
        return 'All Subjects';
      case 'mathematics':
        return 'Mathematics';
      case 'physics':
        return 'Physics';
      case 'chemistry':
        return 'Chemistry';
      case 'biology':
        return 'Biology';
      case 'history':
        return 'History';
      case 'cs':
        return 'CS';
      case 'literature':
        return 'Literature';
      case 'economics':
        return 'Economics';
      default:
        return slug.capitalizeFirst ?? slug;
    }
  }

  void _loadSavedPreferences() {
    final prefs = _profileController.personalization.value;
    if (prefs != null) {
      final modelIdx = _modelApiIds.indexOf(prefs.model);
      if (modelIdx != -1) {
        _selectedModel = modelIdx;
      }
      final styleIdx = _responseStyleApi.indexOf(prefs.responseStyle);
      if (styleIdx != -1) {
        _selectedStyle = styleIdx;
      }
      final diffIdx = _difficultyApi.indexOf(prefs.difficultyLevel);
      if (diffIdx != -1) {
        _difficultyLevel = diffIdx.toDouble();
      }

      final parsedLanguage = _languages.firstWhere(
        (lang) => lang.toLowerCase() == prefs.language.toLowerCase(),
        orElse: () => "English",
      );
      _selectedLanguage = parsedLanguage;

      if (prefs.subjectFocusArea.isNotEmpty) {
        _selectedSubjects.clear();
        final slugs = prefs.subjectFocusArea.split(',');
        for (var slug in slugs) {
          if (slug.trim().isNotEmpty) {
            _selectedSubjects.add(_slugToSubject(slug.trim()));
          }
        }
      }
    }
  }

  String _subjectToSlug(String label) {
    switch (label) {
      case 'All Subjects':
        return 'all_subjects';
      case 'Mathematics':
        return 'mathematics';
      case 'Physics':
        return 'physics';
      case 'Chemistry':
        return 'chemistry';
      case 'Biology':
        return 'biology';
      case 'History':
        return 'history';
      case 'CS':
        return 'cs';
      case 'Literature':
        return 'literature';
      case 'Economics':
        return 'economics';
      default:
        return label.toLowerCase().replaceAll(' ', '_');
    }
  }

  Future<void> _savePreferences() async {
    if (_selectedSubjects.isEmpty) {
      showCustomSnackBar('Select at least one subject focus area', isError: true);
      return;
    }
    final modelIdx = _selectedModel.clamp(0, _modelApiIds.length - 1);
    final styleIdx = _selectedStyle.clamp(0, _responseStyleApi.length - 1);
    final diffIdx = _difficultyLevel.round().clamp(0, _difficultyApi.length - 1);
    await _profileController.saveAiPersonalization(
      model: _modelApiIds[modelIdx],
      responseStyle: _responseStyleApi[styleIdx],
      difficultyLevel: _difficultyApi[diffIdx],
      language: _selectedLanguage.toLowerCase(),
      subjectFocusArea:
          _selectedSubjects.map(_subjectToSlug).join(','),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                ),
                child: Center(
                  child: Icon(Icons.arrow_back, color: AppColors.textColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Personalization",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'Tailor your AI experience',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
     
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto-select model
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFA78BFA).withValues(alpha: 0.12),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icon/model.svg'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Auto-select model",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "QQA picks the best model per query",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor.withValues(
                                alpha: 0.40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomSwitch(
                      value: _autoSelect,
                      onChanged: (val) {
                        setState(() {
                          _autoSelect = val;
                        });
                        try {
                          final chatCtrl = Get.find<AiChatController>();
                          if (val) {
                            chatCtrl.selectModel(0); // Index 0 is Auto-select
                          } else {
                            if (chatCtrl.selectedIndex.value == 0) {
                              chatCtrl.selectModel(1); // Revert to GPT-4o if turning off
                            }
                          }
                        } catch (_) {}
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Preferred AI Model
              Text(
                "Preferred AI Model",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),

              _modelCard(
                icon: "assets/images/gpt_fill.png",
                index: 0,
                title: "GPT 4o",
                badgeText: "OpenAI",
                badgeColor: const Color(0xFF34D399),
                subtitle: "Best for complex reasoning & long answers",
              ),
              const SizedBox(height: 10),
              _modelCard(
                icon: "assets/images/gemini_fill.png",
                index: 1,
                title: "Gemini Pro",
                badgeText: "Google",
                badgeColor: const Color(0xFF60A5FA),
                subtitle: "Excellent for math, code, and multi-modal\ntasks",
              ),
              const SizedBox(height: 10),
              _modelCard(
                icon: "assets/images/claude.jpg",
                index: 2,
                title: "Claude 3.5",
                badgeText: "Anthropic",
                badgeColor: const Color(0xFFF59E0B),
                subtitle: "Great for writing, analysis & nuanced\nanswers",
              ),
                    const SizedBox(height: 10),
              _modelCard(
                icon: "assets/images/app_logo.png",
                index: 3,
                title: " QQAI",
                badgeText: "QQA",
                badgeColor: const Color(0xFFF59E0B),
                subtitle: "Quick, Accurate & Always Improving",
              ),

              const SizedBox(height: 24),

              // Response Style
              Text(
                "Response Style",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _styleChip(
                    index: 0,
                    icon: Icons.bolt,
                    label: "Concise",
                    subtitle: "Short & to the point",
                  ),
                  const SizedBox(width: 10),
                  _styleChip(
                    index: 1,
                    icon: Icons.balance,
                    label: "Balanced",
                    subtitle: "Clear with context",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _styleChip(
                    index: 2,
                    icon: Icons.description,
                    label: "Detailed",
                    subtitle: "Full explanation",
                  ),
                  const SizedBox(width: 10),
                  _styleChip(
                    index: 3,
                    icon: Icons.school,
                    label: "Formal",
                    subtitle: "Academic tone",
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Difficulty Level
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Difficulty Level",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    _difficultyLabels[_difficultyLevel.round()],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA78BFA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFA78BFA),
                  inactiveTrackColor: AppColors.textColor.withValues(
                    alpha: 0.10,
                  ),
                  thumbColor: const Color(0xFFA78BFA),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  trackHeight: 4,
                  overlayColor: const Color(0xFFA78BFA).withValues(alpha: 0.20),
                ),
                child: Slider(
                  value: _difficultyLevel,
                  min: 0,
                  max: 3,
                  divisions: 3,
                  onChanged: (val) {
                    setState(() {
                      _difficultyLevel = val;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _difficultyLabels
                      .map(
                        (label) => Text(
                          label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor.withValues(alpha: 0.35),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // // Language
              // Text(
              //   "Language",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.textColor,
              //   ),
              // ),
              // const SizedBox(height: 12),

              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 4,
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     color: AppColors.textColor.withValues(alpha: 0.04),
              //     border: Border.all(
              //       color: AppColors.textColor.withValues(alpha: 0.07),
              //     ),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       value: _selectedLanguage,
              //       dropdownColor: AppColors.cardColor,
              //       icon: Icon(
              //         Icons.keyboard_arrow_down,
              //         color: AppColors.textColor.withValues(alpha: 0.50),
              //       ),
              //       isExpanded: true,
              //       items:
              //           [
              //                 "English",
              //                 "Spanish",
              //                 "French",
              //                 "German",
              //                 "Arabic",
              //                 "Mandarin",
              //                 "Hindi",
              //                 "Portuguese",
              //               ]
              //               .map(
              //                 (lang) => DropdownMenuItem(
              //                   value: lang,
              //                   child: Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.language,
              //                         color: Color(0xFFA78BFA),
              //                         size: 18,
              //                       ),
              //                       const SizedBox(width: 10),
              //                       Text(
              //                         lang,
              //                         style: TextStyle(
              //                           fontSize: 14,
              //                           color: AppColors.textColor,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //               .toList(),
              //       onChanged: (val) {
              //         setState(() {
              //           _selectedLanguage = val!;
              //         });
              //       },
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 12),

              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: _languages.map((lang) {
              //     final isSelected = _selectedLanguage == lang;
              //     return InkWell(
              //       onTap: () {
              //         setState(() {
              //           _selectedLanguage = lang;
              //         });
              //       },
              //       borderRadius: BorderRadius.circular(20),
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 16,
              //           vertical: 8,
              //         ),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: isSelected
              //               ? const Color(0xFFA78BFA).withValues(alpha: 0.15)
              //               : AppColors.textColor.withValues(alpha: 0.04),
              //           border: Border.all(
              //             color: isSelected
              //                 ? const Color(0xFFA78BFA).withValues(alpha: 0.40)
              //                 : AppColors.textColor.withValues(alpha: 0.07),
              //           ),
              //         ),
              //         child: Text(
              //           lang,
              //           style: TextStyle(
              //             fontSize: 12,
              //             fontWeight: FontWeight.w500,
              //             color: isSelected
              //                 ? const Color(0xFFA78BFA)
              //                 : AppColors.textColor.withValues(alpha: 0.50),
              //           ),
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),

              // const SizedBox(height: 24),

              // Subject Focus Area
              Text(
                "Subject Focus Area",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_subjects.length, (i) {
                  final isSelected = _selectedSubjects.contains(_subjects[i]);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (_subjects[i] == "All Subjects") {
                          if (isSelected) {
                            _selectedSubjects.remove("All Subjects");
                          } else {
                            _selectedSubjects.clear();
                            _selectedSubjects.add("All Subjects");
                          }
                        } else {
                          if (isSelected) {
                            _selectedSubjects.remove(_subjects[i]);
                          } else {
                            _selectedSubjects.remove("All Subjects");
                            _selectedSubjects.add(_subjects[i]);
                          }
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? const Color(0xFFA78BFA).withValues(alpha: 0.15)
                            : AppColors.textColor.withValues(alpha: 0.04),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFA78BFA).withValues(alpha: 0.40)
                              : AppColors.textColor.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _subjectIcons[i],
                            size: 14,
                            color: isSelected
                                ? const Color(0xFFA78BFA)
                                : AppColors.textColor.withValues(alpha: 0.40),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _subjects[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFA78BFA)
                                  : AppColors.textColor.withValues(alpha: 0.50),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.check,
                              size: 14,
                              color: Color(0xFFA78BFA),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // Save Preferences Button
              Obx(
                () {
                  final loading =
                      _profileController.isAiPersonalizationLoading.value;
                  return InkWell(
                    onTap: loading ? null : _savePreferences,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (loading)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textColor,
                              ),
                            )
                          else
                            Icon(
                              Icons.check_circle_outline,
                              color: AppColors.textColor,
                              size: 20,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            loading ? 'Saving…' : 'Save Preferences',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modelCard({
    required int index,
    required String title,
    required String badgeText,
    required Color badgeColor,
    required String subtitle,
    required String icon,
  }) {
    final isSelected = !_autoSelect && _selectedModel == index;
    return Opacity(
      opacity: _autoSelect ? 0.5 : 1.0,
      child: InkWell(
        onTap: _autoSelect
            ? null
            : () {
                setState(() {
                  _selectedModel = index;
                });
              },
        borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? const Color(0xFF34D399).withValues(alpha: 0.07)
              : AppColors.textColor.withValues(alpha: 0.04),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF34D399).withValues(alpha: 0.25)
                : AppColors.textColor.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF34D399).withValues(alpha: 0.09),
              ),
              child: Center(child: Image.asset(icon)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: badgeColor.withValues(alpha: 0.15),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF34D399)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF34D399)
                      : AppColors.textColor.withValues(alpha: 0.20),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 12),
                    )
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _styleChip({
    required int index,
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    final isSelected = _selectedStyle == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStyle = index;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? const Color(0xFFA78BFA).withValues(alpha: 0.10)
                : AppColors.textColor.withValues(alpha: 0.04),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFA78BFA).withValues(alpha: 0.30)
                  : AppColors.textColor.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? const Color(0xFFA78BFA)
                    : AppColors.textColor.withValues(alpha: 0.40),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.textColor
                          : AppColors.textColor.withValues(alpha: 0.60),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
