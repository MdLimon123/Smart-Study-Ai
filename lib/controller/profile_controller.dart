import 'dart:io';

import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/profile_model.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  final RxBool isProfileLoading = false.obs;
  final RxBool isUpdatingImage = false.obs;

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
        if (body is Map &&
            body['data'] != null &&
            body['data'] is Map) {
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
        if (body is Map &&
            body['data'] != null &&
            body['data'] is Map) {
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
}
