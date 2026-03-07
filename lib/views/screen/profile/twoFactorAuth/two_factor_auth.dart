import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/profile/twoFactorAuth/choose_your_method.dart';
import 'package:get/get.dart';

class TwoFactorAuth extends StatefulWidget {
  const TwoFactorAuth({super.key});

  @override
  State<TwoFactorAuth> createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends State<TwoFactorAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      
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
                  "Two-Factor Auth",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),

                Text(
                  'Add an extra layer of security',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                  border: Border.all(
                    color: AppColors.textColor.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset('assets/images/pass.png'),
                      ),

                      const SizedBox(width: 16),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "2FA Disabled",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Your account has basic protection only",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor.withValues(
                                alpha: 0.40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/info.png'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Two-factor authentication adds a second verification step when you sign in, protecting your account even if your password is compromised.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor.withValues(alpha: 0.50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              InkWell(
                onTap: () {
                  Get.to(() => const ChooseYourMethod());
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA7C3AED).withValues(alpha: 0.30),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/enable.png'),
                      const SizedBox(width: 11),
                      Text(
                        "Enable 2FA",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
