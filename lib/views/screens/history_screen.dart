import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assessment_result.dart';
import '../../models/dosha.dart';
import '../../viewmodels/results_viewmodel.dart';
import '../../services/navigation_service.dart';
import '../../services/dependency_injection.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../widgets/dosha_avatar.dart';

/// Screen that displays the history of saved assessment results
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with ViewModelLifecycleMixin {
  bool _isInitialized = false;

  @override
  void initializeViewModels() {
    _initializeHistory();
  }

  Future<void> _initializeHistory() async {
    final viewModel = context.resultsViewModel;
    await viewModel.loadHistory();
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
        'Assessment History',
        style: TextStyle(
          fontSize: AppConstants.subheadingTextSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      actions: [
        Consumer<ResultsViewModel>(
          builder: (context, viewModel, child) {
            if (!_isInitialized || !viewModel.hasHistory) {
              return const SizedBox.shrink();
            }

            return PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 8),
                      Text('Refresh'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'statistics',
                  child: Row(
                    children: [
                      Icon(Icons.analytics, size: 20),
                      SizedBox(width: 8),
                      Text('Statistics'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ResultsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _buildLoadingState(context);
        }

        if (viewModel.error != null) {
          return _buildErrorState(context, viewModel.error!);
        }

        if (!viewModel.hasHistory) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          child: Column(
            children: [
              // History summary
              _buildHistorySummary(context, viewModel),

              // Results list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: viewModel.history.length,
                  itemBuilder: (context, index) {
                    final result = viewModel.history[index];
                    return _buildHistoryItem(context, result, viewModel);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistorySummary(
    BuildContext context,
    ResultsViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final stats = viewModel.getHistoryStatistics();

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Total',
            '${stats['totalAssessments']}',
            Icons.quiz,
          ),
          _buildStatItem(
            context,
            'Most Common',
            (stats['mostCommonPrakriti'] as PrakritiType?)?.displayName ??
                'N/A',
            Icons.trending_up,
          ),
          _buildStatItem(
            context,
            'This Month',
            '${_getThisMonthCount(viewModel)}',
            Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppConstants.subheadingTextSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.captionTextSize,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    AssessmentResult result,
    ResultsViewModel viewModel,
  ) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(result.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
        margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: theme.colorScheme.onError, size: 24),
            const SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: theme.colorScheme.onError,
                fontSize: AppConstants.captionTextSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => _confirmDelete(context, result),
      onDismissed: (direction) => _deleteResult(context, result, viewModel),
      child: Card(
        elevation: AppConstants.cardElevation,
        margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
        child: InkWell(
          onTap: () => _viewResult(context, result),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                // Dosha avatar(s)
                if (result.dominantDoshas.length == 1)
                  DoshaAvatar(
                    doshaType: result.dominantDoshas.first,
                    size: DoshaAvatarSize.medium,
                  )
                else
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      children: result.dominantDoshas.take(2).map((dosha) {
                        final index = result.dominantDoshas.indexOf(dosha);
                        return Positioned(
                          left: index * 12.0,
                          child: DoshaAvatar(
                            doshaType: dosha,
                            size: DoshaAvatarSize.small,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(width: AppConstants.defaultPadding),

                // Result details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.prakritiType.displayName,
                        style: TextStyle(
                          fontSize: AppConstants.subheadingTextSize,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(result.timestamp),
                        style: TextStyle(
                          fontSize: AppConstants.bodyTextSize,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Dosha percentages
                      Row(
                        children: result.doshaPercentages.entries.map((entry) {
                          final color = AppTheme.getDoshaColor(entry.key);
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: AppConstants.smallPadding,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${entry.key.displayName}: ${entry.value.round()}%',
                                style: TextStyle(
                                  fontSize: AppConstants.captionTextSize,
                                  fontWeight: FontWeight.w500,
                                  color: color,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
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
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Loading assessment history...',
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
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Failed to load history',
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
              onPressed: () => _initializeHistory(),
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
              Icons.history,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'No Assessment History',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Complete your first assessment to see your results here.',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Take Assessment'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  int _getThisMonthCount(ResultsViewModel viewModel) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    return viewModel.history.where((result) {
      return result.timestamp.isAfter(thisMonth) &&
          result.timestamp.isBefore(nextMonth);
    }).length;
  }

  Future<bool?> _confirmDelete(BuildContext context, AssessmentResult result) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assessment?'),
        content: Text(
          'Are you sure you want to delete the ${result.prakritiType.displayName} '
          'assessment from ${_formatDate(result.timestamp)}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteResult(
    BuildContext context,
    AssessmentResult result,
    ResultsViewModel viewModel,
  ) {
    viewModel.deleteResult(result.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.prakritiType.displayName} assessment deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Note: In a real app, you'd implement undo functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Undo is not implemented yet')),
            );
          },
        ),
      ),
    );
  }

  void _viewResult(BuildContext context, AssessmentResult result) {
    NavigationService.navigateToResults(result);
  }

  void _handleMenuAction(BuildContext context, String action) {
    final viewModel = context.resultsViewModel;
    switch (action) {
      case 'refresh':
        viewModel.refresh();
        break;
      case 'statistics':
        _showStatistics(context);
        break;
    }
  }

  void _showStatistics(BuildContext context) {
    final stats = context.resultsViewModel.getHistoryStatistics();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Statistics'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Assessments: ${stats['totalAssessments']}'),
              const SizedBox(height: 8),
              Text(
                'Most Common Prakriti: ${(stats['mostCommonPrakriti'] as PrakritiType?)?.displayName ?? 'N/A'}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Average Dosha Scores:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...(stats['averageDoshaScores'] as Map<DoshaType, double>).entries
                  .map(
                    (entry) => Text(
                      '${entry.key.displayName}: ${entry.value.toStringAsFixed(1)}',
                    ),
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
