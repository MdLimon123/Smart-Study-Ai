import 'dart:io';

import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/chat_history_item_model.dart';
import 'package:flutter_extension/data/model/profile_model.dart';
import 'package:flutter_extension/data/model/scan_history_item_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/profile/twoFactorAuth/two_factor_verify.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final RxBool isProfileLoading = false.obs;
  final RxBool isUpdatingImage = false.obs;
  final RxBool isSendingTwoFactorCode = false.obs;
  final RxBool isVerifyingTwoFactor = false.obs;

  final chatHistory = <ChatHistoryItemModel>[].obs;
  final isChatHistoryLoading = false.obs;
  final isDeletingChatHistory = false.obs;
  final chatHistoryError = RxnString();
  final scanHistory = <ScanHistoryItemModel>[].obs;
  final isScanHistoryLoading = false.obs;
  final scanHistoryError = RxnString();

  Rx<File?> userProfileImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isProfileLoading.value = true;
    try {
      final response = await ApiClient.getData(ApiConstant.getProfile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] != null && body['data'] is Map) {
          profile.value = ProfileModel.fromJson(
            Map<String, dynamic>.from(body['data'] as Map),
          );
        }
      }
    } finally {
      isProfileLoading.value = false;
    }
  }

  /// Gallery/camera — after pick, PATCH profile with `image` only (other fields unchanged on server).
  Future<void> pickUserImage({bool fromCamera = false}) async {
    if (isUpdatingImage.value) return;
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile == null) return;

    userProfileImage.value = pickedFile;
    await _patchProfileImage(pickedFile);
  }

  Future<void> _patchProfileImage(File imageFile) async {
    isUpdatingImage.value = true;
    try {
      final response = await ApiClient.patchMultipartData(
        ApiConstant.updateProfile,
        const {},
        multipartBody: [MultipartBody('image', imageFile)],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        userProfileImage.value = null;
        final body = response.body;
        if (body is Map && body['data'] != null && body['data'] is Map) {
          profile.value = ProfileModel.fromJson(
            Map<String, dynamic>.from(body['data'] as Map),
          );
        } else {
          await fetchProfile();
        }
        showCustomSnackBar(
          _msg(body) ?? 'Profile photo updated',
          isError: false,
        );
      } else {
        userProfileImage.value = null;
        showCustomSnackBar(
          _msg(response.body) ?? 'Could not update photo',
          isError: true,
        );
      }
    } catch (e) {
      userProfileImage.value = null;
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isUpdatingImage.value = false;
    }
  }

  String? _msg(dynamic body) {
    if (body is Map) return body['message']?.toString();
    return null;
  }

  /// POST `/2fa/send/` — sends 2FA code to [email].
  /// [navigateOnSuccess]: from confirm screen `true` (opens verify); resend uses `false`.
  Future<void> sendTwoFactorEmailCode(
    String email, {
    bool navigateOnSuccess = true,
  }) async {
    if (isSendingTwoFactorCode.value) return;
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      showCustomSnackBar('Please enter your email', isError: true);
      return;
    }
    if (!GetUtils.isEmail(trimmed)) {
      showCustomSnackBar('Please enter a valid email', isError: true);
      return;
    }
    isSendingTwoFactorCode.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.twoFactorAuthEndpoint,
        {'email': trimmed},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _msg(response.body) ??
              (navigateOnSuccess ? 'Code sent' : 'New code sent'),
          isError: false,
        );
        if (navigateOnSuccess) {
          Get.to(() => TwoFactorVerify(email: trimmed));
        }
      } else {
        showCustomSnackBar(
          _msg(response.body) ?? 'Could not send code',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isSendingTwoFactorCode.value = false;
    }
  }

  /// POST `/2fa/verify/` — body: `email`, `otp_code`.
  /// On success refreshes profile and pops verify → confirm → method (back to [TwoFactorAuth]).
  Future<void> verifyTwoFactorEmail({
    required String email,
    required String otpCode,
  }) async {
    if (isVerifyingTwoFactor.value) return;
    final trimmedEmail = email.trim();
    final trimmedOtp = otpCode.trim();
    if (trimmedOtp.isEmpty) {
      showCustomSnackBar('Please enter the code', isError: true);
      return;
    }
    isVerifyingTwoFactor.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.twoFactorVerifyEndpoint,
        {'email': trimmedEmail, 'otp_code': trimmedOtp},
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _msg(response.body) ?? 'Two-factor authentication enabled',
          isError: false,
        );
        await fetchProfile();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
      } else {
        showCustomSnackBar(
          _msg(response.body) ?? 'Verification failed',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isVerifyingTwoFactor.value = false;
    }
  }

  /// GET `/chat/ask/` — list of past prompts and AI replies.
  Future<void> fetchChatHistory() async {
    isChatHistoryLoading.value = true;
    chatHistoryError.value = null;
    try {
      final response = await ApiClient.getData(ApiConstant.chatHistoryEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is List) {
          final list = body['data'] as List;
          chatHistory.assignAll(
            list
                .map(
                  (e) => ChatHistoryItemModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList(),
          );
        } else {
          chatHistory.clear();
        }
      } else {
        chatHistory.clear();
        chatHistoryError.value =
            _msg(response.body) ?? 'Could not load chat history';
      }
    } catch (e) {
      chatHistory.clear();
      chatHistoryError.value = e.toString();
    } finally {
      isChatHistoryLoading.value = false;
    }
  }

  /// DELETE `/chat/ask/` — clears all chat history entries.
  Future<bool> deleteAllChatHistory() async {
    if (isDeletingChatHistory.value) return false;
    isDeletingChatHistory.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiConstant.chatHistoryDeleteEndpoint,
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        chatHistory.clear();
        chatHistoryError.value = null;
        showCustomSnackBar(
          _msg(response.body) ?? 'Chat history deleted successfully',
          isError: false,
        );
        return true;
      }
      showCustomSnackBar(
        _msg(response.body) ?? 'Could not delete chat history',
        isError: true,
      );
      return false;
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
      return false;
    } finally {
      isDeletingChatHistory.value = false;
    }
  }

  /// GET `/scan/history/` — list of past scan results.
  Future<void> fetchScanHistory() async {
    isScanHistoryLoading.value = true;
    scanHistoryError.value = null;
    try {
      final response = await ApiClient.getData(ApiConstant.scanHistoryEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map) {
          final outerData = body['data'];
          if (outerData is Map) {
            final history = outerData['history'];
            if (history is Map) {
              final historyData = history['data'];
              if (historyData is Map && historyData['results'] is List) {
                final list = historyData['results'] as List;
                scanHistory.assignAll(
                  list
                      .map(
                        (e) => ScanHistoryItemModel.fromJson(
                          Map<String, dynamic>.from(e as Map),
                        ),
                      )
                      .toList(),
                );
                return;
              }
            }
          }
        }
        scanHistory.clear();
      } else {
        scanHistory.clear();
        scanHistoryError.value =
            _msg(response.body) ?? 'Could not load scan history';
      }
    } catch (e) {
      scanHistory.clear();
      scanHistoryError.value = e.toString();
    } finally {
      isScanHistoryLoading.value = false;
    }
  }
}
