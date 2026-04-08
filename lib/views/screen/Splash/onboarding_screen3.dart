import 'package:flutter/material.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/util/style.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
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
                    const Color(0xFFF48A3B).withValues(alpha: 0.70),
                    const Color(0xFFF48A3B).withValues(alpha: 0.35),
                    const Color(0xFFF48A3B).withValues(alpha: 0.08),
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
                    const Color(0xFFF48A3B).withValues(alpha: 0.85),
                    const Color(0xFFF48A3B).withValues(alpha: 0.40),
                    const Color(0xFFF48A3B).withValues(alpha: 0.08),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // App Logo
                  Image.asset(Images.appLogo, height: 50),

                  const Spacer(flex: 2),

                  // Center icon
                  Image.asset(
                    "assets/images/glussh.png",
                    height: 192,
                    width: 188,
                  ),

                  const Spacer(flex: 2),

                  // Subtitle
                  Text(
                    'your way',
                    style: AppStyles.h5(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,

                      letterSpacing: 2.0,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Organize & Study',
                    style: AppStyles.h1(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Upload materials, organize notes, and access your personalized study library anytime.',
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
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    text: 'Get Started',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      begin: Alignment.centerRight,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  const SizedBox(height: 16),
                  CustomButton(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    color: Colors.black,
                    border: Border.all(
                      color: const Color(0xFF4A4754),
                      width: 1,
                    ),
                    text: "Sign In",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
