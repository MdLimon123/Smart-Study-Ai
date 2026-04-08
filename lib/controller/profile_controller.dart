import 'dart:io';

import 'package:flutter_extension/util/image_utils.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  


  Rx<File?> userProfileImage = Rx<File?>(null);
  
  Future<void> pickUserImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );
    if (pickedFile != null) {
      userProfileImage.value = pickedFile;
    }
  }



}
