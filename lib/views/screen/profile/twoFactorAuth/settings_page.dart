import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/localization_controller.dart';
import 'package:flutter_extension/controller/theme_controller.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Color _getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1F2937);
  }

  Color _getSubTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  }

  Color _getCardBgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1E1E24) : const Color(0xFFF3F4F6);
  }

  Color _getBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A35) : const Color(0xFFE5E7EB);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);
    final subTextColor = _getSubTextColor(context);
    final borderColor = _getBorderColor(context);
    final cardBgColor = _getCardBgColor(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cardBgColor,
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Icon(Icons.arrow_back, color: textColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "settings".tr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  'manage_account_settings'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THEME SETTING SECTION ---
              Text(
                "theme_mode".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "choose_appearance".tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<ThemeController>(
                builder: (themeController) {
                  final activeSetting = themeController.themeSetting;
                  return Row(
                    children: [
                      // Light mode card
                      Expanded(
                        child: _buildThemeCard(
                          context: context,
                          title: "light".tr,
                          subtitle: "bright_layout".tr,
                          icon: Icons.light_mode_outlined,
                          isSelected: activeSetting == "light",
                          onTap: () => themeController.setThemeSetting("light"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Dark mode card
                      Expanded(
                        child: _buildThemeCard(
                          context: context,
                          title: "dark".tr,
                          subtitle: "easy_on_eyes".tr,
                          icon: Icons.dark_mode_outlined,
                          isSelected: activeSetting == "dark",
                          onTap: () => themeController.setThemeSetting("dark"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // System default mode card
                      Expanded(
                        child: _buildThemeCard(
                          context: context,
                          title: "system".tr,
                          subtitle: "match_device".tr,
                          icon: Icons.brightness_auto_outlined,
                          isSelected: activeSetting == "system",
                          onTap: () => themeController.setThemeSetting("system"),
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 32),
              Divider(height: 1, thickness: 0.5, color: borderColor),
              const SizedBox(height: 32),

              // --- LANGUAGE SETTING SECTION ---
              Text(
                "language_preference".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "select_default_language".tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<LocalizationController>(
                builder: (localizeController) {
                  final bool isAuto = localizeController.isAutoDetect;
                  final activeLocale = localizeController.locale;
                  const activeColor = Color(0xFF7C3AED);

                  // Build dropdown items: "Auto Detect" + all languages
                  final List<DropdownMenuItem<String>> items = [
                    DropdownMenuItem<String>(
                      value: 'auto',
                      child: Row(
                        children: [
                          Icon(Icons.public, size: 20, color: isAuto ? activeColor : subTextColor),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "auto_detect".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "${'system_default'.tr} (${_getSystemLanguageLabel()})",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(localizeController.languages.length, (index) {
                      final language = localizeController.languages[index];
                      return DropdownMenuItem<String>(
                        value: language.languageCode,
                        child: Row(
                          children: [
                            Icon(Icons.language, size: 20, color: subTextColor),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  language.languageName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  _getLanguageNativeLabel(language.languageCode),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ];

                  // Current selected value
                  final String currentValue = isAuto ? 'auto' : activeLocale.languageCode;

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: cardBgColor.withValues(alpha: 0.5),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentValue,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: subTextColor),
                        dropdownColor: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        items: items,
                        onChanged: (value) {
                          if (value == null) return;
                          if (value == 'auto') {
                            localizeController.setLanguage(
                              Locale(
                                AppConstants.languages[0].languageCode,
                                AppConstants.languages[0].countryCode,
                              ),
                              autoDetect: true,
                            );
                          } else {
                            final lang = localizeController.languages.firstWhere(
                              (l) => l.languageCode == value,
                            );
                            localizeController.setLanguage(
                              Locale(lang.languageCode, lang.countryCode),
                              autoDetect: false,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSystemLanguageLabel() {
    final systemLocale = Get.deviceLocale;
    if (systemLocale == null) return "English";
    for (final lang in AppConstants.languages) {
      if (lang.languageCode == systemLocale.languageCode) {
        return lang.languageName;
      }
    }
    return "English";
  }

  String _getLanguageNativeLabel(String code) {
    switch (code) {
      case 'en':
        return 'English (US)';
      case 'ar':
        return 'العربية (Arabic)';
      case 'es':
        return 'Español (Spanish)';
      case 'fr':
        return 'Français (French)';
      default:
        return '';
    }
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF7C3AED); // Premium purple
    final textColor = _getTextColor(context);
    final subTextColor = _getSubTextColor(context);
    final cardBgColor = _getCardBgColor(context);
    final borderColor = _getBorderColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? activeColor.withValues(alpha: 0.08)
              : cardBgColor,
          border: Border.all(
            color: isSelected
                ? activeColor
                : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : subTextColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? activeColor : textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected ? activeColor.withValues(alpha: 0.8) : subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

}