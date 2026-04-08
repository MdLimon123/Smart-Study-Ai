import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = Get.put(AuthController());
    _auth.initEmailOtpVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: AppColors.textColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Lato',
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We sent a 6 digit passcode to ${widget.email}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lato',
                  color: AppColors.textColor.withValues(alpha: 0.70),
                ),
              ),

              const SizedBox(height: 32),

              // ─── OTP Fields ───
              Row(
                children: List.generate(6, (index) {
                  final hasValue = _auth.otpControllers[index].text.isNotEmpty;
                  return Expanded(
                    child: Container(
                      height: 52,
                      margin: EdgeInsets.only(right: index < 5 ? 10 : 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1929),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasValue
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF34303E),
                          width: 1.5,
                        ),
                      ),
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace &&
                              _auth.otpControllers[index].text.isEmpty &&
                              index > 0) {
                            _auth.otpFocusNodes[index - 1].requestFocus();
                          }
                        },
                        child: TextField(
                          controller: _auth.otpControllers[index],
                          focusNode: _auth.otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: AppColors.textColor,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {});
                            _auth.onOtpDigitChanged(value, index);
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // ─── Timer / resend ───
              Obx(() {
                final done = _auth.otpTimerDone;
                if (!done) {
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.70),
                      ),
                      children: [
                        const TextSpan(text: "You'll get a new code in "),
                        TextSpan(
                          text: '${_auth.secondsRemaining.value}s',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return InkWell(
                  onTap: () => _auth.resendForgotPasswordOtp(widget.email),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF34303E),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Get a new code",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              Obx(
                () => CustomButton(
                  loading: _auth.isLoading.value,
                  onTap: () {
                    final otp = _auth.otpDigits;
                    if (otp.length != 6) {
                      showCustomSnackBar(
                        'Enter the 6-digit code',
                        isError: true,
                      );
                      return;
                    }
                    _auth.verifyForgotPasswordOtp(
                      email: widget.email,
                      otp: otp,
                    );
                  },
                  text: 'Verify',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    begin: Alignment.centerRight,
                    end: Alignment.bottomRight,
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
