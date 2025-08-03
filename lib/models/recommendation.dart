enum RecommendationType {
  diet,
  lifestyle,
  sleep,
  stressManagement,
  seasonal;

  String get displayName {
    switch (this) {
      case RecommendationType.diet:
        return 'Diet & Nutrition';
      case RecommendationType.lifestyle:
        return 'Lifestyle';
      case RecommendationType.sleep:
        return 'Sleep & Rest';
      case RecommendationType.stressManagement:
        return 'Stress Management';
      case RecommendationType.seasonal:
        return 'Seasonal Routines';
    }
  }

  String get iconPath {
    switch (this) {
      case RecommendationType.diet:
        return 'assets/icons/diet.png';
      case RecommendationType.lifestyle:
        return 'assets/icons/lifestyle.png';
      case RecommendationType.sleep:
        return 'assets/icons/sleep.png';
      case RecommendationType.stressManagement:
        return 'assets/icons/stress.png';
      case RecommendationType.seasonal:
        return 'assets/icons/seasonal.png';
    }
  }
}

class Recommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final List<String> suggestions;

  const Recommendation({
    required this.type,
    required this.title,
    required this.description,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'title': title,
      'description': description,
      'suggestions': suggestions,
    };
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      type: RecommendationType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recommendation &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.suggestions.length == suggestions.length &&
        other.suggestions.every(
          (suggestion) => suggestions.contains(suggestion),
        );
  }

  @override
  int get hashCode {
    return Object.hash(type, title, description, suggestions);
  }
}
