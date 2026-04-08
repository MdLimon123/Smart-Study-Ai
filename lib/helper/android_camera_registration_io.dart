import 'dart:io' show Platform;

import 'package:camera_android/camera_android.dart';

/// Use Camera2 instead of default CameraX — avoids preview/surface bugs when
/// leaving and re-entering the scan screen (see camera_android_camerax issues).
void ensureAndroidCamera2Plugin() {
  if (Platform.isAndroid) {
    AndroidCamera.registerWith();
  }
}
