import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_extension/views/screen/auth/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _authController = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [Image.asset(Images.appLogo, height: 42, width: 134)],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formKey,
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lato',
                      color: AppColors.textColor,
                    ),
                    children: [
                      const TextSpan(text: "Let's create an "),
                      TextSpan(
                        text: 'QQAI',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: ' account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lato',
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                CustomTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  isPassword: true,
                  hintText: "Enter password",
                ),

                const SizedBox(height: 16),
                Obx(
                  () => CustomButton(
                    loading: _authController.isLoading.value,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        _authController.signup(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                      begin: Alignment.centerRight,
                      end: Alignment.bottomRight,
                    ),
                    text: "Create Account",
                  ),
                ),

                // const SizedBox(height: 24),

                // // ─── Or divider with dots ───
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

                // const SizedBox(height: 16),

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
                //         "Create account with Google",
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
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.textColor.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Text(
                        "Sign In",
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
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
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
