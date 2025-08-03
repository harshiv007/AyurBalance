import 'package:flutter/foundation.dart';
import '../models/assessment_result.dart';
import '../models/recommendation.dart';
import '../models/dosha.dart';
import '../services/storage_service.dart';

/// ViewModel for managing assessment results display and history
class ResultsViewModel extends ChangeNotifier {
  final StorageService _storageService;

  // Private state variables
  AssessmentResult? _currentResult;
  List<AssessmentResult> _history = [];
  bool _isLoading = false;
  String? _error;

  // Constructor
  ResultsViewModel({
    StorageService? storageService,
  }) : _storageService = storageService ?? StorageService();

  // Getters
  AssessmentResult? get currentResult => _currentResult;
  
  List<AssessmentResult> get history => List.unmodifiable(_history);
  
  bool get isLoading => _isLoading;
  
  String? get error => _error;

  /// Check if there is a current result to display
  bool get hasCurrentResult => _currentResult != null;

  /// Check if there are any saved results in history
  bool get hasHistory => _history.isNotEmpty;

  /// Get the number of saved results
  int get historyCount => _history.length;

  /// Get the most recent result from history
  AssessmentResult? get mostRecentResult {
    if (_history.isEmpty) return null;
    return _history.first; // History is sorted by timestamp (newest first)
  }

  /// Get results grouped by prakriti type
  Map<PrakritiType, List<AssessmentResult>> get resultsByPrakritiType {
    final Map<PrakritiType, List<AssessmentResult>> grouped = {};
    
    for (final result in _history) {
      grouped.putIfAbsent(result.prakritiType, () => []);
      grouped[result.prakritiType]!.add(result);
    }
    
    return grouped;
  }

  /// Get recommendations by type for the current result
  List<Recommendation> getRecommendationsByType(RecommendationType type) {
    if (_currentResult == null) return [];
    return _currentResult!.getRecommendationsByType(type);
  }

  /// Get dosha percentages for the current result
  Map<DoshaType, double> get currentDoshaPercentages {
    if (_currentResult == null) return {};
    return _currentResult!.doshaPercentages;
  }

  /// Load a specific assessment result by ID
  Future<void> loadResult(String resultId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _storageService.getAssessmentResult(resultId);
      
      if (result == null) {
        throw Exception('Assessment result not found: $resultId');
      }
      
      _currentResult = result;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load assessment result: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load all assessment results from storage
  Future<void> loadHistory() async {
    _setLoading(true);
    _clearError();

    try {
      _history = await _storageService.getAssessmentHistory();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load assessment history: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a specific assessment result
  Future<void> deleteResult(String resultId) async {
    _setLoading(true);
    _clearError();

    try {
      await _storageService.deleteAssessmentResult(resultId);
      
      // Remove from local history
      _history.removeWhere((result) => result.id == resultId);
      
      // Clear current result if it was the deleted one
      if (_currentResult?.id == resultId) {
        _currentResult = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete assessment result: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set the current result for display (without loading from storage)
  void setCurrentResult(AssessmentResult result) {
    _clearError();
    _currentResult = result;
    notifyListeners();
  }

  /// Clear the current result
  void clearCurrentResult() {
    _clearError();
    _currentResult = null;
    notifyListeners();
  }

  /// Refresh both current result and history
  Future<void> refresh() async {
    _setLoading(true);
    _clearError();

    try {
      // Reload history
      _history = await _storageService.getAssessmentHistory();
      
      // If there's a current result, reload it to get any updates
      if (_currentResult != null) {
        final updatedResult = await _storageService.getAssessmentResult(_currentResult!.id);
        _currentResult = updatedResult;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to refresh results: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get results from a specific date range
  List<AssessmentResult> getResultsInDateRange(DateTime startDate, DateTime endDate) {
    return _history.where((result) {
      return result.timestamp.isAfter(startDate) && result.timestamp.isBefore(endDate);
    }).toList();
  }

  /// Get results from the last N days
  List<AssessmentResult> getRecentResults(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _history.where((result) => result.timestamp.isAfter(cutoffDate)).toList();
  }

  /// Search results by prakriti type
  List<AssessmentResult> searchByPrakritiType(PrakritiType prakritiType) {
    return _history.where((result) => result.prakritiType == prakritiType).toList();
  }

  /// Get statistics about assessment history
  Map<String, dynamic> getHistoryStatistics() {
    if (_history.isEmpty) {
      return {
        'totalAssessments': 0,
        'mostCommonPrakriti': null,
        'averageDoshaScores': <DoshaType, double>{},
        'assessmentFrequency': <String, int>{},
      };
    }

    // Count prakriti types
    final prakritiCounts = <PrakritiType, int>{};
    final doshaScoreTotals = <DoshaType, int>{
      DoshaType.vata: 0,
      DoshaType.pitta: 0,
      DoshaType.kapha: 0,
    };

    for (final result in _history) {
      prakritiCounts[result.prakritiType] = (prakritiCounts[result.prakritiType] ?? 0) + 1;
      
      result.doshaScores.forEach((dosha, score) {
        doshaScoreTotals[dosha] = doshaScoreTotals[dosha]! + score;
      });
    }

    // Find most common prakriti
    PrakritiType? mostCommonPrakriti;
    int maxCount = 0;
    prakritiCounts.forEach((prakriti, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonPrakriti = prakriti;
      }
    });

    // Calculate average dosha scores
    final averageDoshaScores = <DoshaType, double>{};
    doshaScoreTotals.forEach((dosha, total) {
      averageDoshaScores[dosha] = total / _history.length;
    });

    // Assessment frequency by month
    final assessmentFrequency = <String, int>{};
    for (final result in _history) {
      final monthKey = '${result.timestamp.year}-${result.timestamp.month.toString().padLeft(2, '0')}';
      assessmentFrequency[monthKey] = (assessmentFrequency[monthKey] ?? 0) + 1;
    }

    return {
      'totalAssessments': _history.length,
      'mostCommonPrakriti': mostCommonPrakriti,
      'averageDoshaScores': averageDoshaScores,
      'assessmentFrequency': assessmentFrequency,
      'prakritiDistribution': prakritiCounts,
    };
  }

  /// Compare two assessment results
  Map<String, dynamic> compareResults(AssessmentResult result1, AssessmentResult result2) {
    final comparison = <String, dynamic>{};
    
    // Compare prakriti types
    comparison['prakritiChanged'] = result1.prakritiType != result2.prakritiType;
    comparison['oldPrakriti'] = result1.prakritiType;
    comparison['newPrakriti'] = result2.prakritiType;
    
    // Compare dosha scores
    final doshaChanges = <DoshaType, int>{};
    for (final dosha in DoshaType.values) {
      final oldScore = result1.doshaScores[dosha] ?? 0;
      final newScore = result2.doshaScores[dosha] ?? 0;
      doshaChanges[dosha] = newScore - oldScore;
    }
    comparison['doshaChanges'] = doshaChanges;
    
    // Time difference
    comparison['timeDifference'] = result2.timestamp.difference(result1.timestamp);
    
    return comparison;
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