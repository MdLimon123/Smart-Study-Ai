import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_constants.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  String _themeSetting = "system"; // "dark", "light", "system"

  String get themeSetting => _themeSetting;

  ThemeMode get themeMode {
    if (_themeSetting == "dark") {
      return ThemeMode.dark;
    } else if (_themeSetting == "light") {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  bool get darkTheme {
    if (_themeSetting == "system") {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeSetting == "dark";
  }

  void setThemeSetting(String setting) {
    _themeSetting = setting;
    sharedPreferences.setString("theme_setting", setting);
    // Legacy support: update THEME boolean
    sharedPreferences.setBool(AppConstants.THEME, darkTheme);
    Get.changeThemeMode(themeMode);
    update();
  }

  void _loadCurrentTheme() async {
    _themeSetting = sharedPreferences.getString("theme_setting") ?? "system";
    update();
  }
}
