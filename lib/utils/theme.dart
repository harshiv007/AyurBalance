import 'package:flutter/material.dart';
import 'constants.dart';
import '../models/dosha.dart';

/// App theme configuration for light and dark modes
class AppTheme {
  // Color scheme for light theme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6B73FF),
    onPrimary: Colors.white,
    secondary: Color(0xFF03DAC6),
    onSecondary: Colors.black,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Color(0xFFF5F5F5),
    onSurface: Colors.black87,
  );

  // Color scheme for dark theme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8E7CC3),
    onPrimary: Colors.black,
    secondary: Color(0xFF03DAC6),
    onSecondary: Colors.black,
    error: Color(0xFFCF6679),
    onError: Colors.black,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
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
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.smallPadding),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
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
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        linearTrackColor: Color(0xFFE0E0E0),
        linearMinHeight: 6.0,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      fontFamily: 'Roboto',
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.headingTextSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.smallPadding),
        color: const Color(0xFF2C2C2C),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
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
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        linearTrackColor: Color(0xFF404040),
        linearMinHeight: 6.0,
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
}