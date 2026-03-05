import 'package:flutter/material.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/util/style.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.backgroundColor),

          // ─── Layer 2: Large outer glow ───
          Positioned(
            top: 0.05.sh,
            left: -0.4.sw,
            right: -0.4.sw,
            child: Container(
              height: 0.7.sh,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.6,
                  colors: [
                    const Color(0xFF397DFF).withValues(alpha: 0.70),
                    const Color(0xFF397DFF).withValues(alpha: 0.35),
                    const Color(0xFF397DFF).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // ─── Layer 3: Inner bright glow ───
          Positioned(
            top: 0.15.sh,
            left: -0.15.sw,
            right: -0.15.sw,
            child: Container(
              height: 0.5.sh,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [
                    const Color(0xFF397DFF).withValues(alpha: 0.85),
                    const Color(0xFF397DFF).withValues(alpha: 0.40),
                    const Color(0xFF397DFF).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // ─── Layer 4: Top purple tint ───
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.3.sh,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x337C3AED), Colors.transparent],
                ),
              ),
            ),
          ),

          // ─── Content ───
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  // App Logo
                  Image.asset(Images.appLogo, height: 50.h),

                  const Spacer(flex: 2),

                  // Center icon
                  Image.asset(
                    "assets/images/onboard2.png",
                    height: 192,
                    width: 188,
                  ),

                  const Spacer(flex: 2),

                  // Subtitle
                  Text(
                    'Any Problem',
                    style: AppStyles.h5(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,

                      letterSpacing: 2.0,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Title
                  Text(
                    'Scan & Solve Instantly',
                    style: AppStyles.h1(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    'Point your camera at any academic problem and get step-by-step solutions in seconds.',
                    style: AppStyles.h4(
                      color: AppColors.textColor.withValues(alpha: 0.80),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 1),

                  // Button
                  CustomButton(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.onboardingScreen3);
                    },
                    text: 'Next 2/3',
                   gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  begin: Alignment.centerRight,
                  end: Alignment.bottomRight,
                ),
                  ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
