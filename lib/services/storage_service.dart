import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assessment_result.dart';

class StorageService {
  static const String _assessmentResultsKey = 'assessment_results';
  static const String _themePreferenceKey = 'theme_preference';

  /// Save an assessment result to local storage
  Future<void> saveAssessmentResult(AssessmentResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing results
      final existingResults = await getAssessmentHistory();

      // Add or update the result
      final updatedResults = [...existingResults];
      final existingIndex = updatedResults.indexWhere((r) => r.id == result.id);

      if (existingIndex >= 0) {
        updatedResults[existingIndex] = result;
      } else {
        updatedResults.add(result);
      }

      // Sort by timestamp (newest first)
      updatedResults.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Convert to JSON and save
      final jsonList = updatedResults.map((result) => result.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_assessmentResultsKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to save assessment result: $e');
    }
  }

  /// Retrieve all saved assessment results
  Future<List<AssessmentResult>> getAssessmentHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_assessmentResultsKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map(
            (json) => AssessmentResult.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw StorageException('Failed to load assessment history: $e');
    }
  }

  /// Retrieve a single assessment result by ID
  Future<AssessmentResult?> getAssessmentResult(String id) async {
    try {
      final results = await getAssessmentHistory();
      return results.where((result) => result.id == id).firstOrNull;
    } catch (e) {
      throw StorageException('Failed to load assessment result: $e');
    }
  }

  /// Delete an assessment result by ID
  Future<void> deleteAssessmentResult(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingResults = await getAssessmentHistory();

      // Remove the result with the specified ID
      final updatedResults = existingResults
          .where((result) => result.id != id)
          .toList();

      // Save the updated list
      final jsonList = updatedResults.map((result) => result.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_assessmentResultsKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to delete assessment result: $e');
    }
  }

  /// Save theme preference (dark mode on/off)
  Future<void> saveThemePreference(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePreferenceKey, isDarkMode);
    } catch (e) {
      throw StorageException('Failed to save theme preference: $e');
    }
  }

  /// Get theme preference (defaults to false for light mode)
  Future<bool> getThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themePreferenceKey) ?? false;
    } catch (e) {
      throw StorageException('Failed to load theme preference: $e');
    }
  }

  /// Clear all stored data (useful for testing or reset functionality)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_assessmentResultsKey);
      await prefs.remove(_themePreferenceKey);
    } catch (e) {
      throw StorageException('Failed to clear all data: $e');
    }
  }

  /// Get the total number of saved assessment results
  Future<int> getAssessmentCount() async {
    try {
      final results = await getAssessmentHistory();
      return results.length;
    } catch (e) {
      throw StorageException('Failed to get assessment count: $e');
    }
  }

  /// Check if storage is available and working
  Future<bool> isStorageAvailable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const testKey = 'storage_test';
      const testValue = 'test';

      await prefs.setString(testKey, testValue);
      final retrievedValue = prefs.getString(testKey);
      await prefs.remove(testKey);

      return retrievedValue == testValue;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception for storage-related errors
class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
