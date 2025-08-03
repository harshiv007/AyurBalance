import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/assessment_viewmodel.dart';
import '../../utils/constants.dart';
import '../widgets/question_card.dart';
import '../widgets/assessment_progress_indicator.dart';
import 'results_screen.dart';

/// Screen for conducting the Ayurvedic prakriti assessment
class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late AssessmentViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAssessment();
    });
  }

  Future<void> _initializeAssessment() async {
    _viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    await _viewModel.loadQuestions();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isInitialized ? _buildBody(context) : _buildLoadingState(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        'Assessment',
        style: TextStyle(
          fontSize: AppConstants.subheadingTextSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _handleBackPress(context),
      ),
      actions: [
        Consumer<AssessmentViewModel>(
          builder: (context, viewModel, child) {
            if (!_isInitialized || viewModel.questions.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
              child: Center(
                child: Text(
                  '${viewModel.answeredQuestionsCount}/${viewModel.questions.length}',
                  style: TextStyle(
                    fontSize: AppConstants.bodyTextSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<AssessmentViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _buildLoadingState(context);
        }

        if (viewModel.error != null) {
          return _buildErrorState(context, viewModel.error!);
        }

        if (viewModel.questions.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          children: [
            // Progress indicator
            AssessmentProgressIndicator(
              currentQuestion: viewModel.currentQuestionIndex + 1,
              totalQuestions: viewModel.questions.length,
              progress: viewModel.progress,
            ),
            
            // Question content
            Expanded(
              child: PageView.builder(
                controller: PageController(
                  initialPage: viewModel.currentQuestionIndex,
                ),
                onPageChanged: (index) {
                  // Update the view model when user swipes
                  if (index != viewModel.currentQuestionIndex) {
                    viewModel.goToQuestion(index);
                  }
                },
                itemCount: viewModel.questions.length,
                itemBuilder: (context, index) {
                  final question = viewModel.questions[index];
                  final selectedAnswer = viewModel.answers[question.id];
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    child: QuestionCard(
                      question: question,
                      selectedOptionId: selectedAnswer,
                      onAnswerSelected: (optionId) {
                        viewModel.answerQuestion(question.id, optionId);
                        
                        // Auto-advance to next question after a short delay
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted && !viewModel.isLastQuestion) {
                            viewModel.nextQuestion();
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context, AssessmentViewModel viewModel) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            if (!viewModel.isFirstQuestion) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: viewModel.previousQuestion,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, size: 18),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: AppConstants.bodyTextSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
            ],
            
            // Next/Complete button
            Expanded(
              flex: viewModel.isFirstQuestion ? 1 : 1,
              child: ElevatedButton(
                onPressed: viewModel.isCurrentQuestionAnswered
                    ? () => _handleNextOrComplete(context, viewModel)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.isLastQuestion ? 'Complete Assessment' : 'Next',
                      style: TextStyle(
                        fontSize: AppConstants.bodyTextSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Icon(
                      viewModel.isLastQuestion ? Icons.check : Icons.arrow_forward,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Loading assessment questions...',
            style: TextStyle(
              fontSize: AppConstants.bodyTextSize,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              error,
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ElevatedButton(
              onPressed: () => _initializeAssessment(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'No questions available',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Please check back later or contact support.',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextOrComplete(BuildContext context, AssessmentViewModel viewModel) {
    if (viewModel.isLastQuestion) {
      _completeAssessment(context, viewModel);
    } else {
      viewModel.nextQuestion();
    }
  }

  Future<void> _completeAssessment(BuildContext context, AssessmentViewModel viewModel) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Complete the assessment
      final result = await viewModel.completeAssessment();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Navigate to results screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultsScreen(result: result),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Assessment Error'),
            content: Text('Failed to complete assessment: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _handleBackPress(BuildContext context) {
    // Show confirmation dialog if assessment is in progress
    if (_isInitialized && _viewModel.answeredQuestionsCount > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Leave Assessment?'),
          content: const Text(
            'Your progress will be lost if you leave now. Are you sure you want to go back?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('Leave'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}