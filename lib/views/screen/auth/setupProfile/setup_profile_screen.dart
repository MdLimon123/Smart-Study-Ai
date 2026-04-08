import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/auth_controller.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:flutter_extension/views/base/custom_button.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/base/custom_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _authController = Get.put(AuthController());

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create your Profile",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "To display your information in app",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor.withValues(alpha: 0.8),
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(
                        () => Container(
                          height: 124,
                          width: 124,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF181823),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child:
                                _authController.userProfileImage.value != null
                                ? Image.file(
                                    _authController.userProfileImage.value!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.asset(
                                    'assets/images/user.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _authController.pickUserImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset('assets/icon/camera.svg'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  hintText: 'What’s your full name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),
                CustomTextField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your description';
                    }
                    return null;
                  },
                  maxLines: 5,
                  hintText:
                      'Tell us a bit of your self to get most potential result',
                ),

                // const SizedBox(height: 3),
                // const Text(
                //   "Optional",
                //   style: TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //     color: Color(0xFF7F7F87),
                //   ),
                // ),
                const SizedBox(height: 85),
                Obx(
                  () => CustomButton(
                    loading: _authController.isLoading.value,
                    onTap: () {
                      if (_authController.userProfileImage.value == null) {
                        showCustomSnackBar(
                          'Please select your profile image',
                          isError: true,
                        );
                        return;
                      }
                      if (nameController.text.isEmpty) {
                        showCustomSnackBar(
                          'Please enter your name',
                          isError: true,
                        );
                        return;
                      }
                      if (descriptionController.text.isEmpty) {
                        showCustomSnackBar(
                          'Please enter your description',
                          isError: true,
                        );
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        _authController.profileSetup(
                          image:
                              _authController.userProfileImage.value?.path ??
                              '',
                          name: nameController.text,
                          description: descriptionController.text,
                        );
                      }
                    },
                    text: "Done",
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    ),
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
