import 'package:flutter_extension/views/screen/Splash/onboarding_screen.dart';
import 'package:flutter_extension/views/screen/Splash/onboarding_screen2.dart';
import 'package:flutter_extension/views/screen/Splash/onboarding_screen3.dart';
import 'package:flutter_extension/views/screen/auth/login_screen.dart';
import 'package:flutter_extension/views/screen/auth/setupProfile/setup_profile_screen.dart';
import 'package:flutter_extension/views/screen/auth/signup_screen.dart';
import 'package:flutter_extension/views/screen/home/home_screen.dart';
import 'package:flutter_extension/views/screen/main/main_screen.dart';
import 'package:get/get.dart';

import '../views/screen/splash/splash_screen.dart';

class AppRoutes {
  static String splashScreen = "/splash_screen";
  static String onboardingScreen = "/onboarding_screen";
  static String onboardingScreen2 = "/onboarding_screen2";
  static String onboardingScreen3 = "/onboarding_screen3";
  static String signupScreen = "/signup_screen";
  static String setupProfileScreen = "/setup_profile_screen";
  static String loginScreen = "/login_screen";
  static String homeScreen = "/home_screen";
  static String mainScreen = "/main_screen";

  static List<GetPage> page = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: onboardingScreen2, page: () => const OnboardingScreen2()),
    GetPage(name: onboardingScreen3, page: () => const OnboardingScreen3()),
    GetPage(name: signupScreen, page: () => const SignupScreen()),
    GetPage(name: setupProfileScreen, page: () => const SetupProfileScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: mainScreen, page: () => const MainScreen()),
  ];
}
