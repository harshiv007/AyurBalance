import 'dosha.dart';
import 'question.dart';
import 'recommendation.dart';

class AssessmentResult {
  final String id;
  final DateTime timestamp;
  final Map<DoshaType, int> doshaScores;
  final PrakritiType prakritiType;
  final Map<QuestionCategory, List<String>> selectedTraits;
  final List<Recommendation> recommendations;

  const AssessmentResult({
    required this.id,
    required this.timestamp,
    required this.doshaScores,
    required this.prakritiType,
    required this.selectedTraits,
    required this.recommendations,
  });

  /// Get the total score across all doshas
  int get totalScore {
    return doshaScores.values.fold(0, (sum, score) => sum + score);
  }

  /// Get dosha scores as percentages
  Map<DoshaType, double> get doshaPercentages {
    final total = totalScore;
    if (total == 0) {
      return {DoshaType.vata: 0.0, DoshaType.pitta: 0.0, DoshaType.kapha: 0.0};
    }

    return doshaScores.map(
      (dosha, score) => MapEntry(dosha, (score / total) * 100),
    );
  }

  /// Get the dominant dosha(s) based on scores
  List<DoshaType> get dominantDoshas {
    final sortedEntries = doshaScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final highestScore = sortedEntries.first.value;
    return sortedEntries
        .where((entry) => entry.value == highestScore)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get recommendations by type
  List<Recommendation> getRecommendationsByType(RecommendationType type) {
    return recommendations.where((rec) => rec.type == type).toList();
  }

  /// Get all selected traits as a flat list
  List<String> get allSelectedTraits {
    return selectedTraits.values.expand((traits) => traits).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'doshaScores': doshaScores.map(
        (dosha, score) => MapEntry(dosha.name, score),
      ),
      'prakritiType': prakritiType.name,
      'selectedTraits': selectedTraits.map(
        (category, traits) => MapEntry(category.name, traits),
      ),
      'recommendations': recommendations.map((rec) => rec.toJson()).toList(),
    };
  }

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      doshaScores: (json['doshaScores'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          DoshaType.values.firstWhere((e) => e.name == key),
          value as int,
        ),
      ),
      prakritiType: PrakritiType.values.firstWhere(
        (e) => e.name == json['prakritiType'],
      ),
      selectedTraits: (json['selectedTraits'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          QuestionCategory.values.firstWhere((e) => e.name == key),
          List<String>.from(value as List),
        ),
      ),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map(
            (recJson) =>
                Recommendation.fromJson(recJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// Create a copy with updated values
  AssessmentResult copyWith({
    String? id,
    DateTime? timestamp,
    Map<DoshaType, int>? doshaScores,
    PrakritiType? prakritiType,
    Map<QuestionCategory, List<String>>? selectedTraits,
    List<Recommendation>? recommendations,
  }) {
    return AssessmentResult(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      doshaScores: doshaScores ?? this.doshaScores,
      prakritiType: prakritiType ?? this.prakritiType,
      selectedTraits: selectedTraits ?? this.selectedTraits,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentResult &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.doshaScores.length == doshaScores.length &&
        other.doshaScores.entries.every(
          (entry) => doshaScores[entry.key] == entry.value,
        ) &&
        other.prakritiType == prakritiType &&
        other.selectedTraits.length == selectedTraits.length &&
        other.selectedTraits.entries.every(
          (entry) =>
              selectedTraits[entry.key]?.length == entry.value.length &&
              selectedTraits[entry.key]!.every(
                (trait) => entry.value.contains(trait),
              ),
        ) &&
        other.recommendations.length == recommendations.length &&
        other.recommendations.every((rec) => recommendations.contains(rec));
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      timestamp,
      doshaScores,
      prakritiType,
      selectedTraits,
      recommendations,
    );
  }

  @override
  String toString() {
    return 'AssessmentResult(id: $id, prakritiType: $prakritiType, timestamp: $timestamp)';
  }
}
