import 'package:flutter/material.dart';
import '../../models/recommendation.dart';
import '../../utils/constants.dart';

/// An expandable card widget that displays wellness recommendations
class RecommendationCard extends StatefulWidget {
  final Recommendation recommendation;
  final bool initiallyExpanded;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.initiallyExpanded = false,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        children: [
          // Header section (always visible)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  children: [
                    // Recommendation type icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getRecommendationColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: Icon(
                        _getRecommendationIcon(),
                        color: _getRecommendationColor(),
                        size: 24,
                      ),
                    ),
                    
                    const SizedBox(width: AppConstants.defaultPadding),
                    
                    // Title and description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recommendation.title,
                            style: TextStyle(
                              fontSize: AppConstants.subheadingTextSize,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.recommendation.type.displayName,
                            style: TextStyle(
                              fontSize: AppConstants.captionTextSize,
                              fontWeight: FontWeight.w500,
                              color: _getRecommendationColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Expand/collapse icon
                    AnimatedBuilder(
                      animation: _iconRotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _iconRotationAnimation.value * 3.14159,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expandable content section
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppConstants.defaultPadding,
                0,
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  // Description
                  if (widget.recommendation.description.isNotEmpty) ...[
                    Text(
                      widget.recommendation.description,
                      style: TextStyle(
                        fontSize: AppConstants.bodyTextSize,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                  ],
                  
                  // Suggestions list
                  if (widget.recommendation.suggestions.isNotEmpty) ...[
                    Text(
                      'Recommendations:',
                      style: TextStyle(
                        fontSize: AppConstants.bodyTextSize,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    
                    ...widget.recommendation.suggestions.map((suggestion) =>
                      _buildSuggestionItem(context, suggestion),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: AppConstants.smallPadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getRecommendationColor(),
            ),
          ),
          
          // Suggestion text
          Expanded(
            child: Text(
              suggestion,
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate color for the recommendation type
  Color _getRecommendationColor() {
    switch (widget.recommendation.type) {
      case RecommendationType.diet:
        return const Color(0xFF4CAF50); // Green for diet
      case RecommendationType.lifestyle:
        return const Color(0xFF2196F3); // Blue for lifestyle
      case RecommendationType.sleep:
        return const Color(0xFF9C27B0); // Purple for sleep
      case RecommendationType.stressManagement:
        return const Color(0xFFFF9800); // Orange for stress management
      case RecommendationType.seasonal:
        return const Color(0xFF795548); // Brown for seasonal
    }
  }

  /// Get the appropriate icon for the recommendation type
  IconData _getRecommendationIcon() {
    switch (widget.recommendation.type) {
      case RecommendationType.diet:
        return Icons.restaurant;
      case RecommendationType.lifestyle:
        return Icons.directions_walk;
      case RecommendationType.sleep:
        return Icons.bedtime;
      case RecommendationType.stressManagement:
        return Icons.self_improvement;
      case RecommendationType.seasonal:
        return Icons.wb_sunny;
    }
  }
}

/// A widget that displays a list of recommendation cards
class RecommendationsList extends StatelessWidget {
  final List<Recommendation> recommendations;
  final bool allowMultipleExpanded;

  const RecommendationsList({
    super.key,
    required this.recommendations,
    this.allowMultipleExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    if (allowMultipleExpanded) {
      // Allow multiple cards to be expanded simultaneously
      return Column(
        children: recommendations.map((recommendation) =>
          RecommendationCard(
            recommendation: recommendation,
            initiallyExpanded: false,
          ),
        ).toList(),
      );
    } else {
      // Use ExpansionPanelList for single expansion behavior
      return _SingleExpansionRecommendationsList(
        recommendations: recommendations,
      );
    }
  }
}

/// Internal widget for single expansion behavior
class _SingleExpansionRecommendationsList extends StatefulWidget {
  final List<Recommendation> recommendations;

  const _SingleExpansionRecommendationsList({
    required this.recommendations,
  });

  @override
  State<_SingleExpansionRecommendationsList> createState() =>
      _SingleExpansionRecommendationsListState();
}

class _SingleExpansionRecommendationsListState
    extends State<_SingleExpansionRecommendationsList> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.recommendations.asMap().entries.map((entry) {
        final index = entry.key;
        final recommendation = entry.value;
        
        return RecommendationCard(
          recommendation: recommendation,
          initiallyExpanded: _expandedIndex == index,
        );
      }).toList(),
    );
  }
}