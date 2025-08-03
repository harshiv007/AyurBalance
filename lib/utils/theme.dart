import 'package:flutter/material.dart';
import 'constants.dart';
import '../models/dosha.dart';

/// App theme configuration for light and dark modes
class AppTheme {
  // Wellness-focused color palette
  static const Color _primaryGreen = Color(0xFF4CAF50); // Calming green
  static const Color _primaryPurple = Color(0xFF7E57C2); // Spiritual purple
  static const Color _accentGold = Color(0xFFFFB74D); // Warm gold
  static const Color _backgroundCream = Color(0xFFFAF8F5); // Warm cream
  static const Color _backgroundDark = Color(0xFF1A1A1A); // Deep dark
  static const Color _surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color _surfaceDark = Color(0xFF2D2D2D); // Warm dark

  // Color scheme for light theme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primaryGreen,
    onPrimary: Colors.white,
    secondary: _accentGold,
    onSecondary: Colors.black87,
    tertiary: _primaryPurple,
    onTertiary: Colors.white,
    error: Color(0xFFE57373),
    onError: Colors.white,
    surface: _surfaceLight,
    onSurface: Colors.black87,
    surfaceContainerHighest: _backgroundCream,
    onSurfaceVariant: Colors.black87,
    outline: Color(0xFFE0E0E0),
    shadow: Color(0x1A000000),
  );

  // Color scheme for dark theme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF81C784),
    onPrimary: Colors.black,
    secondary: Color(0xFFFFCC80),
    onSecondary: Colors.black,
    tertiary: Color(0xFFB39DDB),
    onTertiary: Colors.black,
    error: Color(0xFFEF5350),
    onError: Colors.black,
    surface: _surfaceDark,
    onSurface: Colors.white,
    surfaceContainerHighest: _backgroundDark,
    onSurfaceVariant: Colors.white,
    outline: Color(0xFF404040),
    shadow: Color(0x33000000),
  );

  // Dosha colors
  static const Color vataColor = Color(AppConstants.vataColorValue);
  static const Color pittaColor = Color(AppConstants.pittaColorValue);
  static const Color kaphaColor = Color(AppConstants.kaphaColorValue);

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      fontFamily: 'Roboto',

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
        ),
        headlineLarge: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        headlineSmall: TextStyle(
          fontSize: AppConstants.subheadingTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.bodyTextSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.bodyTextSize,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _lightColorScheme.surfaceContainerHighest,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 0.15,
        ),
        iconTheme: const IconThemeData(color: Colors.black87, size: 24.0),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.smallPadding),
        color: _surfaceLight,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          side: BorderSide(color: _primaryGreen, width: 1.5),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 8,
        shape: CircleBorder(),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: _primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryGreen,
        linearTrackColor: Color(0xFFE8F5E8),
        linearMinHeight: 8.0,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _accentGold.withValues(alpha: 0.1),
        selectedColor: _accentGold,
        disabledColor: Colors.grey.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      fontFamily: 'Roboto',

      // Typography (same as light theme)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: AppConstants.subheadingTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.bodyTextSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.bodyTextSize,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.captionTextSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: Colors.white,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _darkColorScheme.surfaceContainerHighest,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24.0),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.smallPadding),
        color: _surfaceDark,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          side: const BorderSide(color: Color(0xFF81C784), width: 1.5),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 8,
        shape: CircleBorder(),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Color(0xFF81C784), width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF81C784),
        linearTrackColor: Color(0xFF2E4A2E),
        linearMinHeight: 8.0,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFCC80).withValues(alpha: 0.2),
        selectedColor: const Color(0xFFFFCC80),
        disabledColor: Colors.grey.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF404040),
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: Color(0xFF81C784),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Get dosha color by type
  static Color getDoshaColor(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return vataColor;
      case DoshaType.pitta:
        return pittaColor;
      case DoshaType.kapha:
        return kaphaColor;
    }
  }

  /// Get dosha name by type
  static String getDoshaName(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return 'Vata';
      case DoshaType.pitta:
        return 'Pitta';
      case DoshaType.kapha:
        return 'Kapha';
    }
  }

  /// Get prakriti type display name
  static String getPrakritiDisplayName(PrakritiType prakritiType) {
    switch (prakritiType) {
      case PrakritiType.vata:
        return 'Vata';
      case PrakritiType.pitta:
        return 'Pitta';
      case PrakritiType.kapha:
        return 'Kapha';
      case PrakritiType.vataPitta:
        return 'Vata-Pitta';
      case PrakritiType.pittaKapha:
        return 'Pitta-Kapha';
      case PrakritiType.vataKapha:
        return 'Vata-Kapha';
      case PrakritiType.tridoshic:
        return 'Tridoshic';
    }
  }

  /// Get gradient colors for dosha type
  static List<Color> getDoshaGradient(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return [vataColor, vataColor.withValues(alpha: 0.7)];
      case DoshaType.pitta:
        return [pittaColor, pittaColor.withValues(alpha: 0.7)];
      case DoshaType.kapha:
        return [kaphaColor, kaphaColor.withValues(alpha: 0.7)];
    }
  }

  /// Get light variant of dosha color
  static Color getDoshaLightColor(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return vataColor.withValues(alpha: 0.1);
      case DoshaType.pitta:
        return pittaColor.withValues(alpha: 0.1);
      case DoshaType.kapha:
        return kaphaColor.withValues(alpha: 0.1);
    }
  }

  /// Get text style for specific use cases
  static TextStyle getWellnessHeadingStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getCardTitleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600);
  }

  static TextStyle getBodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.5);
  }

  static TextStyle getCaptionStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }

  /// Get wellness-focused decoration for containers
  static BoxDecoration getWellnessCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Get gradient decoration for dosha-themed elements
  static BoxDecoration getDoshaGradientDecoration(DoshaType doshaType) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: getDoshaGradient(doshaType),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    );
  }
}
