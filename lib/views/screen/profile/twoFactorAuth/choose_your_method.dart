import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/screen/profile/twoFactorAuth/confirm_email.dart';
import 'package:get/get.dart';

class ChooseYourMethod extends StatefulWidget {
  const ChooseYourMethod({super.key});

  @override
  State<ChooseYourMethod> createState() => _ChooseYourMethodState();
}

class _ChooseYourMethodState extends State<ChooseYourMethod> {
  int _selectedMethod = 0;

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
                  "Choose Your Method",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'Select a verification method',
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
              const SizedBox(height: 30),

              const SizedBox(height: 12),

              _methodCard(
                index: 1,
                icon: 'assets/images/email.png',
                iconColor: const Color(0xFF34D399),
                title: "Email",
                subtitle: "Receive a code at your registered\nemail address.",
              ),

              const Spacer(),

              InkWell(
                onTap: () {
                  Get.to(() => const ConfirmEmail());
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.30),
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
                      Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: AppColors.textColor),
                    ],
                  ),
                ),
              ),



              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodCard({
    required int index,
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _selectedMethod == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? const Color(0xFFA78BFA).withValues(alpha: 0.07)
              : AppColors.textColor.withValues(alpha: 0.04),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA78BFA).withValues(alpha: 0.25)
                : AppColors.textColor.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: iconColor.withValues(alpha: 0.10),
              ),
              child: Center(child: Image.asset(icon)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFFA78BFA)
                    : AppColors.textColor.withValues(alpha: 0.10),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA78BFA)
                      : AppColors.textColor.withValues(alpha: 0.20),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.textColor,
                        size: 14,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }



}
