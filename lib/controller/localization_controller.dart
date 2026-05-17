import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/language_model.dart';
import '../util/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  bool _isAutoDetect = false;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;
  bool get isAutoDetect => _isAutoDetect;

  void setLanguage(Locale locale, {bool autoDetect = false}) {
    _isAutoDetect = autoDetect;
    if (autoDetect) {
      sharedPreferences.setString(AppConstants.LANGUAGE_CODE, "auto");
      sharedPreferences.setString(AppConstants.COUNTRY_CODE, "");
      final device = Get.deviceLocale;
      if (device != null) {
        final matches = AppConstants.languages.any((l) => l.languageCode == device.languageCode);
        if (matches) {
          _locale = device;
        } else {
          _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
        }
      } else {
        _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
      }
      _selectedIndex = -1;
    } else {
      _locale = locale;
      saveLanguage(_locale);
      _selectedIndex = 0;
      for(int index = 0; index<AppConstants.languages.length; index++) {
        if(AppConstants.languages[index].languageCode == _locale.languageCode) {
          _selectedIndex = index;
          break;
        }
      }
    }
    
    Get.updateLocale(_locale);
    _isLtr = _locale.languageCode != 'ar';
    update();
  }

  void loadCurrentLanguage() async {
    final code = sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? "auto";
    if (code == "auto") {
      _isAutoDetect = true;
      final device = Get.deviceLocale;
      if (device != null) {
        final matches = AppConstants.languages.any((l) => l.languageCode == device.languageCode);
        if (matches) {
          _locale = device;
        } else {
          _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
        }
      } else {
        _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
      }
      _selectedIndex = -1;
    } else {
      _isAutoDetect = false;
      _locale = Locale(code, sharedPreferences.getString(AppConstants.COUNTRY_CODE) ?? "");
      _selectedIndex = 0;
      for(int index = 0; index<AppConstants.languages.length; index++) {
        if(AppConstants.languages[index].languageCode == _locale.languageCode) {
          _selectedIndex = index;
          break;
        }
      }
    }
    
    _isLtr = _locale.languageCode != 'ar';
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode ?? "");
  }

  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      AppConstants.languages.forEach((language) async {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      });
    }
    update();
  }
}