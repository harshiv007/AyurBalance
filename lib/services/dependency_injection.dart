import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/assessment_viewmodel.dart';
import '../viewmodels/results_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../services/assessment_service.dart';
import '../services/storage_service.dart';
import '../services/dosha_calculator.dart';

/// Dependency injection configuration for the app
class DependencyInjection {
  /// Create and configure all providers for the app
  static List<ChangeNotifierProvider> createProviders() {
    // Create service instances
    final storageService = StorageService();
    final doshaCalculator = DoshaCalculator();
    final assessmentService = AssessmentService(doshaCalculator: doshaCalculator);

    return [
      // Theme ViewModel
      ChangeNotifierProvider<ThemeViewModel>(
        create: (_) => ThemeViewModel(storageService: storageService),
        lazy: false, // Initialize immediately for theme loading
      ),

      // Assessment ViewModel
      ChangeNotifierProvider<AssessmentViewModel>(
        create: (_) => AssessmentViewModel(
          assessmentService: assessmentService,
          storageService: storageService,
        ),
      ),

      // Results ViewModel
      ChangeNotifierProvider<ResultsViewModel>(
        create: (_) => ResultsViewModel(storageService: storageService),
      ),
    ];
  }

  /// Create providers with shared service instances
  static List<Provider> createServiceProviders() {
    // Create shared service instances
    final storageService = StorageService();
    final doshaCalculator = DoshaCalculator();
    final assessmentService = AssessmentService(doshaCalculator: doshaCalculator);

    return [
      Provider<StorageService>.value(value: storageService),
      Provider<DoshaCalculator>.value(value: doshaCalculator),
      Provider<AssessmentService>.value(value: assessmentService),
    ];
  }

  /// Create a complete provider tree with services and ViewModels
  static Widget createProviderTree({required Widget child}) {
    return MultiProvider(
      providers: [
        // Service providers (shared instances)
        ...createServiceProviders(),
        
        // ViewModel providers (with proper dependencies)
        ChangeNotifierProxyProvider<StorageService, ThemeViewModel>(
          create: (context) => ThemeViewModel(
            storageService: Provider.of<StorageService>(context, listen: false),
          ),
          update: (context, storageService, previous) => previous ?? ThemeViewModel(
            storageService: storageService,
          ),
          lazy: false,
        ),

        ChangeNotifierProxyProvider2<AssessmentService, StorageService, AssessmentViewModel>(
          create: (context) => AssessmentViewModel(
            assessmentService: Provider.of<AssessmentService>(context, listen: false),
            storageService: Provider.of<StorageService>(context, listen: false),
          ),
          update: (context, assessmentService, storageService, previous) => 
            previous ?? AssessmentViewModel(
              assessmentService: assessmentService,
              storageService: storageService,
            ),
        ),

        ChangeNotifierProxyProvider<StorageService, ResultsViewModel>(
          create: (context) => ResultsViewModel(
            storageService: Provider.of<StorageService>(context, listen: false),
          ),
          update: (context, storageService, previous) => previous ?? ResultsViewModel(
            storageService: storageService,
          ),
        ),
      ],
      child: child,
    );
  }
}

/// Extension methods for easier ViewModel access
extension ViewModelExtensions on BuildContext {
  /// Get AssessmentViewModel
  AssessmentViewModel get assessmentViewModel => 
      Provider.of<AssessmentViewModel>(this, listen: false);

  /// Get ResultsViewModel
  ResultsViewModel get resultsViewModel => 
      Provider.of<ResultsViewModel>(this, listen: false);

  /// Get ThemeViewModel
  ThemeViewModel get themeViewModel => 
      Provider.of<ThemeViewModel>(this, listen: false);

  /// Watch AssessmentViewModel
  AssessmentViewModel watchAssessmentViewModel() => 
      Provider.of<AssessmentViewModel>(this);

  /// Watch ResultsViewModel
  ResultsViewModel watchResultsViewModel() => 
      Provider.of<ResultsViewModel>(this);

  /// Watch ThemeViewModel
  ThemeViewModel watchThemeViewModel() => 
      Provider.of<ThemeViewModel>(this);
}

/// Mixin for widgets that need ViewModel lifecycle management
mixin ViewModelLifecycleMixin<T extends StatefulWidget> on State<T> {
  /// Initialize ViewModels when the widget is created
  @protected
  void initializeViewModels() {
    // Override in subclasses to initialize specific ViewModels
  }

  /// Dispose ViewModels when the widget is destroyed
  @protected
  void disposeViewModels() {
    // Override in subclasses to dispose specific ViewModels
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeViewModels();
    });
  }

  @override
  void dispose() {
    disposeViewModels();
    super.dispose();
  }
}

/// Provider for managing ViewModel initialization state
class ViewModelInitializationProvider extends ChangeNotifier {
  final Map<Type, bool> _initializationStates = {};

  /// Check if a ViewModel type is initialized
  bool isInitialized<T>() => _initializationStates[T] ?? false;

  /// Mark a ViewModel type as initialized
  void markInitialized<T>() {
    _initializationStates[T] = true;
    notifyListeners();
  }

  /// Reset initialization state for a ViewModel type
  void resetInitialization<T>() {
    _initializationStates[T] = false;
    notifyListeners();
  }

  /// Reset all initialization states
  void resetAll() {
    _initializationStates.clear();
    notifyListeners();
  }
}