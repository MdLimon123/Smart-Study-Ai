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
  /// Results when `GET /scan/history/?subject=...` is used (Subject screen search).
  final scanHistoryQuery = <ScanHistoryItemModel>[].obs;
  final isScanHistoryLoading = false.obs;
  final scanHistoryError = RxnString();

  final isAiPersonalizationLoading = false.obs;
  final isParentalControlLoading = false.obs;

  Rx<File?> userProfileImage = Rx<File?>(null);
  final isLoading = false.obs;

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

  List<ScanHistoryItemModel> _parseScanHistoryResults(dynamic body) {
    if (body is! Map) return [];
    final outerData = body['data'];
    if (outerData is! Map) return [];
    final history = outerData['history'];
    if (history is! Map) return [];
    final historyData = history['data'];
    if (historyData is! Map || historyData['results'] is! List) return [];
    final list = historyData['results'] as List;
    return list
        .map(
          (e) => ScanHistoryItemModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  /// GET `/scan/history/` — list of past scan results.
  /// Optional [subject] query param, e.g. `subject=math`.
  Future<void> fetchScanHistory({String? subject}) async {
    isScanHistoryLoading.value = true;
    scanHistoryError.value = null;
    final trimmed = subject?.trim();
    final hasSubject = trimmed != null && trimmed.isNotEmpty;
    try {
      final response = await ApiClient.getData(
        ApiConstant.scanHistoryEndpoint,
        query: hasSubject ? {'subject': trimmed.toLowerCase()} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsed = _parseScanHistoryResults(response.body);
        if (hasSubject) {
          scanHistoryQuery.assignAll(parsed);
        } else {
          scanHistory.assignAll(parsed);
        }
        return;
      }
      if (hasSubject) {
        scanHistoryQuery.clear();
      } else {
        scanHistory.clear();
      }
      scanHistoryError.value =
          _msg(response.body) ?? 'Could not load scan history';
    } catch (e) {
      if (hasSubject) {
        scanHistoryQuery.clear();
      } else {
        scanHistory.clear();
      }
      scanHistoryError.value = e.toString();
    } finally {
      isScanHistoryLoading.value = false;
    }
  }


  /// POST `/scan/ai-personalization/` — saves AI tutoring preferences.
  /// Body keys match backend (`response_sytel`, `dificulty_level`).
  Future<void> saveAiPersonalization({
    required String model,
    required String responseStyle,
    required String difficultyLevel,
    required String language,
    required String subjectFocusArea,
  }) async {
    if (isAiPersonalizationLoading.value) return;
    isAiPersonalizationLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.aiPersonalizationEndpoint,
        {
          'model': model,
          'response_sytel': responseStyle,
          'dificulty_level': difficultyLevel,
          'language': language,
          'subject_focus_area': subjectFocusArea,
        },
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _msg(response.body) ?? 'AI preferences saved',
          isError: false,
        );
      } else {
        showCustomSnackBar(
          _msg(response.body) ?? 'Could not save preferences',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isAiPersonalizationLoading.value = false;
    }
  }

  /// POST `/2fa/parental-control/` — body: `related_email`, `relation_type` (`parent` | `child`).
  /// Returns `true` when the server accepts the invite (caller may clear the form).
  Future<bool> sendParentalControlInvite({
    required String relatedEmail,
    required String relationType,
  }) async {
    if (isParentalControlLoading.value) return false;
    final trimmed = relatedEmail.trim();
    if (trimmed.isEmpty) {
      showCustomSnackBar('Please enter an email', isError: true);
      return false;
    }
    if (!GetUtils.isEmail(trimmed)) {
      showCustomSnackBar('Please enter a valid email', isError: true);
      return false;
    }
    isParentalControlLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.sendParentalControlEndpoint,
        {
          'related_email': trimmed,
          'relation_type': relationType,
        },
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _msg(response.body) ?? 'Invite sent',
          isError: false,
        );
        return true;
      }
      showCustomSnackBar(
        _msg(response.body) ?? 'Could not send invite',
        isError: true,
      );
      return false;
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
      return false;
    } finally {
      isParentalControlLoading.value = false;
    }
  }

  Future<void> changePassword({required String newPassword}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiConstant.resetPassword,
        {'new_password': newPassword},
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          _msg(response.body) ?? 'Password changed successfully',
          isError: false,
        );
        Get.back();
      } else {
        showCustomSnackBar(
          _msg(response.body) ?? 'Could not change password',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }





}
