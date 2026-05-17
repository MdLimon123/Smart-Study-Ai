import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class AppColors {
  static bool get isDark {
    try {
      if (Get.isRegistered<ThemeController>()) {
        return Get.find<ThemeController>().darkTheme;
      }
    } catch (_) {}
    if (Get.context != null) {
      return Theme.of(Get.context!).brightness == Brightness.dark;
    }
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  static Color get primaryColor => const Color(0xFF7C3AED); // Premium purple
  
  static Color get backgroundColor => isDark ? const Color(0xFF0F0F1A) : const Color(0xFFFAF9F6);
  
  static Color get cardColor => isDark ? const Color(0xFF1E1E24) : const Color(0xFFFFFFFF);
  
  static Color get cardLightColor => isDark ? const Color(0xFF252530) : const Color(0xFFE5E7EB);
  
  static Color get borderColor => isDark ? const Color(0xFF2A2A35) : const Color(0xFFE5E7EB);
  
  static Color get textColor => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1F2937);
  
  static Color get subTextColor => isDark ? const Color(0xFFE8E8E8) : const Color(0xFF6B7280);
  
  static Color get hintColor => isDark ? const Color(0xFFB5B5B5) : const Color(0xFF9CA3AF);
  
  static Color get greyColor => const Color(0xFFB5B5B5);
  
  static Color get fillColor => isDark 
      ? const Color(0xFFE9F3FD).withValues(alpha: 0.1) 
      : const Color(0xFFE9F3FD).withValues(alpha: 0.8);
      
  static Color get dividerColor => isDark ? const Color(0xFF2A2A35) : const Color(0xFFE5E7EB);
  
  static Color get shadowColor => isDark 
      ? const Color(0xFF000000).withValues(alpha: 0.3) 
      : const Color(0xFF000000).withValues(alpha: 0.05);
  
  static Color get bottomBarColor => isDark ? const Color(0xFF14141E) : const Color(0xFFFFFFFF);

  static Color get surface => isDark ? const Color(0xFF16161F) : const Color(0xFFFFFFFF);
  
  static Color get surfaceBorder => isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE5E7EB);

  static const Color textSecondary = Color(0xFF8888AA);
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentSecondary = Color(0xFF4F46E5);

  static BoxShadow get shadow => BoxShadow(
    blurRadius: 10,
    spreadRadius: 0,
    color: shadowColor,
    offset: const Offset(0, 4),
  );
}
