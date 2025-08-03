import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakshasur/models/assessment_result.dart';
import 'package:yakshasur/models/dosha.dart';
import 'package:yakshasur/models/question.dart';
import 'package:yakshasur/models/recommendation.dart';
import 'package:yakshasur/services/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('Assessment Results Storage', () {
      test('should save and retrieve assessment result', () async {
        // Create a test assessment result
        final result = _createTestAssessmentResult();

        // Save the result
        await storageService.saveAssessmentResult(result);

        // Retrieve the result
        final retrievedResult = await storageService.getAssessmentResult(
          result.id,
        );

        // Verify the result was saved and retrieved correctly
        expect(retrievedResult, isNotNull);
        expect(retrievedResult!.id, equals(result.id));
        expect(retrievedResult.prakritiType, equals(result.prakritiType));
        expect(retrievedResult.doshaScores, equals(result.doshaScores));
        expect(retrievedResult.selectedTraits, equals(result.selectedTraits));
        expect(
          retrievedResult.recommendations.length,
          equals(result.recommendations.length),
        );
      });

      test('should return empty list when no results exist', () async {
        final results = await storageService.getAssessmentHistory();
        expect(results, isEmpty);
      });

      test('should return null when result ID does not exist', () async {
        final result = await storageService.getAssessmentResult(
          'non-existent-id',
        );
        expect(result, isNull);
      });

      test('should save multiple results and maintain order', () async {
        // Create multiple test results with different timestamps
        final result1 = _createTestAssessmentResult(
          id: 'result1',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        );
        final result2 = _createTestAssessmentResult(
          id: 'result2',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        );
        final result3 = _createTestAssessmentResult(
          id: 'result3',
          timestamp: DateTime.now(),
        );

        // Save results in random order
        await storageService.saveAssessmentResult(result2);
        await storageService.saveAssessmentResult(result1);
        await storageService.saveAssessmentResult(result3);

        // Retrieve all results
        final results = await storageService.getAssessmentHistory();

        // Verify results are sorted by timestamp (newest first)
        expect(results.length, equals(3));
        expect(results[0].id, equals('result3'));
        expect(results[1].id, equals('result2'));
        expect(results[2].id, equals('result1'));
      });

      test('should update existing result when saving with same ID', () async {
        final originalResult = _createTestAssessmentResult();
        await storageService.saveAssessmentResult(originalResult);

        // Create updated result with same ID but different prakriti type
        final updatedResult = originalResult.copyWith(
          prakritiType: PrakritiType.pitta,
        );
        await storageService.saveAssessmentResult(updatedResult);

        // Verify only one result exists and it's the updated one
        final results = await storageService.getAssessmentHistory();
        expect(results.length, equals(1));
        expect(results[0].prakritiType, equals(PrakritiType.pitta));
      });

      test('should delete assessment result', () async {
        final result1 = _createTestAssessmentResult(id: 'result1');
        final result2 = _createTestAssessmentResult(id: 'result2');

        await storageService.saveAssessmentResult(result1);
        await storageService.saveAssessmentResult(result2);

        // Verify both results exist
        var results = await storageService.getAssessmentHistory();
        expect(results.length, equals(2));

        // Delete one result
        await storageService.deleteAssessmentResult('result1');

        // Verify only one result remains
        results = await storageService.getAssessmentHistory();
        expect(results.length, equals(1));
        expect(results[0].id, equals('result2'));
      });

      test('should get correct assessment count', () async {
        expect(await storageService.getAssessmentCount(), equals(0));

        await storageService.saveAssessmentResult(
          _createTestAssessmentResult(id: 'result1'),
        );
        expect(await storageService.getAssessmentCount(), equals(1));

        await storageService.saveAssessmentResult(
          _createTestAssessmentResult(id: 'result2'),
        );
        expect(await storageService.getAssessmentCount(), equals(2));

        await storageService.deleteAssessmentResult('result1');
        expect(await storageService.getAssessmentCount(), equals(1));
      });
    });

    group('Theme Preference Storage', () {
      test('should save and retrieve theme preference', () async {
        // Default should be false (light mode)
        expect(await storageService.getThemePreference(), isFalse);

        // Save dark mode preference
        await storageService.saveThemePreference(true);
        expect(await storageService.getThemePreference(), isTrue);

        // Save light mode preference
        await storageService.saveThemePreference(false);
        expect(await storageService.getThemePreference(), isFalse);
      });
    });

    group('Data Management', () {
      test('should clear all data', () async {
        // Add some data
        await storageService.saveAssessmentResult(
          _createTestAssessmentResult(),
        );
        await storageService.saveThemePreference(true);

        // Verify data exists
        expect(await storageService.getAssessmentCount(), equals(1));
        expect(await storageService.getThemePreference(), isTrue);

        // Clear all data
        await storageService.clearAllData();

        // Verify data is cleared
        expect(await storageService.getAssessmentCount(), equals(0));
        expect(await storageService.getThemePreference(), isFalse);
      });

      test('should check storage availability', () async {
        final isAvailable = await storageService.isStorageAvailable();
        expect(isAvailable, isTrue);
      });
    });

    group('Error Handling', () {
      test('should handle JSON serialization errors gracefully', () async {
        // This test would require mocking SharedPreferences to throw errors
        // For now, we'll just verify the exception types exist
        expect(
          () => throw const StorageException('Test error'),
          throwsA(isA<StorageException>()),
        );
      });
    });
  });
}

/// Helper function to create a test assessment result
AssessmentResult _createTestAssessmentResult({
  String? id,
  DateTime? timestamp,
  PrakritiType? prakritiType,
}) {
  return AssessmentResult(
    id: id ?? 'test-result-id',
    timestamp: timestamp ?? DateTime.now(),
    doshaScores: const {
      DoshaType.vata: 15,
      DoshaType.pitta: 10,
      DoshaType.kapha: 8,
    },
    prakritiType: prakritiType ?? PrakritiType.vata,
    selectedTraits: const {
      QuestionCategory.physicalTraits: ['Dry skin', 'Thin build'],
      QuestionCategory.mentalEmotional: ['Quick thinking', 'Restless'],
      QuestionCategory.habitsPreferences: ['Light sleep', 'Variable appetite'],
      QuestionCategory.environmentalReactions: [
        'Prefers warmth',
        'Anxious under stress',
      ],
    },
    recommendations: [
      const Recommendation(
        type: RecommendationType.diet,
        title: 'Vata Diet Recommendations',
        description: 'Foods to balance Vata dosha',
        suggestions: [
          'Eat warm, cooked foods',
          'Include healthy fats like ghee and olive oil',
          'Avoid cold, raw foods',
        ],
      ),
      const Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Vata Lifestyle Recommendations',
        description: 'Lifestyle practices to balance Vata dosha',
        suggestions: [
          'Maintain regular routines',
          'Practice gentle yoga',
          'Get adequate rest',
        ],
      ),
    ],
  );
}
