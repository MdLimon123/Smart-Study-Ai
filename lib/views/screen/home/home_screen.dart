import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/chat/ai_chat_screen.dart';
import 'package:flutter_extension/views/screen/home/subscreen/subject_screen.dart';
import 'package:flutter_extension/views/screen/library/library_screen.dart';
import 'package:flutter_extension/views/screen/notifications/notification1_screen.dart';
import 'package:flutter_extension/views/screen/scan&solve/scan_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      "Good morning 👋",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Welcome back, Alex",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const Notification1Screen());
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.textColor.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/icon/notifications.svg'),
                    ),
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.textColor.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/icon/fire.svg'),
                            const SizedBox(width: 6),
                            Text(
                              "7 day streak",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor.withValues(
                                  alpha: 0.61,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.textColor.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/icon/star.svg'),
                            const SizedBox(width: 6),
                            Text(
                              "3 scans left",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor.withValues(
                                  alpha: 0.61,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.textColor.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/icon/level.svg'),
                            const SizedBox(width: 6),
                            Text(
                              "Level 5",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor.withValues(
                                  alpha: 0.61,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4C1D95), Color(0xFF1E3A8A)],
                      ),
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
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Unlock Unlimited Scans",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                            Container(
                              width: 94,
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textColor.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upgrade",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: AppColors.textColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "+ Cloud storage & exports",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor.withValues(alpha: 0.60),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 19),
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                            Get.to(() => const ScanScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFA78BFA,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFFA78BFA,
                                ).withValues(alpha: 0.14),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: const Color(
                                      0xFFA78BFA,
                                    ).withValues(alpha: 0.12),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/scan.svg',
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Scan & Solve",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.70,
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
                            Get.to(() => const AiChatScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF60A5FA,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF60A5FA,
                                ).withValues(alpha: 0.14),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: const Color(
                                      0xFF60A5FA,
                                    ).withValues(alpha: 0.12),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/chat.svg',
                                      color: const Color(0xFF60A5FA),
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "AI Chat",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.70,
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
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF34D399,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF34D399,
                                ).withValues(alpha: 0.14),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: const Color(
                                      0xFF34D399,
                                    ).withValues(alpha: 0.12),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/library.svg',
                                      color: const Color(0xFF34D399),
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Library",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.70,
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
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withValues(alpha: 0.14),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.12),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icon/subject.svg',
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Subjects",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor.withValues(
                                      alpha: 0.70,
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
                        "AI Models",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Use →",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          color: Color(0xFFA78BFA),
                        ),
                      ),
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
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.10),
                            border: Border.all(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.27),
                              width: 1,
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
                                        fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w400,
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
                            color: AppColors.textColor.withValues(alpha: 0.05),
                            border: Border.all(
                              color: AppColors.textColor.withValues(
                                alpha: 0.08,
                              ),
                              width: 1,
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
                                        fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w400,
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
                            color: AppColors.textColor.withValues(alpha: 0.05),
                            border: Border.all(
                              color: AppColors.textColor.withValues(
                                alpha: 0.05,
                              ),
                              width: 1,
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
                                      color: Color(0xFFA78BFA),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Claude 3",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w400,
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
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                      const Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                          color: Color(0xFFA78BFA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _customContainer(
                    title: "Mathematics",
                    subtitle: "Quadratic Equations",
                    backgroundColor: const Color(
                      0xFFD6C8FF,
                    ).withValues(alpha: 0.30),
                    icon: 'assets/images/math.png',
                  ),
                  const SizedBox(height: 8),
                  _customContainer(
                    title: "Chemistry",
                    subtitle: "Organic Reactions",
                    backgroundColor: const Color(
                      0xFF60A5FA,
                    ).withValues(alpha: 0.30),
                    icon: 'assets/images/che.png',
                  ),
                  const SizedBox(height: 8),
                  _customContainer(
                    title: "Physics",
                    subtitle: "Wave Mechanics",
                    backgroundColor: const Color(
                      0xFF34D399,
                    ).withValues(alpha: 0.30),
                    icon: 'assets/images/phy.png',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _customContainer({
    required Color backgroundColor,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.textColor.withValues(alpha: 0.04),
        border: Border.all(
          color: AppColors.textColor.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Image.asset(icon)),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                  color: AppColors.textColor.withValues(alpha: 0.45),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lato',
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),

          const Spacer(),
          Text(
            "3 min ago",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
              color: AppColors.textColor.withValues(alpha: 0.30),
            ),
          ),
        ],
      ),
    );
  }
}
