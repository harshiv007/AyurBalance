/// App-wide constants for the Ayurvedic Prakriti Assessment app
class AppConstants {
  // App Information
  static const String appName = 'Ayurvedic Prakriti Assessment';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String themePreferenceKey = 'theme_preference';
  static const String assessmentHistoryKey = 'assessment_history';

  // Assessment Configuration
  static const int totalQuestions = 40;
  static const int questionsPerCategory = 10;

  // Dosha Colors
  static const int vataColorValue = 0xFF8E7CC3; // Purple
  static const int pittaColorValue = 0xFFE74C3C; // Red
  static const int kaphaColorValue = 0xFF27AE60; // Green

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Text Sizes
  static const double headingTextSize = 24.0;
  static const double subheadingTextSize = 18.0;
  static const double bodyTextSize = 16.0;
  static const double captionTextSize = 14.0;
}

// Note: Enums are defined in their respective model files:
// - QuestionCategory in lib/models/question.dart
// - DoshaType in lib/models/dosha.dart
// - PrakritiType in lib/models/dosha.dart
// - RecommendationType in lib/models/recommendation.dart
