import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// ViewModel for managing app theme state and persistence
class ThemeViewModel extends ChangeNotifier {
  final StorageService _storageService;

  // Private state variables
  bool _isDarkMode = false;
  bool _isLoading = false;
  String? _error;

  // Constructor
  ThemeViewModel({
    StorageService? storageService,
  }) : _storageService = storageService ?? StorageService();

  // Getters
  bool get isDarkMode => _isDarkMode;
  
  bool get isLightMode => !_isDarkMode;
  
  bool get isLoading => _isLoading;
  
  String? get error => _error;

  /// Get the current theme mode as a string
  String get currentThemeMode => _isDarkMode ? 'Dark' : 'Light';

  /// Load theme preference from storage
  Future<void> loadThemePreference() async {
    _setLoading(true);
    _clearError();

    try {
      _isDarkMode = await _storageService.getThemePreference();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load theme preference: $e');
      // Keep default value (light mode) on error
      _isDarkMode = false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _clearError();

    try {
      final newThemeMode = !_isDarkMode;
      
      // Save to storage first
      await _storageService.saveThemePreference(newThemeMode);
      
      // Update local state
      _isDarkMode = newThemeMode;
      notifyListeners();
    } catch (e) {
      _setError('Failed to save theme preference: $e');
    }
  }

  /// Set theme to dark mode
  Future<void> setDarkMode() async {
    if (_isDarkMode) return; // Already in dark mode
    
    _clearError();

    try {
      await _storageService.saveThemePreference(true);
      _isDarkMode = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to set dark mode: $e');
    }
  }

  /// Set theme to light mode
  Future<void> setLightMode() async {
    if (!_isDarkMode) return; // Already in light mode
    
    _clearError();

    try {
      await _storageService.saveThemePreference(false);
      _isDarkMode = false;
      notifyListeners();
    } catch (e) {
      _setError('Failed to set light mode: $e');
    }
  }

  /// Set theme mode directly
  Future<void> setThemeMode(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) return; // No change needed
    
    _clearError();

    try {
      await _storageService.saveThemePreference(isDarkMode);
      _isDarkMode = isDarkMode;
      notifyListeners();
    } catch (e) {
      _setError('Failed to set theme mode: $e');
    }
  }

  /// Initialize theme with system preference fallback
  Future<void> initializeTheme({bool? systemDarkMode}) async {
    _setLoading(true);
    _clearError();

    try {
      // Try to load saved preference first
      final savedPreference = await _storageService.getThemePreference();
      _isDarkMode = savedPreference;
      
      // If no saved preference and system preference is provided, use it
      if (savedPreference == false && systemDarkMode == true) {
        _isDarkMode = true;
        // Save the system preference for future use
        await _storageService.saveThemePreference(true);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize theme: $e');
      // Fallback to system preference or light mode
      _isDarkMode = systemDarkMode ?? false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Reset theme to default (light mode)
  Future<void> resetToDefault() async {
    _clearError();

    try {
      await _storageService.saveThemePreference(false);
      _isDarkMode = false;
      notifyListeners();
    } catch (e) {
      _setError('Failed to reset theme: $e');
    }
  }

  /// Check if theme preference is saved in storage
  Future<bool> hasStoredPreference() async {
    try {
      // This is a simple check - if we can load without error, preference exists
      await _storageService.getThemePreference();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear any error state
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}