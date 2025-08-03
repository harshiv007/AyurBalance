import 'dosha.dart';

enum QuestionCategory {
  physicalTraits,
  mentalEmotional,
  habitsPreferences,
  environmentalReactions;

  String get displayName {
    switch (this) {
      case QuestionCategory.physicalTraits:
        return 'Physical Traits';
      case QuestionCategory.mentalEmotional:
        return 'Mental & Emotional';
      case QuestionCategory.habitsPreferences:
        return 'Habits & Preferences';
      case QuestionCategory.environmentalReactions:
        return 'Environmental Reactions';
    }
  }
}

class QuestionOption {
  final String id;
  final String text;
  final DoshaType primaryDosha;
  final int weight;

  const QuestionOption({
    required this.id,
    required this.text,
    required this.primaryDosha,
    this.weight = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'primaryDosha': primaryDosha.name,
      'weight': weight,
    };
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      text: json['text'] as String,
      primaryDosha: DoshaType.values.firstWhere(
        (e) => e.name == json['primaryDosha'],
      ),
      weight: json['weight'] as int? ?? 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionOption &&
        other.id == id &&
        other.text == text &&
        other.primaryDosha == primaryDosha &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return Object.hash(id, text, primaryDosha, weight);
  }
}

class Question {
  final String id;
  final String text;
  final QuestionCategory category;
  final List<QuestionOption> options;

  const Question({
    required this.id,
    required this.text,
    required this.category,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category.name,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      category: QuestionCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      options: (json['options'] as List<dynamic>)
          .map((optionJson) => QuestionOption.fromJson(optionJson as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question &&
        other.id == id &&
        other.text == text &&
        other.category == category &&
        other.options.length == options.length &&
        other.options.every((option) => options.contains(option));
  }

  @override
  int get hashCode {
    return Object.hash(id, text, category, options);
  }
}