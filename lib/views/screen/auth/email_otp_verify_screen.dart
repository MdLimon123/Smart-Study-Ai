import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:get/get.dart';

class EmailOtpVerifyScreen extends StatefulWidget {
  const EmailOtpVerifyScreen({super.key});

  @override
  State<EmailOtpVerifyScreen> createState() => _EmailOtpVerifyScreenState();
}

class _EmailOtpVerifyScreenState extends State<EmailOtpVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 30;
  Timer? _timer;
  bool get _timerDone => _secondsRemaining <= 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() {});
      }
    });
  }

  void _resendCode() {
    if (!_timerDone) return;
    // TODO: Call resend OTP API
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
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
                "We sent a 6 digit passcode to ale**gmail.com",
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
                  final hasValue = _controllers[index].text.isNotEmpty;
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
                              _controllers[index].text.isEmpty &&
                              index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
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
                            _onOtpChanged(value, index);
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // ─── Timer text (visible while counting) ───
              if (!_timerDone)
                RichText(
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
                        text: '${_secondsRemaining}s',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

              // ─── Get a new code button (visible when timer done) ───
              if (_timerDone)
                InkWell(
                  onTap: _resendCode,
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
                ),

              const SizedBox(height: 16),

              // ─── Verify Button ───
              CustomButton(
                onTap: () {
                  Get.offNamed(AppRoutes.setupProfileScreen);
                },
                text: 'Verify',
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  begin: Alignment.centerRight,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
