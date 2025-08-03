import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// A custom progress indicator widget for the assessment
class AssessmentProgressIndicator extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress; // Value between 0.0 and 1.0

  const AssessmentProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  State<AssessmentProgressIndicator> createState() =>
      _AssessmentProgressIndicatorState();
}

class _AssessmentProgressIndicatorState
    extends State<AssessmentProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AssessmentProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      _progressAnimation =
          Tween<double>(begin: _previousProgress, end: widget.progress).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${widget.currentQuestion} of ${widget.totalQuestions}',
                style: TextStyle(
                  fontSize: AppConstants.bodyTextSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${(widget.progress * 100).round()}%',
                style: TextStyle(
                  fontSize: AppConstants.bodyTextSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Background track
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),

                    // Progress fill with gradient
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Animated shimmer effect
                    if (_progressAnimation.value > 0)
                      FractionallySizedBox(
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Category progress indicators (optional visual enhancement)
          _buildCategoryIndicators(context),
        ],
      ),
    );
  }

  Widget _buildCategoryIndicators(BuildContext context) {
    final theme = Theme.of(context);
    final questionsPerCategory =
        widget.totalQuestions ~/ 4; // Assuming 4 categories
    final currentCategory =
        (widget.currentQuestion - 1) ~/ questionsPerCategory;

    return Row(
      children: List.generate(4, (index) {
        final isCompleted = index < currentCategory;
        final isCurrent = index == currentCategory;

        Color indicatorColor;
        if (isCompleted) {
          indicatorColor = theme.colorScheme.primary;
        } else if (isCurrent) {
          indicatorColor = theme.colorScheme.primary.withValues(alpha: 0.6);
        } else {
          indicatorColor = theme.colorScheme.surfaceContainerHighest;
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < 3 ? AppConstants.smallPadding : 0,
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: indicatorColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCategoryName(index),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: indicatorColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _getCategoryName(int index) {
    switch (index) {
      case 0:
        return 'Physical';
      case 1:
        return 'Mental';
      case 2:
        return 'Habits';
      case 3:
        return 'Environment';
      default:
        return '';
    }
  }
}
