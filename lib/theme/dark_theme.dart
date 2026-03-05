import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData dark({Color color = const Color(0xFF397DFF)}) {
  final darkColorScheme = ColorScheme.dark(
    primary: color,
    onPrimary: Colors.white,
    primaryContainer: color.withValues(alpha: 0.15),
    onPrimaryContainer: color,
    secondary: const Color(0xFF009F67),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFF009F67).withValues(alpha: 0.15),
    onSecondaryContainer: const Color(0xFF00E08A),
    tertiary: const Color(0xFFBB86FC),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFBB86FC).withValues(alpha: 0.15),
    onTertiaryContainer: const Color(0xFFD4BBFF),
    error: const Color(0xFFFF6B6B),
    onError: Colors.white,
    errorContainer: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
    onErrorContainer: const Color(0xFFFF9E9E),
    surface: const Color(0xFF121212),
    onSurface: const Color(0xFFE8E8E8),
    surfaceContainerHighest: const Color(0xFF2F2F2F),
    onSurfaceVariant: const Color(0xFFB5B5B5),
    outline: const Color(0xFF555555),
    outlineVariant: const Color(0xFF3A3A3A),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: const Color(0xFFE8E8E8),
    onInverseSurface: const Color(0xFF1A1A1A),
    inversePrimary: const Color(0xFF1A5CD6),
    surfaceTint: color,
  );

  return ThemeData(
    fontFamily: 'Lato',
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: color,
    secondaryHeaderColor: const Color(0xFF009F67),
    disabledColor: const Color(0xFF5A5A5A),
    hintColor: const Color(0xFFB5B5B5),
    cardColor: const Color(0xFF1E1E1E),
    canvasColor: const Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    shadowColor: Colors.black54,
    splashColor: color.withValues(alpha: 0.12),
    highlightColor: color.withValues(alpha: 0.08),
    colorScheme: darkColorScheme,
    dividerColor: const Color(0xFF2A2A2A),

    // ─── AppBar ───
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      backgroundColor: const Color(0xFF0A0A0A),
      foregroundColor: const Color(0xFFE8E8E8),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      iconTheme: const IconThemeData(color: Color(0xFFE8E8E8), size: 24),
      actionsIconTheme: IconThemeData(color: color, size: 24),
      titleTextStyle: const TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFE8E8E8),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: const Color(0xFF0A0A0A),
      ),
    ),

    // ─── Card ───
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black45,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),

    // ─── ElevatedButton ───
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF3A3A3A),
        disabledForegroundColor: const Color(0xFF6A6A6A),
        elevation: 2,
        shadowColor: color.withValues(alpha: 0.35),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // ─── TextButton ───
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: const Color(0xFF6A6A6A),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    ),

    // ─── OutlinedButton ───
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: const Color(0xFF6A6A6A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // ─── IconButton ───
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: const Color(0xFFE8E8E8),
        hoverColor: color.withValues(alpha: 0.08),
        highlightColor: color.withValues(alpha: 0.12),
      ),
    ),

    // ─── FloatingActionButton ───
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color,
      foregroundColor: Colors.white,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 6,
      splashColor: Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),

    // ─── InputDecoration (TextField) ───
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1D1929),
      hintStyle: const TextStyle(
        color: Color(0xFF77757F),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: color.withValues(alpha: 0.8),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFFF6B6B),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF4A4754), width: 1),
      ),
      prefixIconColor: const Color(0xFFB5B5B5),
      suffixIconColor: const Color(0xFFB5B5B5),
    ),

    // ─── BottomNavigationBar ───
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF141414),
      selectedItemColor: color,
      unselectedItemColor: const Color(0xFF7A7A7A),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      selectedIconTheme: IconThemeData(color: color, size: 26),
      unselectedIconTheme: const IconThemeData(
        color: Color(0xFF7A7A7A),
        size: 24,
      ),
    ),

    // ─── NavigationBar (Material 3) ───
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF141414),
      indicatorColor: color.withValues(alpha: 0.15),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 70,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: color, size: 26);
        }
        return const IconThemeData(color: Color(0xFF7A7A7A), size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Color(0xFF7A7A7A),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
      }),
    ),

    // ─── TabBar ───
    tabBarTheme: TabBarThemeData(
      labelColor: color,
      unselectedLabelColor: const Color(0xFF7A7A7A),
      indicatorColor: color,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: const Color(0xFF2A2A2A),
      labelStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      overlayColor: WidgetStateProperty.all(color.withValues(alpha: 0.08)),
    ),

    // ─── BottomSheet ───
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: Color(0xFF1A1A1A),
      elevation: 8,
      modalElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      dragHandleColor: Color(0xFF555555),
      dragHandleSize: Size(40, 4),
      showDragHandle: true,
    ),

    // ─── Dialog ───
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      elevation: 16,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFE8E8E8),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFB5B5B5),
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    ),

    // ─── SnackBar ───
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF2F2F2F),
      contentTextStyle: const TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFE8E8E8),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: color,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // ─── Chip ───
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedColor: color.withValues(alpha: 0.2),
      disabledColor: const Color(0xFF2A2A2A),
      labelStyle: const TextStyle(
        color: Color(0xFFE8E8E8),
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      secondaryLabelStyle: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      side: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      showCheckmark: true,
      checkmarkColor: color,
    ),

    // ─── PopupMenu ───
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFE8E8E8),
        fontSize: 15,
      ),
    ),

    // ─── Dropdown ───
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
      ),
    ),

    // ─── Divider ───
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A2A),
      thickness: 0.5,
      space: 1,
    ),

    // ─── ListTile ───
    listTileTheme: ListTileThemeData(
      iconColor: const Color(0xFFB5B5B5),
      textColor: const Color(0xFFE8E8E8),
      tileColor: Colors.transparent,
      selectedTileColor: color.withValues(alpha: 0.08),
      selectedColor: color,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFE8E8E8),
      ),
      subtitleTextStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8A8A8A),
      ),
    ),

    // ─── Switch ───
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return const Color(0xFF7A7A7A);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return color.withValues(alpha: 0.35);
        }
        return const Color(0xFF3A3A3A);
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ─── Checkbox ───
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: Color(0xFF7A7A7A), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    // ─── Radio ───
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return const Color(0xFF7A7A7A);
      }),
    ),

    // ─── Slider ───
    sliderTheme: SliderThemeData(
      activeTrackColor: color,
      inactiveTrackColor: color.withValues(alpha: 0.2),
      thumbColor: color,
      overlayColor: color.withValues(alpha: 0.12),
      valueIndicatorColor: color,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // ─── ProgressIndicator ───
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: color,
      linearTrackColor: color.withValues(alpha: 0.15),
      circularTrackColor: color.withValues(alpha: 0.15),
    ),

    // ─── Tooltip ───
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Color(0xFFE8E8E8), fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // ─── Drawer ───
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF141414),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      scrimColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
    ),

    // ─── NavigationRail ───
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: const Color(0xFF141414),
      selectedIconTheme: IconThemeData(color: color, size: 26),
      unselectedIconTheme: const IconThemeData(
        color: Color(0xFF7A7A7A),
        size: 24,
      ),
      selectedLabelTextStyle: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Color(0xFF7A7A7A),
        fontSize: 13,
      ),
      indicatorColor: color.withValues(alpha: 0.15),
    ),

    // ─── Badge ───
    badgeTheme: const BadgeThemeData(
      backgroundColor: Color(0xFFFF6B6B),
      textColor: Colors.white,
      textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
    ),

    // ─── SearchBar ───
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(const Color(0xFF1A1A1A)),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      hintStyle: WidgetStateProperty.all(
        const TextStyle(color: Color(0xFF7A7A7A), fontSize: 16),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(color: Color(0xFFE8E8E8), fontSize: 16),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

    // ─── Scrollbar ───
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFF555555)),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(8),
      thickness: WidgetStateProperty.all(4),
      thumbVisibility: WidgetStateProperty.all(false),
    ),

    // ─── DatePicker ───
    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: color,
      headerForegroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return const Color(0xFFE8E8E8);
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return color;
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.all(color),
      todayBorder: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // ─── TimePicker ───
    timePickerTheme: TimePickerThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      dialBackgroundColor: const Color(0xFF2A2A2A),
      dialHandColor: color,
      hourMinuteColor: const Color(0xFF2A2A2A),
      hourMinuteTextColor: const Color(0xFFE8E8E8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // ─── Text Selection ───
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: color,
      selectionColor: color.withValues(alpha: 0.3),
      selectionHandleColor: color,
    ),

    // ─── Icon ───
    iconTheme: const IconThemeData(color: Color(0xFFE8E8E8), size: 24),

    // ─── Primary Icon ───
    primaryIconTheme: IconThemeData(color: color, size: 24),

    // ─── Text ───
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w300,
        fontSize: 57,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w300,
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400,
        fontSize: 36,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w500,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: Color(0xFFB5B5B5),
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        color: Color(0xFFE8E8E8),
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: Color(0xFFB5B5B5),
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        color: Color(0xFFB5B5B5),
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    ),

    // ─── PageTransitions ───
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
