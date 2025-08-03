import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'services/dependency_injection.dart';
import 'services/navigation_service.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/screens/welcome_screen.dart';
import 'views/screens/assessment_screen.dart';
import 'views/screens/results_screen.dart';
import 'views/screens/history_screen.dart';
import 'views/widgets/main_navigation.dart';

import 'models/assessment_result.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const AyurvedicPrakritiApp(),
    ),
  );
}

class AyurvedicPrakritiApp extends StatelessWidget {
  const AyurvedicPrakritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyInjection.createProviderTree(
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          // Initialize theme on first build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!themeViewModel.isLoading && themeViewModel.error == null) {
              themeViewModel.loadThemePreference();
            }
          });

          return MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,

              // Navigation configuration
              navigatorKey: NavigationService.navigatorKey,
              initialRoute: AppRoutes.welcome,
              routes: _buildRoutes(),
              onGenerateRoute: _onGenerateRoute,

              // Navigation behavior
              navigatorObservers: [AppNavigatorObserver()],
            );
        },
      ),
    );
  }

  /// Build the static routes map
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.welcome: (context) => const WelcomeScreen(),
      AppRoutes.mainNavigation: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final initialIndex = args is int ? args : 0;
        return MainNavigation(initialIndex: initialIndex);
      },
      AppRoutes.assessment: (context) =>
          const BackButtonHandler(child: AssessmentScreen()),
      AppRoutes.history: (context) => const HistoryScreen(),
    };
  }

  /// Handle routes that require parameters
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.results:
        final args = settings.arguments;
        if (args is AssessmentResult) {
          return MaterialPageRoute(
            builder: (context) =>
                BackButtonHandler(child: ResultsScreen(result: args)),
            settings: settings,
          );
        }
        // If no valid arguments, redirect to welcome
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
          settings: const RouteSettings(name: AppRoutes.welcome),
        );

      default:
        // Unknown route, redirect to welcome
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
          settings: const RouteSettings(name: AppRoutes.welcome),
        );
    }
  }
}

/// Widget that handles back button behavior for specific screens
class BackButtonHandler extends StatelessWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != null) {
          final shouldPop = await NavigationService.handleBackButton(
            context,
            currentRoute,
          );
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}

/// Custom navigator observer for handling navigation events
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  void _logNavigation(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    if (route?.settings.name != null) {
      debugPrint('Navigation $action: ${route?.settings.name}');
    }
  }
}
