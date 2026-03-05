import 'package:flutter_extension/helper/route_helper.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  jumpNextScreen() {
    // Logic to determine the next screen
    // For example, check if user is logged in
    Get.offNamed(AppRoutes.onboardingScreen);
  }
}
