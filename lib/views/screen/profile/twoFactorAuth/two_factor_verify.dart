import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:get/get.dart';

class TwoFactorVerify extends StatefulWidget {
  const TwoFactorVerify({super.key});

  @override
  State<TwoFactorVerify> createState() => _TwoFactorVerifyState();
}

class _TwoFactorVerifyState extends State<TwoFactorVerify> {
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
                    fontSize: 22,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFA78BFA).withValues(alpha: 0.12),
                  ),
                  child: Center(child: Image.asset('assets/images/e.png')),
                ),
              ),

              const SizedBox(height: 15),
              Center(
                child: Text(
                  "Enter Verification Code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  "Code sent to alex.j@student.edu",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.40),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    hint: Center(
                      child: Text(
                        'ENTER 4-DIGIT PIN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              CustomButton(
                onTap: () {},
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                ),
                text: "Verify Code",
              ),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Resend code",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA78BFA),
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
