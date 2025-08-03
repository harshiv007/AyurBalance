import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

/// A card widget that displays a question with selectable options
class QuestionCard extends StatelessWidget {
  final Question question;
  final String? selectedOptionId;
  final ValueChanged<String> onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedOptionId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question category badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Text(
                question.category.displayName,
                style: TextStyle(
                  fontSize: AppConstants.captionTextSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Question text
            Text(
              question.text,
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Answer options
            ...question.options.map((option) => _buildOptionTile(
              context,
              option,
              selectedOptionId == option.id,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, QuestionOption option, bool isSelected) {
    final theme = Theme.of(context);
    final doshaColor = AppTheme.getDoshaColor(option.primaryDosha);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onAnswerSelected(option.id),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: AnimatedContainer(
            duration: AppConstants.shortAnimationDuration,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: isSelected 
                    ? doshaColor 
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2.0 : 1.0,
              ),
              color: isSelected 
                  ? doshaColor.withValues(alpha: 0.1) 
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                // Radio button indicator
                AnimatedContainer(
                  duration: AppConstants.shortAnimationDuration,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? doshaColor : theme.colorScheme.outline,
                      width: 2.0,
                    ),
                    color: isSelected ? doshaColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
                
                const SizedBox(width: AppConstants.defaultPadding),
                
                // Option text
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontSize: AppConstants.bodyTextSize,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected 
                          ? doshaColor 
                          : theme.colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                ),
                
                // Dosha indicator dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: doshaColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}