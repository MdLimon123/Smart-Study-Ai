import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/auth/email_otp_verify_screen.dart';
import 'package:flutter_extension/views/screen/auth/otp_verify_screen.dart';
import 'package:flutter_extension/views/screen/auth/reset_password_screen.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Rx<File?> userProfileImage = Rx<File?>(null);

  Future<void> pickUserImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      userProfileImage.value = pickedFile;
    }
  }

  List<TextEditingController>? _otpControllers;
  List<FocusNode>? _otpFocusNodes;
  final secondsRemaining = 60.obs;
  Timer? _otpTimer;

  List<TextEditingController> get otpControllers => _otpControllers!;

  List<FocusNode> get otpFocusNodes => _otpFocusNodes!;

  bool get otpTimerDone => secondsRemaining.value <= 0;

  bool get hasOtpFieldsReady =>
      _otpControllers != null && _otpFocusNodes != null;

  String get otpDigits =>
      hasOtpFieldsReady ? _otpControllers!.map((c) => c.text).join() : '';

  /// Call from [EmailOtpVerifyScreen] — creates fields once, restarts timer each visit.
  void initEmailOtpVerification() {
    if (_otpControllers == null) {
      _otpControllers = List.generate(6, (_) => TextEditingController());
      _otpFocusNodes = List.generate(6, (_) => FocusNode());
    }
    startOtpTimer();
  }

  void startOtpTimer() {
    _otpTimer?.cancel();
    secondsRemaining.value = 60;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// Resend OTP from server, then clear fields and restart cooldown.
  /// Uses `/auth/resend-otp/` — only for **signup / unverified email** flow
  /// ([EmailOtpVerifyScreen]). If email is already verified, API returns 400.
  Future<void> resendEmailOtp(String email) async {
    if (!otpTimerDone) return;
    if (!hasOtpFieldsReady) return;
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.resendOTP,
        {'email': email},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _afterResendOtpSuccess(_messageFromBody(response.body) ?? 'Code sent');
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Could not resend code',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  /// Resend code for **forgot-password** ([OtpVerifyScreen]). Must use
  /// [ApiConstant.forgotPassword] — not [resendOTP], which is for unverified signups.
  Future<void> resendForgotPasswordOtp(String email) async {
    if (!otpTimerDone) return;
    if (!hasOtpFieldsReady) return;
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.forgotPassword,
        {'email': email},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _afterResendOtpSuccess(_messageFromBody(response.body) ?? 'Code sent');
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Could not resend code',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  void _afterResendOtpSuccess(String message) {
    showCustomSnackBar(message, isError: false);
    for (final c in _otpControllers!) {
      c.clear();
    }
    _otpFocusNodes![0].requestFocus();
    startOtpTimer();
  }

  void onOtpDigitChanged(String value, int index) {
    if (!hasOtpFieldsReady) return;
    if (value.length == 1 && index < 5) {
      _otpFocusNodes![index + 1].requestFocus();
    }
  }

  String? _messageFromBody(dynamic body) {
    if (body is Map) {
      return body['message']?.toString();
    }
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.login,
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map &&
            body['data'] != null &&
            body['data'] is Map &&
            body['data']['access'] != null) {
          await PrefsHelper.setString(
            AppConstants.TOKEN,
            body['data']['access'].toString(),
          );
        }
        showCustomSnackBar(
          _messageFromBody(body) ?? 'Signed in',
          isError: false,
        );
        Get.offAllNamed(AppRoutes.mainScreen);
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Sign in failed',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> signup({required String email, required String password}) async {
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.register,
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar('Account created successfully', isError: false);
        Get.to(() => EmailOtpVerifyScreen(email: email));
      } else {
        showCustomSnackBar('Sign up failed', isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }





  /// Forgot-password flow: request OTP to email, then open [OtpVerifyScreen].
  Future<void> requestForgotPasswordOtp(String email) async {
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.forgotPassword,
        {'email': email},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Check your email for the code',
          isError: false,
        );
        Get.to(() => OtpVerifyScreen(email: email));
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Request failed',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  /// After forgot-password OTP entry — verify then go to reset password.
  /// Uses same verify-otp endpoint as email verification (adjust if your API differs).
  /// Saves `data.access` like [emailOtpVerify] — [resetPassword] needs Bearer token.
  Future<void> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.verifyEmail,
        {'email': email, 'otp_code': otp},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map &&
            body['data'] != null &&
            body['data'] is Map &&
            body['data']['access'] != null) {
          await PrefsHelper.setString(
            AppConstants.TOKEN,
            body['data']['access'].toString(),
          );
          await ApiClient.loadPrefs();
        }
        showCustomSnackBar(
          _messageFromBody(body) ?? 'Verified',
          isError: false,
        );
        Get.to(() => ResetPasswordScreen(email: email));
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Invalid code',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> emailOtpVerify({
    required String email,
    required String otp,
  }) async {
    isLoading(true);
    try {
      final response = await ApiClient.postData(
        ApiConstant.verifyEmail,
        {'email': email, 'otp_code': otp},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map &&
            body['data'] != null &&
            body['data'] is Map &&
            body['data']['access'] != null) {
          await PrefsHelper.setString(
            AppConstants.TOKEN,
            body['data']['access'].toString(),
          );
        }
        showCustomSnackBar(
          _messageFromBody(body) ?? 'Verified',
          isError: false,
        );
        Get.offNamed(AppRoutes.setupProfileScreen);
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Verification failed',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> resetPassword({required String newPassword}) async {
    isLoading(true);

    final response = await ApiClient.postData(ApiConstant.resetPassword, {
      'new_password': newPassword,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(
        _messageFromBody(response.body) ?? 'Password reset successful',
        isError: false,
      );
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      showCustomSnackBar(
        _messageFromBody(response.body) ?? 'Password reset failed',
        isError: true,
      );
    }
    isLoading(false);
  }

  Future<void> profileSetup({
    required String name,
    required String image,
    required String description,
  }) async {
    isLoading(true);

    List<MultipartBody> multipartBody = [];
    if (image.isNotEmpty) {
      multipartBody.add(MultipartBody('image', File(image)));
    }

    Map<String, String> data = {"name": name, "description": description};
    final response = await ApiClient.postMultipartData(
      ApiConstant.profileSetup,
      data,
      multipartBody: multipartBody,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar(
        _messageFromBody(response.body) ?? 'Profile setup successful',
        isError: false,
      );
      Get.offAllNamed(AppRoutes.mainScreen);
    } else {
      showCustomSnackBar(
        _messageFromBody(response.body) ?? 'Profile setup failed',
        isError: true,
      );
    }
    isLoading(false);
  }
}
