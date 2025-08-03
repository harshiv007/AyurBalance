import 'package:flutter/material.dart';
import '../models/assessment_result.dart';

/// Service for handling app navigation and back button behavior
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get the current context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to welcome screen (home)
  static Future<void> navigateToWelcome() {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (route) => false,
    );
  }

  /// Navigate to assessment screen
  static Future<void> navigateToAssessment() {
    return navigatorKey.currentState!.pushNamed(AppRoutes.assessment);
  }

  /// Navigate to results screen with result data
  static Future<void> navigateToResults(AssessmentResult result) {
    return navigatorKey.currentState!.pushNamed(
      AppRoutes.results,
      arguments: result,
    );
  }

  /// Replace current screen with results screen
  static Future<void> replaceWithResults(AssessmentResult result) {
    return navigatorKey.currentState!.pushReplacementNamed(
      AppRoutes.results,
      arguments: result,
    );
  }

  /// Navigate to history screen
  static Future<void> navigateToHistory() {
    return navigatorKey.currentState!.pushNamed(AppRoutes.history);
  }

  /// Navigate to main navigation with specific tab
  static Future<void> navigateToMainNavigation({int tabIndex = 0}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.mainNavigation,
      (route) => false,
      arguments: tabIndex,
    );
  }

  /// Go back to previous screen
  static void goBack() {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
    }
  }

  /// Check if can go back
  static bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  /// Handle back button press with custom logic
  static Future<bool> handleBackButton(BuildContext context, String currentRoute) async {
    switch (currentRoute) {
      case AppRoutes.assessment:
        // Show confirmation dialog for assessment
        return await _showAssessmentExitDialog(context) ?? false;
      
      case AppRoutes.results:
        // Go back to main navigation instead of previous screen
        navigateToMainNavigation();
        return true; // Prevent default back behavior
      
      case AppRoutes.welcome:
      case AppRoutes.mainNavigation:
        // Allow system to handle (exit app)
        return false;
      
      default:
        // Default back behavior
        return false;
    }
  }

  /// Show confirmation dialog when exiting assessment
  static Future<bool?> _showAssessmentExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Assessment?'),
        content: const Text(
          'Your progress will be lost if you leave now. Are you sure you want to go back?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  /// Clear navigation stack and go to welcome
  static void resetToWelcome() {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (route) => false,
    );
  }

  /// Get current route name
  static String? getCurrentRouteName() {
    final route = ModalRoute.of(currentContext!);
    return route?.settings.name;
  }
}

/// App route constants
class AppRoutes {
  static const String welcome = '/';
  static const String mainNavigation = '/main';
  static const String assessment = '/assessment';
  static const String results = '/results';
  static const String history = '/history';
}