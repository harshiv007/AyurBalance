import 'dart:math';
import '../models/assessment_result.dart';
import '../models/dosha.dart';
import '../models/question.dart';
import '../models/recommendation.dart';
import 'dosha_calculator.dart';

/// Service responsible for managing assessment questions, calculating results,
/// and generating personalized recommendations based on Ayurvedic principles.
class AssessmentService {
  final DoshaCalculator _doshaCalculator;

  /// Constructor with dependency injection
  AssessmentService({
    DoshaCalculator? doshaCalculator,
  }) : _doshaCalculator = doshaCalculator ?? DoshaCalculator();

  /// Returns the complete list of assessment questions covering all four categories.
  List<Question> getQuestions() {
    return [
      // Physical Traits Questions (12 questions)
      ..._getPhysicalTraitsQuestions(),
      
      // Mental & Emotional Questions (10 questions)
      ..._getMentalEmotionalQuestions(),
      
      // Habits & Preferences Questions (12 questions)
      ..._getHabitsPreferencesQuestions(),
      
      // Environmental Reactions Questions (8 questions)
      ..._getEnvironmentalReactionsQuestions(),
    ];
  }

  /// Calculates the complete assessment result based on user answers.
  AssessmentResult calculateResult(Map<String, String> answers) {
    final questions = getQuestions();
    final doshaScores = _doshaCalculator.calculateDoshaScores(answers, questions);
    final prakritiType = _doshaCalculator.determinePrakritiType(doshaScores);
    final selectedTraits = _doshaCalculator.extractSelectedTraits(answers, questions);
    final recommendations = generateRecommendations(prakritiType);

    return AssessmentResult(
      id: _generateResultId(),
      timestamp: DateTime.now(),
      doshaScores: doshaScores,
      prakritiType: prakritiType,
      selectedTraits: selectedTraits,
      recommendations: recommendations,
    );
  }

  /// Generates personalized wellness recommendations based on prakriti type.
  List<Recommendation> generateRecommendations(PrakritiType prakritiType) {
    switch (prakritiType) {
      case PrakritiType.vata:
        return _getVataRecommendations();
      case PrakritiType.pitta:
        return _getPittaRecommendations();
      case PrakritiType.kapha:
        return _getKaphaRecommendations();
      case PrakritiType.vataPitta:
        return _getVataPittaRecommendations();
      case PrakritiType.pittaKapha:
        return _getPittaKaphaRecommendations();
      case PrakritiType.vataKapha:
        return _getVataKaphaRecommendations();
      case PrakritiType.tridoshic:
        return _getTridoshicRecommendations();
    }
  }

  // Physical Traits Questions
  List<Question> _getPhysicalTraitsQuestions() {
    return [
      Question(
        id: 'physical_1',
        text: 'How would you describe your skin type?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_1_vata',
            text: 'Dry, rough, and tends to crack easily',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_1_pitta',
            text: 'Oily, sensitive, and prone to rashes or acne',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_1_kapha',
            text: 'Thick, smooth, and naturally moisturized',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'physical_2',
        text: 'What is your natural body build?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_2_vata',
            text: 'Thin, light, and find it hard to gain weight',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_2_pitta',
            text: 'Medium build with good muscle definition',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_2_kapha',
            text: 'Heavy, solid build and gain weight easily',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'physical_3',
        text: 'How would you describe your hair?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_3_vata',
            text: 'Dry, brittle, and tends to be frizzy',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_3_pitta',
            text: 'Fine, oily, and prone to early graying or thinning',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_3_kapha',
            text: 'Thick, lustrous, and naturally oily',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_4',
        text: 'What are your eyes like?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_4_vata',
            text: 'Small, dry, and move around frequently',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_4_pitta',
            text: 'Medium-sized, bright, and penetrating gaze',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_4_kapha',
            text: 'Large, moist, and calm expression',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_5',
        text: 'How is your voice and speech pattern?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_5_vata',
            text: 'Fast, high-pitched, and sometimes unclear',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_5_pitta',
            text: 'Clear, sharp, and well-articulated',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_5_kapha',
            text: 'Deep, slow, and melodious',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_6',
        text: 'How do your hands and feet feel?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_6_vata',
            text: 'Cold, dry, and rough to touch',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_6_pitta',
            text: 'Warm, moist, and pink in color',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_6_kapha',
            text: 'Cool, firm, and well-formed',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_7',
        text: 'What is your natural body temperature preference?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_7_vata',
            text: 'I feel cold easily and prefer warm environments',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_7_pitta',
            text: 'I feel warm easily and prefer cool environments',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_7_kapha',
            text: 'I adapt well to most temperatures',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_8',
        text: 'How is your physical stamina and endurance?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_8_vata',
            text: 'Low stamina, tire easily but recover quickly',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_8_pitta',
            text: 'Good stamina when motivated, dislike overheating',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_8_kapha',
            text: 'Excellent endurance once I get started',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_9',
        text: 'How do you typically walk?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_9_vata',
            text: 'Fast, light steps, and somewhat irregular',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_9_pitta',
            text: 'Determined, purposeful, and moderate pace',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_9_kapha',
            text: 'Slow, steady, and graceful',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_10',
        text: 'What is your natural sleep position preference?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_10_vata',
            text: 'I toss and turn, changing positions frequently',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_10_pitta',
            text: 'I sleep on my back or side, fairly still',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_10_kapha',
            text: 'I sleep deeply in one position all night',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'physical_11',
        text: 'How is your digestion typically?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_11_vata',
            text: 'Irregular, sometimes constipated, gas or bloating',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_11_pitta',
            text: 'Strong and fast, rarely miss meals, can be acidic',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'physical_11_kapha',
            text: 'Slow but steady, can skip meals easily',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'physical_12',
        text: 'How do you typically sweat?',
        category: QuestionCategory.physicalTraits,
        options: [
          QuestionOption(
            id: 'physical_12_vata',
            text: 'Very little, even during exercise',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_12_pitta',
            text: 'Profusely and easily, especially when hot',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'physical_12_kapha',
            text: 'Moderately, mainly during intense activity',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
    ];
  }  
// Mental & Emotional Questions
  List<Question> _getMentalEmotionalQuestions() {
    return [
      Question(
        id: 'mental_1',
        text: 'How would you describe your general mindset?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_1_vata',
            text: 'Creative, restless, and always thinking of new ideas',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_1_pitta',
            text: 'Focused, determined, and goal-oriented',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_1_kapha',
            text: 'Calm, steady, and prefer routine and stability',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'mental_2',
        text: 'How is your memory?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_2_vata',
            text: 'Quick to learn but also quick to forget',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_2_pitta',
            text: 'Sharp and precise, good at remembering details',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_2_kapha',
            text: 'Slow to learn but excellent long-term retention',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'mental_3',
        text: 'How do you typically handle stress?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_3_vata',
            text: 'Become anxious, worried, and restless',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_3_pitta',
            text: 'Get angry, irritated, and critical',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_3_kapha',
            text: 'Remain calm but may become withdrawn',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'mental_4',
        text: 'What is your decision-making style?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_4_vata',
            text: 'Quick decisions but often change my mind',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_4_pitta',
            text: 'Decisive and confident in my choices',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_4_kapha',
            text: 'Take time to decide but stick with it',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'mental_5',
        text: 'How do you learn best?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_5_vata',
            text: 'Through discussion, variety, and hands-on experience',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_5_pitta',
            text: 'Through structured study and logical analysis',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_5_kapha',
            text: 'Through repetition and step-by-step instruction',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'mental_6',
        text: 'What is your emotional nature?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_6_vata',
            text: 'Emotions change quickly, enthusiastic but can be moody',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_6_pitta',
            text: 'Intense emotions, passionate but can be impatient',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'mental_6_kapha',
            text: 'Stable emotions, loving but can be possessive',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'mental_7',
        text: 'How do you handle change?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_7_vata',
            text: 'Love change and variety, get bored easily',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_7_pitta',
            text: 'Adapt well if the change makes logical sense',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_7_kapha',
            text: 'Prefer stability and resist change initially',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'mental_8',
        text: 'What is your communication style?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_8_vata',
            text: 'Talkative, animated, and jump between topics',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_8_pitta',
            text: 'Direct, articulate, and persuasive',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_8_kapha',
            text: 'Thoughtful, gentle, and prefer listening',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'mental_9',
        text: 'How do you approach work and tasks?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_9_vata',
            text: 'Start enthusiastically but may not finish',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_9_pitta',
            text: 'Work intensely and efficiently to completion',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_9_kapha',
            text: 'Work steadily and methodically',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'mental_10',
        text: 'What motivates you most?',
        category: QuestionCategory.mentalEmotional,
        options: [
          QuestionOption(
            id: 'mental_10_vata',
            text: 'New experiences, creativity, and freedom',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_10_pitta',
            text: 'Achievement, recognition, and competition',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'mental_10_kapha',
            text: 'Security, harmony, and helping others',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
    ];
  }

  // Habits & Preferences Questions
  List<Question> _getHabitsPreferencesQuestions() {
    return [
      Question(
        id: 'habits_1',
        text: 'What are your food preferences?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_1_vata',
            text: 'Prefer warm, cooked, and nourishing foods',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_1_pitta',
            text: 'Prefer cool, fresh, and moderately spiced foods',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_1_kapha',
            text: 'Prefer light, spicy, and stimulating foods',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'habits_2',
        text: 'How is your appetite?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_2_vata',
            text: 'Variable - sometimes hungry, sometimes not',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_2_pitta',
            text: 'Strong and regular - get irritable when hungry',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_2_kapha',
            text: 'Mild and can easily skip meals',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'habits_3',
        text: 'What are your sleep patterns like?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_3_vata',
            text: 'Light sleeper, wake up frequently, need 6-7 hours',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_3_pitta',
            text: 'Moderate sleeper, wake up refreshed, need 7-8 hours',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'habits_3_kapha',
            text: 'Deep sleeper, hard to wake up, need 8-9 hours',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'habits_4',
        text: 'What time of day do you feel most energetic?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_4_vata',
            text: 'Energy comes in bursts throughout the day',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_4_pitta',
            text: 'Most energetic during midday and afternoon',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_4_kapha',
            text: 'Slow to start but steady energy once going',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_5',
        text: 'What type of exercise do you prefer?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_5_vata',
            text: 'Gentle, flowing activities like yoga or walking',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_5_pitta',
            text: 'Competitive sports and moderate intensity workouts',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_5_kapha',
            text: 'Vigorous, stimulating exercise to get motivated',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_6',
        text: 'How do you prefer to spend your free time?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_6_vata',
            text: 'Creative activities, socializing, or exploring new places',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_6_pitta',
            text: 'Reading, learning, or engaging in competitive activities',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_6_kapha',
            text: 'Relaxing at home, gardening, or spending time with family',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_7',
        text: 'What is your approach to money and spending?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_7_vata',
            text: 'Spend impulsively on experiences and creative things',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_7_pitta',
            text: 'Spend on quality items and investments',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_7_kapha',
            text: 'Save money and spend carefully on necessities',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_8',
        text: 'How do you organize your living space?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_8_vata',
            text: 'Somewhat disorganized, creative chaos',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_8_pitta',
            text: 'Well-organized and efficient systems',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_8_kapha',
            text: 'Comfortable and cozy, may accumulate things',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_9',
        text: 'What is your relationship with routine?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_9_vata',
            text: 'Dislike routine, prefer spontaneity and variety',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_9_pitta',
            text: 'Like structured routine that supports my goals',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_9_kapha',
            text: 'Love routine and find comfort in predictability',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_10',
        text: 'How do you typically eat your meals?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_10_vata',
            text: 'Eat quickly, often while multitasking',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_10_pitta',
            text: 'Eat with focus and enjoy the flavors',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_10_kapha',
            text: 'Eat slowly and savor each bite',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_11',
        text: 'What is your preferred room temperature?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_11_vata',
            text: 'Warm and cozy, dislike cold or drafts',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_11_pitta',
            text: 'Cool and well-ventilated, dislike heat',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_11_kapha',
            text: 'Moderate temperature, adapt to most conditions',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'habits_12',
        text: 'How do you prefer to travel?',
        category: QuestionCategory.habitsPreferences,
        options: [
          QuestionOption(
            id: 'habits_12_vata',
            text: 'Love adventure travel and exploring new places',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_12_pitta',
            text: 'Prefer well-planned trips with clear itineraries',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'habits_12_kapha',
            text: 'Enjoy relaxing vacations and familiar destinations',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
    ];
  }

  // Environmental Reactions Questions
  List<Question> _getEnvironmentalReactionsQuestions() {
    return [
      Question(
        id: 'environment_1',
        text: 'How do you react to cold weather?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_1_vata',
            text: 'Feel very uncomfortable, joints may ache',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_1_pitta',
            text: 'Generally comfortable, may even enjoy it',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_1_kapha',
            text: 'Tolerate it well but may feel sluggish',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'environment_2',
        text: 'How do you react to hot weather?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_2_vata',
            text: 'Generally comfortable, may feel more energetic',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_2_pitta',
            text: 'Become irritable, sweaty, and uncomfortable',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_2_kapha',
            text: 'Feel more motivated and energetic',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'environment_3',
        text: 'How do you respond to windy conditions?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_3_vata',
            text: 'Feel agitated, restless, or anxious',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_3_pitta',
            text: 'Mildly bothered but generally adaptable',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_3_kapha',
            text: 'Hardly notice or may find it refreshing',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'environment_4',
        text: 'How do you handle humid conditions?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_4_vata',
            text: 'Actually prefer some humidity for my dry skin',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_4_pitta',
            text: 'Find it very uncomfortable and draining',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_4_kapha',
            text: 'Feel heavy and sluggish in high humidity',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'environment_5',
        text: 'How do you react to loud noises or chaotic environments?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_5_vata',
            text: 'Become overstimulated and anxious',
            primaryDosha: DoshaType.vata,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_5_pitta',
            text: 'Get irritated and want to take control',
            primaryDosha: DoshaType.pitta,
            weight: 2,
          ),
          QuestionOption(
            id: 'environment_5_kapha',
            text: 'Remain relatively calm and unaffected',
            primaryDosha: DoshaType.kapha,
            weight: 2,
          ),
        ],
      ),
      Question(
        id: 'environment_6',
        text: 'How do you respond to seasonal changes?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_6_vata',
            text: 'Feel unsettled, especially during fall and winter',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_6_pitta',
            text: 'Most affected during hot summer months',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_6_kapha',
            text: 'Most affected during cold, damp spring weather',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'environment_7',
        text: 'How do you handle high-pressure situations?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_7_vata',
            text: 'Become scattered and may freeze up',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_7_pitta',
            text: 'Rise to the challenge but may become aggressive',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_7_kapha',
            text: 'Stay calm and work steadily through it',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
      Question(
        id: 'environment_8',
        text: 'How do you react to changes in routine or unexpected events?',
        category: QuestionCategory.environmentalReactions,
        options: [
          QuestionOption(
            id: 'environment_8_vata',
            text: 'Initially excited but may become overwhelmed',
            primaryDosha: DoshaType.vata,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_8_pitta',
            text: 'Adapt quickly if I can see the logic behind it',
            primaryDosha: DoshaType.pitta,
            weight: 1,
          ),
          QuestionOption(
            id: 'environment_8_kapha',
            text: 'Resist initially but adapt slowly over time',
            primaryDosha: DoshaType.kapha,
            weight: 1,
          ),
        ],
      ),
    ];
  }

  // Recommendation Generation Methods

  List<Recommendation> _getVataRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Vata-Balancing Diet',
        description: 'Warm, nourishing foods to ground and stabilize your airy nature.',
        suggestions: [
          'Eat warm, cooked foods rather than cold or raw',
          'Include healthy fats like ghee, olive oil, and avocados',
          'Choose sweet, sour, and salty tastes over bitter, pungent, and astringent',
          'Eat regular meals at consistent times',
          'Stay hydrated with warm beverages like herbal teas',
          'Include grounding foods like root vegetables, nuts, and whole grains',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Vata-Balancing Lifestyle',
        description: 'Create routine and stability to calm your restless energy.',
        suggestions: [
          'Establish regular daily routines for meals, sleep, and activities',
          'Practice gentle, grounding exercises like yoga or tai chi',
          'Create a calm, warm environment at home',
          'Limit overstimulation from screens, noise, and crowds',
          'Engage in creative activities that bring you joy',
          'Spend time in nature, especially in gardens or forests',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Vata Sleep Guidelines',
        description: 'Establish calming bedtime routines for better rest.',
        suggestions: [
          'Go to bed by 10 PM to align with natural rhythms',
          'Create a consistent bedtime routine',
          'Keep your bedroom warm and cozy',
          'Practice relaxation techniques before sleep',
          'Avoid screens for 1 hour before bedtime',
          'Try warm milk with spices like nutmeg or cardamom',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Vata Stress Management',
        description: 'Calming practices to soothe anxiety and restlessness.',
        suggestions: [
          'Practice deep breathing exercises and meditation',
          'Try gentle yoga or stretching',
          'Use calming essential oils like lavender or sandalwood',
          'Take warm baths with Epsom salts',
          'Practice mindfulness and stay present',
          'Seek support from friends and family when feeling overwhelmed',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Vata Seasonal Routines',
        description: 'Adapt your routine to stay balanced throughout the year.',
        suggestions: [
          'Extra care during fall and early winter (Vata season)',
          'Increase warm, oily foods during cold months',
          'Practice more grounding activities in windy weather',
          'Use heavier blankets and warm clothing',
          'Maintain consistent routines especially during seasonal transitions',
          'Consider oil massage (abhyanga) during dry seasons',
        ],
      ),
    ];
  }

  List<Recommendation> _getPittaRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Pitta-Balancing Diet',
        description: 'Cool, fresh foods to calm your fiery nature.',
        suggestions: [
          'Eat cooling foods like fresh fruits, vegetables, and salads',
          'Choose sweet, bitter, and astringent tastes over spicy, sour, and salty',
          'Avoid very hot, spicy, or acidic foods',
          'Eat at regular times, especially lunch (your strongest digestive fire)',
          'Stay hydrated with cool (not ice-cold) water and herbal teas',
          'Include cooling herbs like cilantro, mint, and fennel',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Pitta-Balancing Lifestyle',
        description: 'Moderate activities to channel your intense energy wisely.',
        suggestions: [
          'Avoid overworking and schedule regular breaks',
          'Practice moderate exercise, avoid overheating',
          'Spend time in cool, shaded environments',
          'Cultivate patience and avoid perfectionism',
          'Engage in activities that promote compassion and understanding',
          'Take time for leisure and non-competitive activities',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Pitta Sleep Guidelines',
        description: 'Cool, calm sleep environment for quality rest.',
        suggestions: [
          'Keep your bedroom cool and well-ventilated',
          'Go to bed by 10:30 PM to avoid late-night Pitta energy',
          'Avoid intense mental work before bedtime',
          'Practice cooling breathing techniques',
          'Use light, breathable bedding',
          'Try cooling herbs like chamomile or rose tea before bed',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Pitta Stress Management',
        description: 'Cooling practices to manage anger and intensity.',
        suggestions: [
          'Practice cooling pranayama (breathing exercises)',
          'Spend time near water - lakes, rivers, or ocean',
          'Use cooling essential oils like rose, sandalwood, or jasmine',
          'Practice forgiveness and letting go of grudges',
          'Engage in moderate, non-competitive physical activities',
          'Take breaks from intense mental work throughout the day',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Pitta Seasonal Routines',
        description: 'Stay cool and balanced, especially during summer.',
        suggestions: [
          'Extra care during summer months (Pitta season)',
          'Increase cooling foods and drinks during hot weather',
          'Avoid intense sun exposure during peak hours',
          'Wear light-colored, breathable clothing',
          'Plan vacations to cooler climates during summer',
          'Practice early morning or evening exercise to avoid heat',
        ],
      ),
    ];
  }

  List<Recommendation> _getKaphaRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Kapha-Balancing Diet',
        description: 'Light, spicy foods to stimulate your steady nature.',
        suggestions: [
          'Eat light, warm, and spicy foods',
          'Choose pungent, bitter, and astringent tastes over sweet, sour, and salty',
          'Reduce dairy, sugar, and heavy foods',
          'Eat your largest meal at lunch, lighter dinner',
          'Include warming spices like ginger, black pepper, and turmeric',
          'Drink warm water and herbal teas, especially ginger tea',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Kapha-Balancing Lifestyle',
        description: 'Energizing activities to motivate and invigorate.',
        suggestions: [
          'Engage in regular, vigorous exercise',
          'Wake up early (before 6 AM) to avoid morning sluggishness',
          'Seek variety and new experiences',
          'Declutter your living space regularly',
          'Stay socially active and engaged',
          'Challenge yourself with new learning opportunities',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Kapha Sleep Guidelines',
        description: 'Energizing sleep habits to avoid oversleeping.',
        suggestions: [
          'Aim for 6-7 hours of sleep, avoid oversleeping',
          'Wake up early, ideally before sunrise',
          'Keep your bedroom slightly cool and well-ventilated',
          'Avoid heavy meals close to bedtime',
          'Use an alarm and get up immediately when it rings',
          'Try energizing morning routines to start the day actively',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Kapha Stress Management',
        description: 'Stimulating practices to overcome lethargy and attachment.',
        suggestions: [
          'Practice energizing breathing exercises',
          'Engage in vigorous physical activity when feeling down',
          'Use stimulating essential oils like eucalyptus or peppermint',
          'Seek social support and avoid isolation',
          'Practice letting go of possessions and attachments',
          'Try new activities to break out of routine',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Kapha Seasonal Routines',
        description: 'Stay energized, especially during spring.',
        suggestions: [
          'Extra care during spring months (Kapha season)',
          'Increase light, spicy foods during cold, damp weather',
          'Engage in more vigorous exercise during spring',
          'Practice seasonal detox or cleansing',
          'Spend time in warm, dry environments',
          'Use this time for new beginnings and fresh starts',
        ],
      ),
    ];
  }

  List<Recommendation> _getVataPittaRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Vata-Pitta Balancing Diet',
        description: 'Moderate, nourishing foods that are neither too heating nor too cooling.',
        suggestions: [
          'Eat regular, moderate meals at consistent times',
          'Choose foods that are neither too hot nor too cold',
          'Include sweet, bitter, and astringent tastes',
          'Avoid very spicy or very cold foods',
          'Stay well-hydrated with room temperature water',
          'Include cooling oils like coconut and warming spices in moderation',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Vata-Pitta Lifestyle Balance',
        description: 'Structured yet flexible routines to balance both energies.',
        suggestions: [
          'Create structured routines but allow for some flexibility',
          'Practice moderate exercise - not too intense, not too gentle',
          'Balance mental stimulation with relaxation',
          'Avoid both overstimulation and boredom',
          'Cultivate both creativity and focus',
          'Maintain social connections while honoring need for solitude',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Vata-Pitta Sleep Balance',
        description: 'Consistent sleep routine with moderate environment.',
        suggestions: [
          'Maintain consistent bedtime around 10-10:30 PM',
          'Keep bedroom at moderate temperature',
          'Practice calming but not overly sedating bedtime routine',
          'Avoid both mental overstimulation and complete inactivity before bed',
          'Use moderate lighting in the evening',
          'Try balancing herbs like brahmi or shankhpushpi',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Vata-Pitta Stress Balance',
        description: 'Practices that calm anxiety while managing intensity.',
        suggestions: [
          'Practice balanced breathing techniques',
          'Engage in moderate physical activity for stress relief',
          'Use essential oils that are both calming and cooling',
          'Balance alone time with social interaction',
          'Practice both grounding and cooling meditation techniques',
          'Seek activities that are both creative and structured',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Vata-Pitta Seasonal Adaptation',
        description: 'Adjust routine based on which dosha is more aggravated by season.',
        suggestions: [
          'Follow Vata guidelines during fall and winter',
          'Follow Pitta guidelines during summer',
          'Pay attention to which dosha feels more imbalanced',
          'Adjust diet and lifestyle based on seasonal needs',
          'Practice extra self-care during transitional seasons',
          'Monitor energy levels and adjust routine accordingly',
        ],
      ),
    ];
  }

  List<Recommendation> _getPittaKaphaRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Pitta-Kapha Balancing Diet',
        description: 'Light, moderately spiced foods that are neither too heating nor too heavy.',
        suggestions: [
          'Eat light, warm foods with moderate spicing',
          'Choose bitter, pungent, and astringent tastes',
          'Avoid both very hot/spicy and very heavy/oily foods',
          'Eat larger lunch, lighter dinner',
          'Include warming spices but avoid excessive heat',
          'Stay hydrated but avoid ice-cold drinks',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Pitta-Kapha Lifestyle Balance',
        description: 'Energizing activities balanced with periods of rest.',
        suggestions: [
          'Engage in regular, moderately vigorous exercise',
          'Balance work intensity with adequate rest',
          'Seek variety while maintaining some routine',
          'Avoid both overexertion and excessive sedentary time',
          'Cultivate both determination and patience',
          'Balance social activities with quiet time',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Pitta-Kapha Sleep Balance',
        description: 'Moderate sleep duration with cool, comfortable environment.',
        suggestions: [
          'Aim for 7-8 hours of sleep',
          'Keep bedroom cool but not cold',
          'Wake up early but not extremely early',
          'Avoid both mental intensity and sluggishness before bed',
          'Use moderate, comfortable bedding',
          'Practice gentle evening routine',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Pitta-Kapha Stress Balance',
        description: 'Practices that manage both intensity and lethargy.',
        suggestions: [
          'Practice energizing yet cooling breathing techniques',
          'Engage in moderate physical activity for stress relief',
          'Use essential oils that are both stimulating and cooling',
          'Balance goal-oriented activities with relaxation',
          'Practice both motivating and calming meditation',
          'Seek activities that are both challenging and enjoyable',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Pitta-Kapha Seasonal Adaptation',
        description: 'Adjust routine based on seasonal dosha influences.',
        suggestions: [
          'Follow Pitta guidelines during summer',
          'Follow Kapha guidelines during spring',
          'Maintain moderate approach during other seasons',
          'Pay attention to which dosha feels more imbalanced',
          'Adjust exercise intensity based on season',
          'Monitor both energy levels and emotional intensity',
        ],
      ),
    ];
  }

  List<Recommendation> _getVataKaphaRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Vata-Kapha Balancing Diet',
        description: 'Warm, light foods that are nourishing yet not heavy.',
        suggestions: [
          'Eat warm, cooked foods that are light and easy to digest',
          'Choose sweet, pungent, and bitter tastes',
          'Include warming spices like ginger, cinnamon, and cardamom',
          'Avoid both very dry and very heavy foods',
          'Eat regular meals but avoid overeating',
          'Stay hydrated with warm herbal teas',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Vata-Kapha Lifestyle Balance',
        description: 'Gentle yet consistent activities to balance both energies.',
        suggestions: [
          'Create gentle but consistent daily routines',
          'Practice moderate exercise - yoga, walking, or swimming',
          'Balance stimulation with grounding activities',
          'Avoid both overstimulation and excessive inactivity',
          'Cultivate both creativity and stability',
          'Maintain social connections while honoring need for routine',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Vata-Kapha Sleep Balance',
        description: 'Consistent sleep routine with warm, comfortable environment.',
        suggestions: [
          'Maintain consistent bedtime around 9:30-10 PM',
          'Keep bedroom warm and comfortable',
          'Aim for 7-8 hours of sleep',
          'Practice gentle, grounding bedtime routine',
          'Avoid both mental overstimulation and oversleeping',
          'Use warm, comfortable bedding',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Vata-Kapha Stress Balance',
        description: 'Grounding practices that also provide gentle stimulation.',
        suggestions: [
          'Practice gentle, rhythmic breathing exercises',
          'Engage in moderate, enjoyable physical activities',
          'Use warming, grounding essential oils like sandalwood',
          'Balance quiet time with gentle social interaction',
          'Practice both grounding and energizing meditation',
          'Seek activities that are both comforting and mildly stimulating',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Vata-Kapha Seasonal Adaptation',
        description: 'Adjust routine based on seasonal dosha influences.',
        suggestions: [
          'Follow Vata guidelines during fall and winter',
          'Follow Kapha guidelines during spring',
          'Maintain warming practices during cold seasons',
          'Pay attention to which dosha feels more imbalanced',
          'Adjust activity levels based on seasonal energy',
          'Monitor both anxiety levels and motivation',
        ],
      ),
    ];
  }

  List<Recommendation> _getTridoshicRecommendations() {
    return [
      Recommendation(
        type: RecommendationType.diet,
        title: 'Tridoshic Balancing Diet',
        description: 'Balanced, seasonal eating to maintain equilibrium of all doshas.',
        suggestions: [
          'Eat according to the season and your current state',
          'Include all six tastes in your meals',
          'Choose fresh, whole foods over processed ones',
          'Eat mindfully and at regular times',
          'Stay hydrated with pure water',
          'Adjust diet based on which dosha feels most imbalanced',
        ],
      ),
      Recommendation(
        type: RecommendationType.lifestyle,
        title: 'Tridoshic Lifestyle Balance',
        description: 'Flexible lifestyle that adapts to maintain overall balance.',
        suggestions: [
          'Maintain flexible routines that can adapt to your needs',
          'Practice varied forms of exercise',
          'Balance work, rest, and play',
          'Stay attuned to your body\'s changing needs',
          'Cultivate all aspects of your personality',
          'Practice moderation in all activities',
        ],
      ),
      Recommendation(
        type: RecommendationType.sleep,
        title: 'Tridoshic Sleep Balance',
        description: 'Consistent sleep routine that adapts to your current needs.',
        suggestions: [
          'Maintain consistent sleep schedule around 10 PM',
          'Adjust bedroom environment based on current needs',
          'Aim for 7-8 hours of quality sleep',
          'Practice bedtime routine that feels right for you',
          'Listen to your body\'s sleep needs',
          'Adjust sleep practices seasonally',
        ],
      ),
      Recommendation(
        type: RecommendationType.stressManagement,
        title: 'Tridoshic Stress Balance',
        description: 'Varied stress management techniques for different situations.',
        suggestions: [
          'Use different stress management techniques as needed',
          'Practice various forms of meditation and breathing',
          'Engage in activities that balance all aspects of your nature',
          'Stay flexible in your approach to stress',
          'Seek balance between activity and rest',
          'Pay attention to which dosha is most affected by stress',
        ],
      ),
      Recommendation(
        type: RecommendationType.seasonal,
        title: 'Tridoshic Seasonal Adaptation',
        description: 'Seasonal adjustments to maintain balance of all doshas.',
        suggestions: [
          'Adjust lifestyle according to seasonal influences',
          'Follow seasonal eating guidelines',
          'Modify exercise routine based on season',
          'Pay attention to which dosha is most affected by each season',
          'Practice seasonal cleansing and renewal',
          'Maintain awareness of your changing needs throughout the year',
        ],
      ),
    ];
  }

  /// Generates a unique ID for assessment results
  String _generateResultId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return 'assessment_${timestamp}_$random';
  }
}