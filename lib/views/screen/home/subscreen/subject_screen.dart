import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubjectData {
  final String name;
  final String icon;
  final Color iconBgColor;
  final Color progressColor;
  final int percentage;
  final int practiceQuestions;
  final List<String> topics;

  SubjectData({
    required this.name,
    required this.icon,
    required this.iconBgColor,
    required this.progressColor,
    required this.percentage,
    required this.practiceQuestions,
    required this.topics,
  });
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();

  final List<SubjectData> subjects = [
    SubjectData(
      name: 'Mathematics',
      icon: '∫',
      iconBgColor: const Color(0xFF7C3AED),
      progressColor: const Color(0xFF397DFF),
      percentage: 72,
      practiceQuestions: 248,
      topics: ['Algebra', 'Calculus', 'Geometry', 'Statistics', 'Trigonometry'],
    ),
    SubjectData(
      name: 'Physics',
      icon: '⚡',
      iconBgColor: const Color(0xFFEAB308),
      progressColor: const Color(0xFF7C3AED),
      percentage: 58,
      practiceQuestions: 186,
      topics: ['Mechanics', 'Thermodynamics', 'Optics', 'Electromagnetism'],
    ),
    SubjectData(
      name: 'Chemistry',
      icon: '🧪',
      iconBgColor: const Color(0xFF22C55E),
      progressColor: const Color(0xFF22C55E),
      percentage: 45,
      practiceQuestions: 201,
      topics: ['Organic', 'Inorganic', 'Physical', 'Analytical'],
    ),
    SubjectData(
      name: 'Biology',
      icon: '🧬',
      iconBgColor: const Color(0xFFF97316),
      progressColor: const Color(0xFFF97316),
      percentage: 63,
      practiceQuestions: 177,
      topics: ['Cell Biology', 'Genetics', 'Ecology', 'Anatomy'],
    ),
    SubjectData(
      name: 'History',
      icon: '📚',
      iconBgColor: const Color(0xFF6366F1),
      progressColor: const Color(0xFFEF4444),
      percentage: 30,
      practiceQuestions: 142,
      topics: ['Ancient', 'Medieval', 'Modern', 'World Wars'],
    ),
    SubjectData(
      name: 'Computer Science',
      icon: '💻',
      iconBgColor: const Color(0xFF06B6D4),
      progressColor: const Color(0xFF06B6D4),
      percentage: 55,
      practiceQuestions: 195,
      topics: ['Algorithms', 'Data Structures', 'Databases', 'Networking'],
    ),
    SubjectData(
      name: 'English',
      icon: '📝',
      iconBgColor: const Color(0xFFEC4899),
      progressColor: const Color(0xFFEC4899),
      percentage: 68,
      practiceQuestions: 160,
      topics: ['Grammar', 'Literature', 'Writing', 'Vocabulary'],
    ),
    SubjectData(
      name: 'Geography',
      icon: '🌍',
      iconBgColor: const Color(0xFF14B8A6),
      progressColor: const Color(0xFF14B8A6),
      percentage: 40,
      practiceQuestions: 130,
      topics: ['Physical', 'Human', 'Cartography', 'Climate'],
    ),
  ];

  final List<Map<String, dynamic>> mostStudied = [
    {'name': 'Mathematics', 'icon': '∫', 'color': Color(0xFF7C3AED)},
    {'name': 'Computer Science', 'icon': '💻', 'color': Color(0xFF06B6D4)},
    {'name': 'Chemistry', 'icon': '🧪', 'color': Color(0xFF22C55E)},
    {'name': 'Physics', 'icon': '⚡', 'color': Color(0xFFEAB308)},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subjects",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  '${subjects.length} subjects available',
                  style: TextStyle(
                    fontSize: 12.sp,
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
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.surfaceBorder.withValues(alpha: 0.5),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search subjects...',
                    hintStyle: TextStyle(
                      color: AppColors.textColor.withValues(alpha: 0.35),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),

            // Most Studied Section
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icon/most.svg'),
                      SizedBox(width: 6.w),
                      Text(
                        'MOST STUDIED',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor.withValues(alpha: 0.50),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 38.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: mostStudied.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      padding: EdgeInsets.only(right: 16.w),
                      itemBuilder: (context, index) {
                        final item = mostStudied[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A2E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.surfaceBorder.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['icon'],
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Subject List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                itemCount: subjects.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return _buildSubjectCard(subjects[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(SubjectData subject, int index) {
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? subject.progressColor.withValues(alpha: 0.3)
                : AppColors.surfaceBorder.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            // Main row
            Row(
              children: [
                // Subject icon
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: subject.iconBgColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      subject.icon,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Name and question count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${subject.practiceQuestions} practice questions',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textColor.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),

                // Percentage
                Text(
                  '${subject.percentage}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: subject.progressColor,
                  ),
                ),
                SizedBox(width: 4.w),

                // Arrow
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textColor.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ),
              ],
            ),

            // Progress bar
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: subject.percentage / 100,
                backgroundColor: subject.progressColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                  subject.progressColor,
                ),
                minHeight: 3.5,
              ),
            ),

            // Expanded topics
            if (isExpanded) ...[
              SizedBox(height: 14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...subject.topics.map((topic) => _buildTopicChip(topic)),
                  _buildAskAiChip(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFF252540),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.surfaceBorder.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildAskAiChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.2),
            AppColors.accentSecondary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ask AI',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '→',
            style: TextStyle(fontSize: 12.sp, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
