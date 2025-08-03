import 'package:flutter/material.dart';
import '../../models/assessment_result.dart';
import '../../models/dosha.dart';
import '../../services/navigation_service.dart';
import '../../services/dependency_injection.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../widgets/dosha_avatar.dart';
import '../widgets/recommendation_card.dart';

/// Screen that displays assessment results with prakriti analysis and recommendations
class ResultsScreen extends StatefulWidget {
  final AssessmentResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with ViewModelLifecycleMixin {
  @override
  void initializeViewModels() {
    context.resultsViewModel.setCurrentResult(widget.result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        'Your Results',
        style: TextStyle(
          fontSize: AppConstants.subheadingTextSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _navigateToWelcome(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => _navigateToHistory(context),
          tooltip: 'View History',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prakriti type display
          _buildPrakritiTypeCard(context),

          const SizedBox(height: AppConstants.largePadding),

          // Dosha score breakdown
          _buildDoshaScoreBreakdown(context),

          const SizedBox(height: AppConstants.largePadding),

          // Selected traits summary
          _buildSelectedTraits(context),

          const SizedBox(height: AppConstants.largePadding),

          // Recommendations section
          _buildRecommendationsSection(context),

          const SizedBox(height: AppConstants.largePadding),

          // Action buttons
          _buildActionButtons(context),

          const SizedBox(height: AppConstants.defaultPadding),
        ],
      ),
    );
  }

  Widget _buildPrakritiTypeCard(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            // Congratulations text
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),

            Text(
              'Your Ayurvedic constitution is',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Prakriti type with avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (result.dominantDoshas.length == 1)
                  DoshaAvatar(
                    doshaType: result.dominantDoshas.first,
                    size: DoshaAvatarSize.large,
                  )
                else
                  // Show multiple avatars for dual/tri-doshic types
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: result.dominantDoshas
                        .map(
                          (dosha) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: DoshaAvatar(
                              doshaType: dosha,
                              size: DoshaAvatarSize.medium,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(width: AppConstants.defaultPadding),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.prakritiType.displayName,
                      style: TextStyle(
                        fontSize: AppConstants.headingTextSize,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Constitution',
                      style: TextStyle(
                        fontSize: AppConstants.bodyTextSize,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Description
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Text(
                result.prakritiType.description,
                style: TextStyle(
                  fontSize: AppConstants.bodyTextSize,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaScoreBreakdown(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;
    final percentages = result.doshaPercentages;

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dosha Balance',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            ...DoshaType.values.map((doshaType) {
              final percentage = percentages[doshaType] ?? 0.0;
              final score = result.doshaScores[doshaType] ?? 0;
              final color = AppTheme.getDoshaColor(doshaType);

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            DoshaAvatar(
                              doshaType: doshaType,
                              size: DoshaAvatarSize.small,
                            ),
                            const SizedBox(width: AppConstants.smallPadding),
                            Text(
                              doshaType.displayName,
                              style: TextStyle(
                                fontSize: AppConstants.bodyTextSize,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${percentage.round()}% ($score)',
                          style: TextStyle(
                            fontSize: AppConstants.bodyTextSize,
                            fontWeight: FontWeight.w600,
                            color: color,
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
                      child: FractionallySizedBox(
                        widthFactor: percentage / 100,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTraits(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Selected Traits',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            ...result.selectedTraits.entries.map((entry) {
              final category = entry.key;
              final traits = entry.value;

              if (traits.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: AppConstants.bodyTextSize,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: AppConstants.smallPadding),

                    Wrap(
                      spacing: AppConstants.smallPadding,
                      runSpacing: AppConstants.smallPadding,
                      children: traits
                          .map(
                            (trait) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.smallPadding,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                trait,
                                style: TextStyle(
                                  fontSize: AppConstants.captionTextSize,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalized Recommendations',
          style: TextStyle(
            fontSize: AppConstants.subheadingTextSize,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        Text(
          'Based on your ${result.prakritiType.displayName} constitution, here are tailored wellness recommendations:',
          style: TextStyle(
            fontSize: AppConstants.bodyTextSize,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Recommendation cards
        ...result.recommendations.map(
          (recommendation) => RecommendationCard(
            recommendation: recommendation,
            initiallyExpanded: false,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Save Results button (if not already saved)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _saveResults(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            icon: const Icon(Icons.save, size: 20),
            label: Text(
              'Save Results',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Retake Assessment button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _retakeAssessment(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: Text(
              'Retake Assessment',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveResults(BuildContext context) {
    // Results are automatically saved during assessment completion
    // This button provides user feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Results saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _retakeAssessment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retake Assessment?'),
        content: const Text(
          'Are you sure you want to retake the assessment? This will start a new assessment from the beginning.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _navigateToWelcome(context);
            },
            child: const Text('Retake'),
          ),
        ],
      ),
    );
  }

  void _navigateToWelcome(BuildContext context) {
    NavigationService.navigateToWelcome();
  }

  void _navigateToHistory(BuildContext context) {
    NavigationService.navigateToHistory();
  }
}
