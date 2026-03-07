import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/profile/parental/parental_control_screen.dart';
import 'package:flutter_extension/views/screen/profile/twoFactorAuth/two_factor_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/dummy.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.all(8),
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1D1929),
                        ),
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1BD2A4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: Text(
                  "Alex Johnson",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  "alex.j@student.edu",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.50),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Container(
                  width: 180,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF48A3B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFF48A3B),
                      width: 1,
                    ),
                  ),

                  child: Row(
                    children: [
                      const Text(
                        "FREE PLAN",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF48A3B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "• 3 scans/day",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor.withValues(alpha: 0.30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.30),
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/crown.png'),
                    const SizedBox(width: 16),
                    Text(
                      "Upgrade to Premium",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  _customContainer(
                    image: "assets/images/circle.png",
                    count: "3",
                    title: "Problems Solved",
                  ),
                  const SizedBox(width: 8),
                  _customContainer(
                    image: "assets/images/book_fill.png",
                    count: "128h",
                    title: "Study Hours",
                  ),
                  const SizedBox(width: 8),
                  _customContainer(
                    image: "assets/images/phy.png",
                    count: "7",
                    title: "Streak Days",
                  ),
                  const SizedBox(width: 8),
                  _customContainer(
                    image: "assets/images/badges.png",
                    count: "12",
                    title: "Badges",
                  ),
                ],
              ),

              const SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Badges",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA78BFA),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _badgesContainer(
                    bacgroundColor: const Color(0xFFA78BFA),
                    borderColor: const Color(0xFFA78BFA),
                    image: "assets/images/fire.png",
                    title: "7-Day Streak",
                  ),
                  const SizedBox(width: 8),
                  _badgesContainer(
                    bacgroundColor: const Color(0xFF60A5FA),
                    borderColor: const Color(0xFF60A5FA),
                    image: "assets/images/star.png",
                    title: "Top Solver",
                  ),
                  const SizedBox(width: 8),
                  _badgesContainer(
                    bacgroundColor: const Color(0xFF34D399),
                    borderColor: const Color(0xFF34D399),
                    image: "assets/images/book3.png",
                    title: "Bookworm",
                  ),
                  const SizedBox(width: 8),
                  _badgesContainer(
                    bacgroundColor: const Color(0xFFF59E0B),
                    borderColor: const Color(0xFFF59E0B),
                    image: "assets/images/tree.png",
                    title: "Accurate",
                  ),
                ],
              ),
              const SizedBox(height: 23),

              Text(
                "Security & Privacy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customRow(
                      onTap: () {
                        Get.to(() => const TwoFactorAuth());
                      },
                      backgroundColor: const Color(0xFF60A5FA),
                      image: "assets/images/lock.png",
                      title: "Two-Factor Auth",
                      subtitle: "Add extra sign-in security",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {
                        Get.to(() => const ParentalControlScreen());
                      },
                      backgroundColor: const Color(0xFFF59E0B),
                      image: "assets/images/groupUser.png",
                      title: "Parental Control",
                      subtitle: "Content & time restrictions",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFFA78BFA),
                      image: "assets/images/groupUser.png",
                      title: "AI Personalization",
                      subtitle: "Model, style & subject focus",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFF34D399),
                      image: "assets/images/groupUser.png",
                      title: "Data Control",
                      subtitle: "Export data · Delete chat history",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              Text(
                "General",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),

              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFF60A5FA),
                      image: "assets/images/notification.png",
                      title: "Notifications",
                      subtitle: "Push & email alerts",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFF34D399),
                      image: "assets/images/privacy.png",
                      title: "Privacy & Security",
                      subtitle: "Manage data",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFFF59E0B),
                      image: "assets/images/help.png",
                      title: "Help & Support",
                      subtitle: "FAQ & contact",
                    ),

                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.textColor.withValues(alpha: 0.05),
                    ),

                    const SizedBox(height: 10),

                    _customRow(
                      onTap: () {},
                      backgroundColor: const Color(0xFF60A5FA),
                      image: "assets/images/lock.png",
                      title: "Change Password",
                      subtitle: "Update your password",
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _customRow({
    required Color backgroundColor,
    required String image,
    required String title,
    required String subtitle,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: backgroundColor.withValues(alpha: 0.12),
            ),
            child: Image.asset(image),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),

          const Spacer(),
          Icon(
            Icons.navigate_next,
            color: AppColors.textColor.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }

  Expanded _badgesContainer({
    required Color bacgroundColor,
    required Color borderColor,
    required String image,
    required String title,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bacgroundColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: bacgroundColor.withValues(alpha: 0.13),
              ),
              child: Image.asset(image),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customContainer({
    required String image,
    required String count,
    required String title,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.textColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textColor.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, width: 20, height: 20),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor.withValues(alpha: 0.35),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
