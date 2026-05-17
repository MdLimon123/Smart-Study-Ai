import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:get/get.dart';

class TwoFactorVerify extends StatefulWidget {
  final String email;
  const TwoFactorVerify({super.key, required this.email});

  @override
  State<TwoFactorVerify> createState() => _TwoFactorVerifyState();
}

class _TwoFactorVerifyState extends State<TwoFactorVerify> {
  late final ProfileController _profileController;
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
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
                  "Code sent to ${widget.email}",
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
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 8,
                    color: AppColors.textColor,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'ENTER CODE',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: AppColors.textColor.withValues(alpha: 0.35),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Obx(
                () => CustomButton(
                  onTap: () => _profileController.verifyTwoFactorEmail(
                        email: widget.email,
                        otpCode: _otpController.text,
                      ),
                  loading: _profileController.isVerifyingTwoFactor.value,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                  text: 'Verify Code',
                ),
              ),

              const SizedBox(height: 20),
              Obx(() {
                final sending = _profileController.isSendingTwoFactorCode.value;
                final verifying = _profileController.isVerifyingTwoFactor.value;
                final busy = sending || verifying;
                return Center(
                  child: InkWell(
                    onTap: busy
                        ? null
                        : () => _profileController.sendTwoFactorEmailCode(
                              widget.email,
                              navigateOnSuccess: false,
                            ),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        sending ? 'Sending…' : 'Resend code',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: busy
                              ? const Color(0xFFA78BFA).withValues(alpha: 0.5)
                              : const Color(0xFFA78BFA),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
