import 'package:flutter_test/flutter_test.dart';
import 'package:yakshasur/models/dosha.dart';
import 'package:yakshasur/models/question.dart';
import 'package:yakshasur/models/recommendation.dart';
import 'package:yakshasur/services/assessment_service.dart';

void main() {
  group('AssessmentService', () {
    late AssessmentService service;

    setUp(() {
      service = AssessmentService();
    });

    group('getQuestions', () {
      test('should return complete list of questions', () {
        final questions = service.getQuestions();

        expect(questions, isNotEmpty);
        expect(questions.length, equals(42)); // 12 + 10 + 12 + 8
      });

      test('should include all four question categories', () {
        final questions = service.getQuestions();
        final categories = questions.map((q) => q.category).toSet();

        expect(categories, contains(QuestionCategory.physicalTraits));
        expect(categories, contains(QuestionCategory.mentalEmotional));
        expect(categories, contains(QuestionCategory.habitsPreferences));
        expect(categories, contains(QuestionCategory.environmentalReactions));
      });

      test('should have correct number of questions per category', () {
        final questions = service.getQuestions();
        final physicalQuestions = questions
            .where((q) => q.category == QuestionCategory.physicalTraits)
            .length;
        final mentalQuestions = questions
            .where((q) => q.category == QuestionCategory.mentalEmotional)
            .length;
        final habitsQuestions = questions
            .where((q) => q.category == QuestionCategory.habitsPreferences)
            .length;
        final environmentalQuestions = questions
            .where((q) => q.category == QuestionCategory.environmentalReactions)
            .length;

        expect(physicalQuestions, equals(12));
        expect(mentalQuestions, equals(10));
        expect(habitsQuestions, equals(12));
        expect(environmentalQuestions, equals(8));
      });

      test('should have unique question IDs', () {
        final questions = service.getQuestions();
        final questionIds = questions.map((q) => q.id).toList();
        final uniqueIds = questionIds.toSet();

        expect(questionIds.length, equals(uniqueIds.length));
      });

      test('should have unique option IDs across all questions', () {
        final questions = service.getQuestions();
        final allOptionIds = <String>[];

        for (final question in questions) {
          for (final option in question.options) {
            allOptionIds.add(option.id);
          }
        }

        final uniqueOptionIds = allOptionIds.toSet();
        expect(allOptionIds.length, equals(uniqueOptionIds.length));
      });

      test('should have three options per question (one for each dosha)', () {
        final questions = service.getQuestions();

        for (final question in questions) {
          expect(question.options.length, equals(3));

          final doshaTypes = question.options
              .map((o) => o.primaryDosha)
              .toSet();
          expect(doshaTypes, contains(DoshaType.vata));
          expect(doshaTypes, contains(DoshaType.pitta));
          expect(doshaTypes, contains(DoshaType.kapha));
        }
      });
    });

    group('calculateResult', () {
      test('should calculate result with valid answers', () {
        final questions = service.getQuestions();
        final answers = <String, String>{};

        // Answer all questions with vata options
        for (final question in questions) {
          final vataOption = question.options.firstWhere(
            (option) => option.primaryDosha == DoshaType.vata,
          );
          answers[question.id] = vataOption.id;
        }

        final result = service.calculateResult(answers);

        expect(result.id, isNotEmpty);
        expect(result.timestamp, isNotNull);
        expect(result.prakritiType, equals(PrakritiType.vata));
        expect(result.doshaScores[DoshaType.vata], greaterThan(0));
        expect(result.doshaScores[DoshaType.pitta], equals(0));
        expect(result.doshaScores[DoshaType.kapha], equals(0));
        expect(result.recommendations, isNotEmpty);
        expect(result.selectedTraits, isNotEmpty);
      });

      test('should handle mixed answers correctly', () {
        final questions = service.getQuestions();
        final answers = <String, String>{};

        // Answer with mixed dosha options
        for (int i = 0; i < questions.length; i++) {
          final question = questions[i];
          final doshaIndex = i % 3; // Cycle through doshas
          final selectedOption = question.options[doshaIndex];
          answers[question.id] = selectedOption.id;
        }

        final result = service.calculateResult(answers);

        expect(result.id, isNotEmpty);
        expect(result.prakritiType, isNotNull);
        expect(result.doshaScores.values.every((score) => score >= 0), isTrue);
        expect(result.recommendations, isNotEmpty);
      });

      test('should handle empty answers', () {
        final answers = <String, String>{};
        final result = service.calculateResult(answers);

        expect(result.id, isNotEmpty);
        expect(result.prakritiType, equals(PrakritiType.tridoshic));
        expect(result.doshaScores.values.every((score) => score == 0), isTrue);
        expect(result.recommendations, isNotEmpty);
      });

      test('should include selected traits for all categories', () {
        final questions = service.getQuestions();
        final answers = <String, String>{};

        // Answer one question from each category
        final categorizedQuestions = <QuestionCategory, Question>{};
        for (final question in questions) {
          if (!categorizedQuestions.containsKey(question.category)) {
            categorizedQuestions[question.category] = question;
          }
        }

        for (final entry in categorizedQuestions.entries) {
          final question = entry.value;
          answers[question.id] = question.options.first.id;
        }

        final result = service.calculateResult(answers);

        expect(result.selectedTraits.keys, hasLength(4));
        expect(
          result.selectedTraits[QuestionCategory.physicalTraits],
          isNotEmpty,
        );
        expect(
          result.selectedTraits[QuestionCategory.mentalEmotional],
          isNotEmpty,
        );
        expect(
          result.selectedTraits[QuestionCategory.habitsPreferences],
          isNotEmpty,
        );
        expect(
          result.selectedTraits[QuestionCategory.environmentalReactions],
          isNotEmpty,
        );
      });
    });

    group('generateRecommendations', () {
      test('should generate vata recommendations', () {
        final recommendations = service.generateRecommendations(
          PrakritiType.vata,
        );

        expect(recommendations, hasLength(5));
        expect(recommendations.map((r) => r.type).toSet(), hasLength(5));
        expect(
          recommendations.any((r) => r.type == RecommendationType.diet),
          isTrue,
        );
        expect(
          recommendations.any((r) => r.type == RecommendationType.lifestyle),
          isTrue,
        );
        expect(
          recommendations.any((r) => r.type == RecommendationType.sleep),
          isTrue,
        );
        expect(
          recommendations.any(
            (r) => r.type == RecommendationType.stressManagement,
          ),
          isTrue,
        );
        expect(
          recommendations.any((r) => r.type == RecommendationType.seasonal),
          isTrue,
        );
      });

      test('should generate pitta recommendations', () {
        final recommendations = service.generateRecommendations(
          PrakritiType.pitta,
        );

        expect(recommendations, hasLength(5));
        expect(recommendations.every((r) => r.title.isNotEmpty), isTrue);
        expect(recommendations.every((r) => r.description.isNotEmpty), isTrue);
        expect(recommendations.every((r) => r.suggestions.isNotEmpty), isTrue);
      });

      test('should generate kapha recommendations', () {
        final recommendations = service.generateRecommendations(
          PrakritiType.kapha,
        );

        expect(recommendations, hasLength(5));
        expect(recommendations.map((r) => r.type).toSet(), hasLength(5));
      });

      test('should generate dual dosha recommendations', () {
        final vataPittaRecs = service.generateRecommendations(
          PrakritiType.vataPitta,
        );
        final pittaKaphaRecs = service.generateRecommendations(
          PrakritiType.pittaKapha,
        );
        final vataKaphaRecs = service.generateRecommendations(
          PrakritiType.vataKapha,
        );

        expect(vataPittaRecs, hasLength(5));
        expect(pittaKaphaRecs, hasLength(5));
        expect(vataKaphaRecs, hasLength(5));
      });

      test('should generate tridoshic recommendations', () {
        final recommendations = service.generateRecommendations(
          PrakritiType.tridoshic,
        );

        expect(recommendations, hasLength(5));
        expect(recommendations.map((r) => r.type).toSet(), hasLength(5));
      });

      test(
        'should have different recommendations for different prakriti types',
        () {
          final vataRecs = service.generateRecommendations(PrakritiType.vata);
          final pittaRecs = service.generateRecommendations(PrakritiType.pitta);
          final kaphaRecs = service.generateRecommendations(PrakritiType.kapha);

          // Check that diet recommendations are different
          final vataDiet = vataRecs.firstWhere(
            (r) => r.type == RecommendationType.diet,
          );
          final pittaDiet = pittaRecs.firstWhere(
            (r) => r.type == RecommendationType.diet,
          );
          final kaphaDiet = kaphaRecs.firstWhere(
            (r) => r.type == RecommendationType.diet,
          );

          expect(vataDiet.title, isNot(equals(pittaDiet.title)));
          expect(pittaDiet.title, isNot(equals(kaphaDiet.title)));
          expect(vataDiet.title, isNot(equals(kaphaDiet.title)));
        },
      );

      test('should include practical suggestions in all recommendations', () {
        final recommendations = service.generateRecommendations(
          PrakritiType.vata,
        );

        for (final recommendation in recommendations) {
          expect(recommendation.suggestions, isNotEmpty);
          expect(recommendation.suggestions.length, greaterThanOrEqualTo(3));
          expect(recommendation.suggestions.every((s) => s.isNotEmpty), isTrue);
        }
      });
    });

    group('question content validation', () {
      test('should have meaningful question text', () {
        final questions = service.getQuestions();

        for (final question in questions) {
          expect(question.text, isNotEmpty);
          expect(question.text.length, greaterThan(10));
          expect(question.text.contains('?'), isTrue);
        }
      });

      test('should have meaningful option text', () {
        final questions = service.getQuestions();

        for (final question in questions) {
          for (final option in question.options) {
            expect(option.text, isNotEmpty);
            expect(option.text.length, greaterThan(5));
          }
        }
      });

      test('should have appropriate weights for options', () {
        final questions = service.getQuestions();

        for (final question in questions) {
          for (final option in question.options) {
            expect(option.weight, greaterThan(0));
            expect(option.weight, lessThanOrEqualTo(3));
          }
        }
      });
    });
  });
}
