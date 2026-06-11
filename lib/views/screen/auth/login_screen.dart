import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/auth/forget_password_screen.dart';
import 'package:flutter_extension/views/screen/auth/signup_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_extension/views/screen/profile/privacy_policy_page.dart';
import 'package:flutter_extension/views/screen/profile/terms_of_service_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = Get.put(AuthController());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Image.asset(Images.appLogo, height: 42, width: 134)],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Quiz Question AI",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lato',
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Sign in to your account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lato',
                    color: AppColors.textColor,
                  ),
                ),

                const SizedBox(height: 32),
                CustomTextField(
                  hintText: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  isPassword: true,
                  controller: _passwordController,
                  hintText: "Enter password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Get.to(() => const ForgetPasswordScreen());
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                      color: Color(0xFF397DFF),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CustomButton(
                    loading: _auth.isLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      }
                    },
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      begin: Alignment.centerRight,
                      end: Alignment.bottomRight,
                    ),
                    text: "Sign In",
                  ),
                ),

                const SizedBox(height: 14),

                // ─── Or divider with dots ───
                // Row(
                //   children: [
                //     Expanded(
                //       child: LayoutBuilder(
                //         builder: (context, constraints) {
                //           return Wrap(
                //             alignment: WrapAlignment.center,
                //             spacing: 4,
                //             children: List.generate(
                //               (constraints.maxWidth / 8).floor(),
                //               (_) => Container(
                //                 width: 2,
                //                 height: 2,
                //                 decoration: const BoxDecoration(
                //                   color: Color(0xFF4A4754),
                //                   shape: BoxShape.circle,
                //                 ),
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 12),
                //       child: Text(
                //         'Or',
                //         style: TextStyle(
                //           color: AppColors.textColor.withValues(alpha: 0.8),
                //           fontSize: 13,
                //           fontWeight: FontWeight.w400,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: LayoutBuilder(
                //         builder: (context, constraints) {
                //           return Wrap(
                //             alignment: WrapAlignment.center,
                //             spacing: 4,
                //             children: List.generate(
                //               (constraints.maxWidth / 8).floor(),
                //               (_) => Container(
                //                 width: 2,
                //                 height: 2,
                //                 decoration: const BoxDecoration(
                //                   color: Color(0xFF4A4754),
                //                   shape: BoxShape.circle,
                //                 ),
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ],
                // ),





                // Container(
                //   width: double.infinity,
                //   height: 48,
                //   decoration: BoxDecoration(
                //     color: AppColors.backgroundColor,
                //     borderRadius: BorderRadius.circular(16),
                //     border: Border.all(
                //       color: const Color(0xFF34303E),
                //       width: 1,
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         "assets/icon/google.svg",
                //         height: 20,
                //         width: 20,
                //       ),
                //       const SizedBox(width: 16),
                //       Text(
                //         "Sign in with Google",
                //         style: TextStyle(
                //           color: AppColors.textColor,
                //           fontSize: 14,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textColor.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignupScreen());
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 170),

                // ─── Terms & Privacy ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor.withValues(alpha: 0.8),
                      ),
                      children: [
                        const TextSpan(
                          text: 'By continuing, you agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => const TermsOfServicePage()),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => const PrivacyPolicyPage()),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
