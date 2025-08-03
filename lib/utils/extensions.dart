import 'package:flutter/material.dart';
import 'constants.dart';
import '../models/question.dart';
import '../models/dosha.dart';
import '../models/recommendation.dart';

/// Extensions for enhanced functionality
extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convert string to title case
  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}

extension QuestionCategoryExtensions on QuestionCategory {
  /// Get display name for question category
  String get displayName {
    switch (this) {
      case QuestionCategory.physicalTraits:
        return 'Physical Traits';
      case QuestionCategory.mentalEmotional:
        return 'Mental & Emotional';
      case QuestionCategory.habitsPreferences:
        return 'Habits & Preferences';
      case QuestionCategory.environmentalReactions:
        return 'Environmental Reactions';
    }
  }

  /// Get description for question category
  String get description {
    switch (this) {
      case QuestionCategory.physicalTraits:
        return 'Questions about your physical characteristics';
      case QuestionCategory.mentalEmotional:
        return 'Questions about your mental and emotional patterns';
      case QuestionCategory.habitsPreferences:
        return 'Questions about your daily habits and preferences';
      case QuestionCategory.environmentalReactions:
        return 'Questions about how you react to environmental factors';
    }
  }

  /// Get icon for question category
  IconData get icon {
    switch (this) {
      case QuestionCategory.physicalTraits:
        return Icons.person;
      case QuestionCategory.mentalEmotional:
        return Icons.psychology;
      case QuestionCategory.habitsPreferences:
        return Icons.schedule;
      case QuestionCategory.environmentalReactions:
        return Icons.wb_sunny;
    }
  }
}

extension DoshaTypeExtensions on DoshaType {
  /// Get display name for dosha type
  String get displayName {
    switch (this) {
      case DoshaType.vata:
        return 'Vata';
      case DoshaType.pitta:
        return 'Pitta';
      case DoshaType.kapha:
        return 'Kapha';
    }
  }

  /// Get description for dosha type
  String get description {
    switch (this) {
      case DoshaType.vata:
        return 'Air and Space elements - Movement and creativity';
      case DoshaType.pitta:
        return 'Fire and Water elements - Transformation and metabolism';
      case DoshaType.kapha:
        return 'Earth and Water elements - Structure and stability';
    }
  }

  /// Get primary color for dosha type
  Color get primaryColor {
    switch (this) {
      case DoshaType.vata:
        return const Color(AppConstants.vataColorValue);
      case DoshaType.pitta:
        return const Color(AppConstants.pittaColorValue);
      case DoshaType.kapha:
        return const Color(AppConstants.kaphaColorValue);
    }
  }
}

extension RecommendationTypeExtensions on RecommendationType {
  /// Get display name for recommendation type
  String get displayName {
    switch (this) {
      case RecommendationType.diet:
        return 'Diet';
      case RecommendationType.lifestyle:
        return 'Lifestyle';
      case RecommendationType.sleep:
        return 'Sleep';
      case RecommendationType.stressManagement:
        return 'Stress Management';
      case RecommendationType.seasonal:
        return 'Seasonal';
    }
  }

  /// Get icon for recommendation type
  IconData get icon {
    switch (this) {
      case RecommendationType.diet:
        return Icons.restaurant;
      case RecommendationType.lifestyle:
        return Icons.directions_walk;
      case RecommendationType.sleep:
        return Icons.bedtime;
      case RecommendationType.stressManagement:
        return Icons.self_improvement;
      case RecommendationType.seasonal:
        return Icons.calendar_today;
    }
  }
}

extension BuildContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Show snackbar with message
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}
