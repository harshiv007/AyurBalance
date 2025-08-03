import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../models/assessment_result.dart';
import '../services/assessment_service.dart';
import '../services/storage_service.dart';

/// ViewModel for managing assessment state and flow
class AssessmentViewModel extends ChangeNotifier {
  final AssessmentService _assessmentService;
  final StorageService _storageService;

  // Private state variables
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};
  bool _isLoading = false;
  String? _error;
  AssessmentResult? _completedResult;

  // Constructor
  AssessmentViewModel({
    AssessmentService? assessmentService,
    StorageService? storageService,
  }) : _assessmentService = assessmentService ?? AssessmentService(),
       _storageService = storageService ?? StorageService();

  // Getters
  List<Question> get questions => _questions;

  Question get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      throw StateError('No current question available');
    }
    return _questions[_currentQuestionIndex];
  }

  int get currentQuestionIndex => _currentQuestionIndex;

  Map<String, String> get answers => Map.unmodifiable(_answers);

  bool get isLoading => _isLoading;

  String? get error => _error;

  AssessmentResult? get completedResult => _completedResult;

  /// Calculate progress as a percentage (0.0 to 1.0)
  double get progress {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  /// Check if this is the last question
  bool get isLastQuestion {
    return _currentQuestionIndex == _questions.length - 1;
  }

  /// Check if this is the first question
  bool get isFirstQuestion {
    return _currentQuestionIndex == 0;
  }

  /// Check if the current question has been answered
  bool get isCurrentQuestionAnswered {
    if (_questions.isEmpty) return false;
    return _answers.containsKey(currentQuestion.id);
  }

  /// Get the selected answer for the current question
  String? get currentAnswer {
    if (_questions.isEmpty) return null;
    return _answers[currentQuestion.id];
  }

  /// Check if all questions have been answered
  bool get isAssessmentComplete {
    return _answers.length == _questions.length;
  }

  /// Get the number of answered questions
  int get answeredQuestionsCount => _answers.length;

  /// Load questions from the assessment service
  Future<void> loadQuestions() async {
    _setLoading(true);
    _clearError();

    try {
      _questions = _assessmentService.getQuestions();
      _currentQuestionIndex = 0;
      _answers.clear();
      _completedResult = null;

      if (_questions.isEmpty) {
        throw Exception('No questions available');
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load questions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Answer the current question
  void answerQuestion(String questionId, String optionId) {
    _clearError();

    // Validate that the question exists
    final question = _questions.firstWhere(
      (q) => q.id == questionId,
      orElse: () => throw ArgumentError('Question not found: $questionId'),
    );

    // Validate that the option exists for this question
    question.options.firstWhere(
      (opt) => opt.id == optionId,
      orElse: () => throw ArgumentError('Option not found: $optionId'),
    );

    // Store the answer
    _answers[questionId] = optionId;
    notifyListeners();
  }

  /// Move to the next question
  void nextQuestion() {
    _clearError();

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Move to the previous question
  void previousQuestion() {
    _clearError();

    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Jump to a specific question by index
  void goToQuestion(int index) {
    _clearError();

    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    } else {
      throw ArgumentError('Invalid question index: $index');
    }
  }

  /// Complete the assessment and calculate results
  Future<AssessmentResult> completeAssessment() async {
    _setLoading(true);
    _clearError();

    try {
      // Validate that all questions are answered
      if (!isAssessmentComplete) {
        throw Exception(
          'Assessment is not complete. ${_questions.length - _answers.length} questions remaining.',
        );
      }

      // Calculate the result
      final result = _assessmentService.calculateResult(_answers);

      // Save the result to local storage
      await _storageService.saveAssessmentResult(result);

      _completedResult = result;
      notifyListeners();

      return result;
    } catch (e) {
      _setError('Failed to complete assessment: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset the assessment to start over
  void resetAssessment() {
    _currentQuestionIndex = 0;
    _answers.clear();
    _completedResult = null;
    _clearError();
    notifyListeners();
  }

  /// Get answers by category
  Map<QuestionCategory, Map<String, String>> getAnswersByCategory() {
    final Map<QuestionCategory, Map<String, String>> categorizedAnswers = {};

    for (final question in _questions) {
      final answer = _answers[question.id];
      if (answer != null) {
        categorizedAnswers.putIfAbsent(question.category, () => {});
        categorizedAnswers[question.category]![question.id] = answer;
      }
    }

    return categorizedAnswers;
  }

  /// Get progress for a specific category
  double getCategoryProgress(QuestionCategory category) {
    final categoryQuestions = _questions
        .where((q) => q.category == category)
        .toList();
    if (categoryQuestions.isEmpty) return 0.0;

    final answeredInCategory = categoryQuestions
        .where((q) => _answers.containsKey(q.id))
        .length;
    return answeredInCategory / categoryQuestions.length;
  }

  /// Get the current category being assessed
  QuestionCategory? get currentCategory {
    if (_questions.isEmpty) return null;
    return currentQuestion.category;
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
