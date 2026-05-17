import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/ai_chat_controller.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/controller/scan_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/get_greeting.dart';
import 'package:flutter_extension/views/screen/chat/ai_chat_screen.dart';
import 'package:flutter_extension/views/screen/home/subscreen/subject_screen.dart';
import 'package:flutter_extension/views/screen/library/library_screen.dart';

import 'package:flutter_extension/views/screen/scan&solve/scan_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchScanHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ─── App Bar ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getGreeting(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Obx(() {
                      final name =
                          Get.find<ProfileController>().profile.value?.name;
                      final display =
                          (name != null && name.trim().isNotEmpty)
                              ? name.trim()
                              : 'User';
                      return Text(
                        'welcome_back'.tr.replaceAll('@name', display),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          // ─── Body ───
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      ),
                      boxShadow: AppColors.isDark ? [] : [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icon/star_fill.svg'),
                            const SizedBox(width: 6),
                            const Text(
                              "PREMIUM",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Unlock Unlimited Scans",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upgrade",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 13,
                                    color: Color(0xFF7C3AED),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Cloud storage & reports",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  Text(
                    "quick_actions".tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => const ScanScreen(
                                isActive: true,
                                controllerTag: ScanControllerTags.homeModal,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                              boxShadow: AppColors.isDark ? [] : [
                                BoxShadow(
                                  color: const Color(0xFF000000).withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/scan.svg',
                                      height: 18,
                                      width: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF7C3AED),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "scan_solve".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => const AiChatScreen(
                                controllerTag: AiChatControllerTags.homeModal,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                              boxShadow: AppColors.isDark ? [] : [
                                BoxShadow(
                                  color: const Color(0xFF000000).withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF10B981).withValues(alpha: 0.10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/chat.svg',
                                      height: 18,
                                      width: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF10B981),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "ai_chat".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const LibraryScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                              boxShadow: AppColors.isDark ? [] : [
                                BoxShadow(
                                  color: const Color(0xFF000000).withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/library.svg',
                                      height: 18,
                                      width: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFF59E0B),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "library".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const SubjectScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                              boxShadow: AppColors.isDark ? [] : [
                                BoxShadow(
                                  color: const Color(0xFF000000).withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/subject.svg',
                                      height: 18,
                                      width: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFEF4444),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "subjects".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "ai_models".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                      const Spacer(),
                      // const Text(
                      //   "Use →",
                      //   style: TextStyle(
                      //     fontSize: 13,
                      //     fontWeight: FontWeight.w500,
                      //     fontFamily: 'Lato',
                      //     color: Color(0xFFA78BFA),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.isDark
                                ? const Color(0xFF132B25)
                                : const Color(0xFFECFDF5),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "GPT-4o",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Lato',
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "General",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.cardColor,
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                            boxShadow: AppColors.isDark ? [] : [
                              BoxShadow(
                                color: const Color(0xFF000000).withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF60A5FA),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Gemini Pro",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Lato',
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Research",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.cardColor,
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                            boxShadow: AppColors.isDark ? [] : [
                              BoxShadow(
                                color: const Color(0xFF000000).withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFA78BFA),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Claude Sonnet",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Lato',
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Math",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 19),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "recent_activity".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => Get.to(() => const ScanHistoryScreen()),
                      //   borderRadius: BorderRadius.circular(8),
                      //   child: const Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 4,
                      //       vertical: 2,
                      //     ),
                      //     child: Text(
                      //       "See all",
                      //       style: TextStyle(
                      //         fontSize: 13,
                      //         fontWeight: FontWeight.w500,
                      //         fontFamily: 'Lato',
                      //         color: Color(0xFFA78BFA),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final pc = Get.find<ProfileController>();
                    if (pc.isScanHistoryLoading.value &&
                        pc.scanHistory.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFA78BFA),
                            ),
                          ),
                        ),
                      );
                    }
                    final items = pc.scanHistory.take(5).toList();
                    if (items.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'No recent activity yet',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Lato',
                            color: AppColors.textColor.withValues(alpha: 0.45),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          _recentActivitySubjectTile(
                            subject: items[i].subject,
                            index: i,
                          ),
                          if (i < items.length - 1) const SizedBox(height: 8),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Same card layout as the old `_customContainer`, but only the subject line (API `subject`).
  Widget _recentActivitySubjectTile({required String subject, required int index}) {
    // Parse category and detail
    String category = 'Scan';
    String detail = _formatSubjectLabel(subject);
    final s = subject.toLowerCase().trim();
    if (s.contains('math')) {
      category = 'Mathematics';
    } else if (s.contains('chem') || s.contains('che')) {
      category = 'Chemistry';
    } else if (s.contains('phys') || s.contains('phy')) {
      category = 'Physics';
    } else if (s.contains('bio') || s.contains('tree')) {
      category = 'Biology';
    }

    if (detail.contains(' - ')) {
      final parts = detail.split(' - ');
      category = parts[0].trim();
      detail = parts[1].trim();
    } else if (detail.contains('-')) {
      final parts = detail.split('-');
      category = parts[0].trim();
      detail = parts[1].trim();
    }

    // Generate mockup-accurate times based on index
    String timeAgo = '2h ago';
    if (index == 1) {
      timeAgo = '5h ago';
    } else if (index == 2) {
      timeAgo = 'Yesterday';
    } else if (index == 3) {
      timeAgo = '2 days ago';
    } else if (index >= 4) {
      timeAgo = '3 days ago';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.cardColor,
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
        boxShadow: AppColors.isDark ? [] : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _subjectIconWidget(subject),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectIconWidget(String rawSubject) {
    final s = rawSubject.toLowerCase().trim();
    if (s.contains('math')) {
      return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF26213A)
              : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            "√x",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F46E5),
              fontFamily: 'Lato',
            ),
          ),
        ),
      );
    }
    
    // Chemistry
    if (s.contains('chem') || s.contains('che')) {
      return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF1B2B2C)
              : const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/che.png',
            height: 22,
            width: 22,
            color: const Color(0xFF047857),
          ),
        ),
      );
    }
    
    // Physics
    if (s.contains('phys') || s.contains('phy')) {
      return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/phy.png',
            height: 22,
            width: 22,
            color: const Color(0xFF2563EB),
          ),
        ),
      );
    }
    
    // Biology
    if (s.contains('bio') || s.contains('tree')) {
      return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.isDark
              ? const Color(0xFF2D2A1E)
              : const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/tree.png',
            height: 22,
            width: 22,
            color: const Color(0xFFD97706),
          ),
        ),
      );
    }
    
    // Default fallback
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: AppColors.isDark
            ? const Color(0xFF1F2937)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Icon(
          Icons.description,
          color: AppColors.isDark
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF4B5563),
          size: 20,
        ),
      ),
    );
  }

  String _formatSubjectLabel(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return 'Scan';
    return t
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map(
          (w) =>
              '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1).toLowerCase() : ''}',
        )
        .join(' ');
  }
}
