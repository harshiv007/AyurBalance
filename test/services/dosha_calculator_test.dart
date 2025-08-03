import 'package:flutter_test/flutter_test.dart';
import 'package:yakshasur/models/dosha.dart';
import 'package:yakshasur/models/question.dart';
import 'package:yakshasur/services/dosha_calculator.dart';

void main() {
  group('DoshaCalculator', () {
    late DoshaCalculator calculator;
    late List<Question> testQuestions;

    setUp(() {
      calculator = DoshaCalculator();
      
      // Create test questions with options for each dosha
      testQuestions = [
        Question(
          id: 'q1',
          text: 'What is your skin type?',
          category: QuestionCategory.physicalTraits,
          options: [
            QuestionOption(
              id: 'q1_vata',
              text: 'Dry and rough',
              primaryDosha: DoshaType.vata,
              weight: 2,
            ),
            QuestionOption(
              id: 'q1_pitta',
              text: 'Oily and sensitive',
              primaryDosha: DoshaType.pitta,
              weight: 2,
            ),
            QuestionOption(
              id: 'q1_kapha',
              text: 'Thick and smooth',
              primaryDosha: DoshaType.kapha,
              weight: 2,
            ),
          ],
        ),
        Question(
          id: 'q2',
          text: 'How do you handle stress?',
          category: QuestionCategory.mentalEmotional,
          options: [
            QuestionOption(
              id: 'q2_vata',
              text: 'Become anxious and restless',
              primaryDosha: DoshaType.vata,
              weight: 1,
            ),
            QuestionOption(
              id: 'q2_pitta',
              text: 'Get angry and irritated',
              primaryDosha: DoshaType.pitta,
              weight: 1,
            ),
            QuestionOption(
              id: 'q2_kapha',
              text: 'Remain calm and steady',
              primaryDosha: DoshaType.kapha,
              weight: 1,
            ),
          ],
        ),
        Question(
          id: 'q3',
          text: 'What are your sleep patterns?',
          category: QuestionCategory.habitsPreferences,
          options: [
            QuestionOption(
              id: 'q3_vata',
              text: 'Light and interrupted',
              primaryDosha: DoshaType.vata,
              weight: 1,
            ),
            QuestionOption(
              id: 'q3_pitta',
              text: 'Moderate and regular',
              primaryDosha: DoshaType.pitta,
              weight: 1,
            ),
            QuestionOption(
              id: 'q3_kapha',
              text: 'Deep and long',
              primaryDosha: DoshaType.kapha,
              weight: 1,
            ),
          ],
        ),
      ];
    });

    group('calculateDoshaScores', () {
      test('should calculate correct scores for single dosha answers', () {
        final answers = {
          'q1': 'q1_vata',
          'q2': 'q2_vata',
          'q3': 'q3_vata',
        };

        final scores = calculator.calculateDoshaScores(answers, testQuestions);

        expect(scores[DoshaType.vata], equals(4)); // 2 + 1 + 1
        expect(scores[DoshaType.pitta], equals(0));
        expect(scores[DoshaType.kapha], equals(0));
      });

      test('should calculate correct scores for mixed answers', () {
        final answers = {
          'q1': 'q1_vata',   // 2 points to vata
          'q2': 'q2_pitta',  // 1 point to pitta
          'q3': 'q3_kapha',  // 1 point to kapha
        };

        final scores = calculator.calculateDoshaScores(answers, testQuestions);

        expect(scores[DoshaType.vata], equals(2));
        expect(scores[DoshaType.pitta], equals(1));
        expect(scores[DoshaType.kapha], equals(1));
      });

      test('should handle empty answers', () {
        final answers = <String, String>{};

        final scores = calculator.calculateDoshaScores(answers, testQuestions);

        expect(scores[DoshaType.vata], equals(0));
        expect(scores[DoshaType.pitta], equals(0));
        expect(scores[DoshaType.kapha], equals(0));
      });

      test('should handle invalid option IDs gracefully', () {
        final answers = {
          'q1': 'invalid_option',
          'q2': 'q2_pitta',
        };

        final scores = calculator.calculateDoshaScores(answers, testQuestions);

        expect(scores[DoshaType.vata], equals(0));
        expect(scores[DoshaType.pitta], equals(1));
        expect(scores[DoshaType.kapha], equals(0));
      });

      test('should respect option weights', () {
        final answers = {
          'q1': 'q1_pitta', // Weight 2
          'q2': 'q2_pitta', // Weight 1
        };

        final scores = calculator.calculateDoshaScores(answers, testQuestions);

        expect(scores[DoshaType.pitta], equals(3)); // 2 + 1
      });
    });

    group('determinePrakritiType', () {
      test('should determine single vata prakriti', () {
        final scores = {
          DoshaType.vata: 10,
          DoshaType.pitta: 2,
          DoshaType.kapha: 1,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.vata));
      });

      test('should determine single pitta prakriti', () {
        final scores = {
          DoshaType.vata: 1,
          DoshaType.pitta: 10,
          DoshaType.kapha: 2,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.pitta));
      });

      test('should determine single kapha prakriti', () {
        final scores = {
          DoshaType.vata: 2,
          DoshaType.pitta: 1,
          DoshaType.kapha: 10,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.kapha));
      });

      test('should determine vata-pitta dual prakriti', () {
        final scores = {
          DoshaType.vata: 8,
          DoshaType.pitta: 7,
          DoshaType.kapha: 2,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.vataPitta));
      });

      test('should determine pitta-kapha dual prakriti', () {
        final scores = {
          DoshaType.vata: 2,
          DoshaType.pitta: 8,
          DoshaType.kapha: 7,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.pittaKapha));
      });

      test('should determine vata-kapha dual prakriti', () {
        final scores = {
          DoshaType.vata: 8,
          DoshaType.pitta: 2,
          DoshaType.kapha: 7,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.vataKapha));
      });

      test('should determine tridoshic prakriti', () {
        final scores = {
          DoshaType.vata: 7,
          DoshaType.pitta: 6,
          DoshaType.kapha: 6,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.tridoshic));
      });

      test('should handle all zero scores', () {
        final scores = {
          DoshaType.vata: 0,
          DoshaType.pitta: 0,
          DoshaType.kapha: 0,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.tridoshic));
      });

      test('should handle edge case for dual dosha determination', () {
        // Test the 80% threshold for dual dosha
        final scores = {
          DoshaType.vata: 10,
          DoshaType.pitta: 8, // Exactly 80% of highest
          DoshaType.kapha: 1,
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.vataPitta));
      });

      test('should handle edge case for tridoshic determination', () {
        // Test the 70% threshold for tridoshic
        final scores = {
          DoshaType.vata: 10,
          DoshaType.pitta: 8,
          DoshaType.kapha: 7, // Exactly 70% of highest
        };

        final prakriti = calculator.determinePrakritiType(scores);

        expect(prakriti, equals(PrakritiType.tridoshic));
      });
    });

    group('extractSelectedTraits', () {
      test('should extract traits correctly by category', () {
        final answers = {
          'q1': 'q1_vata',
          'q2': 'q2_pitta',
          'q3': 'q3_kapha',
        };

        final traits = calculator.extractSelectedTraits(answers, testQuestions);

        expect(traits[QuestionCategory.physicalTraits], contains('Dry and rough'));
        expect(traits[QuestionCategory.mentalEmotional], contains('Get angry and irritated'));
        expect(traits[QuestionCategory.habitsPreferences], contains('Deep and long'));
        expect(traits[QuestionCategory.environmentalReactions], isEmpty);
      });

      test('should handle empty answers', () {
        final answers = <String, String>{};

        final traits = calculator.extractSelectedTraits(answers, testQuestions);

        expect(traits[QuestionCategory.physicalTraits], isEmpty);
        expect(traits[QuestionCategory.mentalEmotional], isEmpty);
        expect(traits[QuestionCategory.habitsPreferences], isEmpty);
        expect(traits[QuestionCategory.environmentalReactions], isEmpty);
      });

      test('should handle invalid question or option IDs', () {
        final answers = {
          'invalid_question': 'q1_vata',
          'q1': 'invalid_option',
          'q2': 'q2_pitta',
        };

        final traits = calculator.extractSelectedTraits(answers, testQuestions);

        expect(traits[QuestionCategory.physicalTraits], isEmpty);
        expect(traits[QuestionCategory.mentalEmotional], contains('Get angry and irritated'));
        expect(traits[QuestionCategory.habitsPreferences], isEmpty);
        expect(traits[QuestionCategory.environmentalReactions], isEmpty);
      });

      test('should group multiple traits by category', () {
        // Add another physical traits question
        final extendedQuestions = [
          ...testQuestions,
          Question(
            id: 'q4',
            text: 'What is your body build?',
            category: QuestionCategory.physicalTraits,
            options: [
              QuestionOption(
                id: 'q4_vata',
                text: 'Thin and light',
                primaryDosha: DoshaType.vata,
              ),
            ],
          ),
        ];

        final answers = {
          'q1': 'q1_vata',
          'q4': 'q4_vata',
        };

        final traits = calculator.extractSelectedTraits(answers, extendedQuestions);

        expect(traits[QuestionCategory.physicalTraits], hasLength(2));
        expect(traits[QuestionCategory.physicalTraits], contains('Dry and rough'));
        expect(traits[QuestionCategory.physicalTraits], contains('Thin and light'));
      });
    });
  });
}