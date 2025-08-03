# Design Document

## Overview

The Ayurvedic Prakriti Assessment app is a Flutter mobile application that provides users with a comprehensive self-assessment tool to determine their Ayurvedic body constitution type. The app follows the MVVM (Model-View-ViewModel) architectural pattern with clean separation of concerns, utilizing Flutter's built-in state management capabilities through ChangeNotifier and local storage for offline functionality.

The application guides users through a structured questionnaire covering four main categories: Physical Traits, Mental/Emotional Traits, Habits/Preferences, and Environmental Reactions. Based on user responses, the app calculates dominant dosha(s) and provides personalized wellness recommendations.

## Architecture

### Architectural Pattern: MVVM

The application follows the Model-View-ViewModel (MVVM) pattern:

- **Model**: Data classes and business logic for dosha analysis
- **View**: Flutter widgets for UI presentation
- **ViewModel**: State management using ChangeNotifier to bridge Model and View

### Core Components

```
lib/
├── main.dart
├── models/
│   ├── question.dart
│   ├── assessment_result.dart
│   ├── dosha.dart
│   └── recommendation.dart
├── viewmodels/
│   ├── assessment_viewmodel.dart
│   ├── results_viewmodel.dart
│   └── theme_viewmodel.dart
├── views/
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── assessment_screen.dart
│   │   ├── results_screen.dart
│   │   └── history_screen.dart
│   └── widgets/
│       ├── question_card.dart
│       ├── progress_indicator.dart
│       ├── dosha_avatar.dart
│       └── recommendation_card.dart
├── services/
│   ├── assessment_service.dart
│   ├── storage_service.dart
│   └── dosha_calculator.dart
└── utils/
    ├── constants.dart
    ├── theme.dart
    └── extensions.dart
```

## Components and Interfaces

### 1. Data Models

#### Question Model
```dart
class Question {
  final String id;
  final String text;
  final QuestionCategory category;
  final List<QuestionOption> options;
}

class QuestionOption {
  final String text;
  final DoshaType primaryDosha;
  final int weight;
}

enum QuestionCategory {
  physicalTraits,
  mentalEmotional,
  habitsPreferences,
  environmentalReactions
}
```

#### Assessment Result Model
```dart
class AssessmentResult {
  final String id;
  final DateTime timestamp;
  final Map<DoshaType, int> doshaScores;
  final PrakritiType prakritiType;
  final Map<QuestionCategory, List<String>> selectedTraits;
  final List<Recommendation> recommendations;
}

enum PrakritiType {
  vata,
  pitta,
  kapha,
  vataPitta,
  pittaKapha,
  vataKapha,
  tridoshic
}
```

#### Dosha Model
```dart
class Dosha {
  final DoshaType type;
  final String name;
  final String description;
  final Color primaryColor;
  final String iconPath;
  final List<String> characteristics;
}

enum DoshaType { vata, pitta, kapha }
```

#### Recommendation Model
```dart
class Recommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final List<String> suggestions;
}

enum RecommendationType {
  diet,
  lifestyle,
  sleep,
  stressManagement,
  seasonal
}
```

### 2. ViewModels

#### AssessmentViewModel
```dart
class AssessmentViewModel extends ChangeNotifier {
  final AssessmentService _assessmentService;
  final StorageService _storageService;
  
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, String> _answers = {};
  bool _isLoading = false;
  
  // Getters
  List<Question> get questions => _questions;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  double get progress => (_currentQuestionIndex + 1) / _questions.length;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  bool get isLoading => _isLoading;
  
  // Methods
  Future<void> loadQuestions();
  void answerQuestion(String questionId, String optionId);
  void nextQuestion();
  void previousQuestion();
  Future<AssessmentResult> completeAssessment();
}
```

#### ResultsViewModel
```dart
class ResultsViewModel extends ChangeNotifier {
  final StorageService _storageService;
  
  AssessmentResult? _currentResult;
  List<AssessmentResult> _history = [];
  bool _isLoading = false;
  
  // Getters
  AssessmentResult? get currentResult => _currentResult;
  List<AssessmentResult> get history => _history;
  bool get isLoading => _isLoading;
  
  // Methods
  Future<void> loadResult(String resultId);
  Future<void> loadHistory();
  Future<void> deleteResult(String resultId);
  void setCurrentResult(AssessmentResult result);
}
```

#### ThemeViewModel
```dart
class ThemeViewModel extends ChangeNotifier {
  final StorageService _storageService;
  
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  Future<void> loadThemePreference();
  Future<void> toggleTheme();
}
```

### 3. Services

#### AssessmentService
```dart
class AssessmentService {
  List<Question> getQuestions();
  AssessmentResult calculateResult(Map<String, String> answers);
  List<Recommendation> generateRecommendations(PrakritiType prakritiType);
}
```

#### DoshaCalculator
```dart
class DoshaCalculator {
  Map<DoshaType, int> calculateDoshaScores(Map<String, String> answers);
  PrakritiType determinePrakritiType(Map<DoshaType, int> scores);
  Map<QuestionCategory, List<String>> extractSelectedTraits(
    Map<String, String> answers
  );
}
```

#### StorageService
```dart
class StorageService {
  Future<void> saveAssessmentResult(AssessmentResult result);
  Future<List<AssessmentResult>> getAssessmentHistory();
  Future<AssessmentResult?> getAssessmentResult(String id);
  Future<void> deleteAssessmentResult(String id);
  Future<void> saveThemePreference(bool isDarkMode);
  Future<bool> getThemePreference();
}
```

## Data Models

### Question Data Structure

The app contains approximately 40-50 questions across four categories:

1. **Physical Traits (12-15 questions)**
   - Skin type, texture, and characteristics
   - Body build and frame
   - Hair type, thickness, and texture
   - Eye size, color, and brightness
   - Voice quality and speech patterns

2. **Mental and Emotional Traits (10-12 questions)**
   - Mindset and mental patterns
   - Memory characteristics
   - Emotional tendencies and reactions
   - Learning preferences
   - Decision-making style

3. **Habits and Preferences (12-15 questions)**
   - Dietary preferences and digestion
   - Sleep patterns and quality
   - Energy levels throughout the day
   - Exercise preferences
   - Daily routine preferences

4. **Environmental Reactions (8-10 questions)**
   - Weather and climate preferences
   - Stress response patterns
   - Social interaction preferences
   - Seasonal variations in mood/energy

### Dosha Mapping Logic

Each question option maps to one of the three doshas with weighted scoring:

- **Vata Characteristics**: Dry skin, thin build, restless mind, light sleep, prefers warmth, anxious under stress
- **Pitta Characteristics**: Oily/sensitive skin, muscular build, intense focus, moderate sleep, prefers cool, irritable under stress  
- **Kapha Characteristics**: Thick/oily skin, heavy build, calm mind, deep sleep, tolerates most weather, remains calm under stress

### Scoring Algorithm

```dart
// Simplified scoring logic
Map<DoshaType, int> calculateScores(Map<String, String> answers) {
  Map<DoshaType, int> scores = {
    DoshaType.vata: 0,
    DoshaType.pitta: 0,
    DoshaType.kapha: 0,
  };
  
  for (String answerId in answers.values) {
    QuestionOption option = getOptionById(answerId);
    scores[option.primaryDosha] += option.weight;
  }
  
  return scores;
}
```

### Prakriti Determination

```dart
PrakritiType determinePrakriti(Map<DoshaType, int> scores) {
  List<MapEntry<DoshaType, int>> sortedScores = scores.entries
      .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  
  int highest = sortedScores[0].value;
  int second = sortedScores[1].value;
  int third = sortedScores[2].value;
  
  // Single dosha dominant (>50% of total)
  if (highest > (second + third)) {
    return PrakritiType.values[sortedScores[0].key.index];
  }
  
  // Dual dosha types (within 20% of each other)
  if ((highest - second) <= (highest * 0.2)) {
    return getDualDoshaType(sortedScores[0].key, sortedScores[1].key);
  }
  
  // Tridoshic (all three within 30% of each other)
  if ((highest - third) <= (highest * 0.3)) {
    return PrakritiType.tridoshic;
  }
  
  return PrakritiType.values[sortedScores[0].key.index];
}
```

## Error Handling

### Error Types and Handling Strategy

1. **Storage Errors**
   - Failed to save assessment results
   - Failed to load previous results
   - Corrupted data recovery

2. **Assessment Errors**
   - Invalid question data
   - Missing or incomplete answers
   - Calculation errors

3. **UI Errors**
   - Navigation errors
   - Theme switching failures
   - Widget rendering issues

### Error Handling Implementation

```dart
class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  
  AppError(this.type, this.message, [this.details]);
}

enum ErrorType {
  storage,
  assessment,
  network,
  ui,
  unknown
}

// In ViewModels
Future<void> saveResult(AssessmentResult result) async {
  try {
    await _storageService.saveAssessmentResult(result);
  } catch (e) {
    _error = AppError(ErrorType.storage, 'Failed to save assessment result', e.toString());
    notifyListeners();
  }
}
```

## Testing Strategy

### Unit Testing

1. **Model Tests**
   - Question and option data validation
   - Assessment result calculation accuracy
   - Dosha scoring algorithm verification

2. **Service Tests**
   - Storage service CRUD operations
   - Assessment service question loading
   - Dosha calculator logic validation

3. **ViewModel Tests**
   - State management behavior
   - Error handling scenarios
   - Navigation flow logic

### Widget Testing

1. **Screen Tests**
   - Welcome screen navigation
   - Assessment screen question flow
   - Results screen data display
   - History screen list functionality

2. **Component Tests**
   - Question card interaction
   - Progress indicator accuracy
   - Dosha avatar display
   - Recommendation card layout

### Integration Testing

1. **End-to-End Flows**
   - Complete assessment journey
   - Result saving and retrieval
   - Theme switching functionality
   - History management

2. **Storage Integration**
   - Data persistence across app restarts
   - Migration handling for data structure changes
   - Performance with large datasets

### Test Structure

```dart
// Example unit test
void main() {
  group('DoshaCalculator', () {
    late DoshaCalculator calculator;
    
    setUp(() {
      calculator = DoshaCalculator();
    });
    
    test('should calculate correct dosha scores', () {
      // Test implementation
    });
    
    test('should determine single dosha prakriti', () {
      // Test implementation
    });
    
    test('should determine dual dosha prakriti', () {
      // Test implementation
    });
  });
}
```

### Performance Considerations

1. **Memory Management**
   - Efficient question loading and caching
   - Proper disposal of ViewModels and listeners
   - Image and asset optimization

2. **Storage Optimization**
   - Efficient JSON serialization
   - Compressed storage for large datasets
   - Background saving operations

3. **UI Performance**
   - Smooth animations and transitions
   - Efficient list rendering for history
   - Responsive design for different screen sizes

### Accessibility

1. **Screen Reader Support**
   - Semantic labels for all interactive elements
   - Proper heading hierarchy
   - Alternative text for images and icons

2. **Navigation**
   - Keyboard navigation support
   - Focus management
   - Clear visual focus indicators

3. **Visual Accessibility**
   - High contrast color schemes
   - Scalable text sizes
   - Color-blind friendly design

### Localization Considerations

While not in the initial requirements, the design supports future localization:

1. **Text Externalization**
   - All user-facing strings in separate files
   - Question content in JSON format
   - Recommendation text in structured format

2. **Cultural Adaptation**
   - Flexible recommendation system
   - Culturally appropriate imagery
   - Regional Ayurvedic variations support