import '../models/dosha.dart';
import '../models/question.dart';

/// Service responsible for calculating dosha scores and determining prakriti type
/// based on assessment answers.
class DoshaCalculator {
  /// Calculates dosha scores based on user answers to assessment questions.
  /// 
  /// Takes a map of question IDs to selected option IDs and returns
  /// the total score for each dosha type.
  Map<DoshaType, int> calculateDoshaScores(
    Map<String, String> answers,
    List<Question> questions,
  ) {
    final scores = <DoshaType, int>{
      DoshaType.vata: 0,
      DoshaType.pitta: 0,
      DoshaType.kapha: 0,
    };

    // Create a lookup map for quick option access
    final optionLookup = <String, QuestionOption>{};
    for (final question in questions) {
      for (final option in question.options) {
        optionLookup[option.id] = option;
      }
    }

    // Calculate scores based on selected options
    for (final entry in answers.entries) {
      final selectedOption = optionLookup[entry.value];
      if (selectedOption != null) {
        scores[selectedOption.primaryDosha] = 
            (scores[selectedOption.primaryDosha] ?? 0) + selectedOption.weight;
      }
    }

    return scores;
  }

  /// Determines the prakriti type based on dosha scores.
  /// 
  /// Uses the following logic:
  /// - Tridoshic: All three doshas are within 30% of the highest score
  /// - Dual dosha: Two doshas are within 20% of each other and significantly higher than third
  /// - Single dosha: One dosha is clearly dominant
  PrakritiType determinePrakritiType(Map<DoshaType, int> scores) {
    final sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final highest = sortedEntries[0].value;
    final second = sortedEntries[1].value;
    final third = sortedEntries[2].value;

    // Handle edge case where all scores are zero
    if (highest == 0) {
      return PrakritiType.tridoshic;
    }

    // Check for tridoshic first (all three within 30% of highest)
    if (third >= (highest * 0.7)) {
      return PrakritiType.tridoshic;
    }

    // Check for dual dosha (second within 20% of highest, and both significantly higher than third)
    if (second >= (highest * 0.8) && second > (third * 1.5)) {
      return _getDualDoshaType(sortedEntries[0].key, sortedEntries[1].key);
    }

    // Default to single dosha
    return _getSingleDoshaType(sortedEntries[0].key);
  }

  /// Extracts selected traits from answers, organized by question category.
  /// 
  /// Maps user answers to the text of selected options, grouped by
  /// the category of questions they answered.
  Map<QuestionCategory, List<String>> extractSelectedTraits(
    Map<String, String> answers,
    List<Question> questions,
  ) {
    final traits = <QuestionCategory, List<String>>{
      QuestionCategory.physicalTraits: [],
      QuestionCategory.mentalEmotional: [],
      QuestionCategory.habitsPreferences: [],
      QuestionCategory.environmentalReactions: [],
    };

    // Create lookup maps for questions and options
    final questionLookup = <String, Question>{};
    final optionLookup = <String, QuestionOption>{};
    
    for (final question in questions) {
      questionLookup[question.id] = question;
      for (final option in question.options) {
        optionLookup[option.id] = option;
      }
    }

    // Extract traits based on selected answers
    for (final entry in answers.entries) {
      final questionId = entry.key;
      final selectedOptionId = entry.value;
      
      final question = questionLookup[questionId];
      final selectedOption = optionLookup[selectedOptionId];
      
      if (question != null && selectedOption != null) {
        traits[question.category]?.add(selectedOption.text);
      }
    }

    return traits;
  }

  /// Converts a single DoshaType to its corresponding PrakritiType
  PrakritiType _getSingleDoshaType(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return PrakritiType.vata;
      case DoshaType.pitta:
        return PrakritiType.pitta;
      case DoshaType.kapha:
        return PrakritiType.kapha;
    }
  }

  /// Determines the dual dosha prakriti type based on two dominant doshas
  PrakritiType _getDualDoshaType(DoshaType first, DoshaType second) {
    final doshaSet = {first, second};
    
    if (doshaSet.contains(DoshaType.vata) && doshaSet.contains(DoshaType.pitta)) {
      return PrakritiType.vataPitta;
    } else if (doshaSet.contains(DoshaType.pitta) && doshaSet.contains(DoshaType.kapha)) {
      return PrakritiType.pittaKapha;
    } else if (doshaSet.contains(DoshaType.vata) && doshaSet.contains(DoshaType.kapha)) {
      return PrakritiType.vataKapha;
    }
    
    // Fallback to single dosha if combination not recognized
    return _getSingleDoshaType(first);
  }
}