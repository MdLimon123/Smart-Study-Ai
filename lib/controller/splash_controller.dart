import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/helper/route_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  /// No token → onboarding. Has token → main (API headers synced via [ApiClient.loadPrefs]).
  Future<void> jumpNextScreen() async {
    final token = await PrefsHelper.getString(AppConstants.TOKEN);
    if (token.isEmpty) {
      Get.offNamed(AppRoutes.onboardingScreen);
      return;
    }
    await ApiClient.loadPrefs();
    Get.offNamed(AppRoutes.mainScreen);
  }
}
