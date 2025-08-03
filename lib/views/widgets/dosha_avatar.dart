import 'package:flutter/material.dart';
import '../../models/dosha.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

/// Size variants for the DoshaAvatar widget
enum DoshaAvatarSize {
  small(32.0, 16.0),
  medium(64.0, 24.0),
  large(96.0, 32.0),
  extraLarge(128.0, 40.0);

  const DoshaAvatarSize(this.size, this.iconSize);
  final double size;
  final double iconSize;
}

/// A widget that displays visual representations for each dosha type
class DoshaAvatar extends StatelessWidget {
  final DoshaType doshaType;
  final DoshaAvatarSize size;
  final bool showLabel;
  final bool showGlow;

  const DoshaAvatar({
    super.key,
    required this.doshaType,
    this.size = DoshaAvatarSize.medium,
    this.showLabel = false,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doshaColor = AppTheme.getDoshaColor(doshaType);
    final doshaName = AppTheme.getDoshaName(doshaType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar container
        Container(
          width: size.size,
          height: size.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [doshaColor.withValues(alpha: 0.8), doshaColor],
              stops: const [0.0, 1.0],
            ),
            boxShadow: showGlow
                ? [
                    BoxShadow(
                      color: doshaColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Icon(
              _getDoshaIcon(doshaType),
              size: size.iconSize,
              color: Colors.white,
            ),
          ),
        ),

        // Label (if enabled)
        if (showLabel) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            doshaName,
            style: TextStyle(
              fontSize: _getLabelFontSize(),
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }

  /// Get the appropriate icon for each dosha type
  IconData _getDoshaIcon(DoshaType doshaType) {
    switch (doshaType) {
      case DoshaType.vata:
        return Icons.air; // Represents movement and air element
      case DoshaType.pitta:
        return Icons.local_fire_department; // Represents fire element
      case DoshaType.kapha:
        return Icons.water_drop; // Represents water element
    }
  }

  /// Get font size for label based on avatar size
  double _getLabelFontSize() {
    switch (size) {
      case DoshaAvatarSize.small:
        return AppConstants.captionTextSize - 2;
      case DoshaAvatarSize.medium:
        return AppConstants.captionTextSize;
      case DoshaAvatarSize.large:
        return AppConstants.bodyTextSize;
      case DoshaAvatarSize.extraLarge:
        return AppConstants.subheadingTextSize;
    }
  }
}

/// A widget that displays multiple dosha avatars for combination types
class CombinedDoshaAvatar extends StatelessWidget {
  final List<DoshaType> doshaTypes;
  final DoshaAvatarSize size;
  final bool showLabels;
  final String? combinationLabel;

  const CombinedDoshaAvatar({
    super.key,
    required this.doshaTypes,
    this.size = DoshaAvatarSize.medium,
    this.showLabels = false,
    this.combinationLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Overlapping avatars for combination types
        SizedBox(
          width: size.size + (doshaTypes.length - 1) * (size.size * 0.3),
          height: size.size,
          child: Stack(
            children: doshaTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final doshaType = entry.value;

              return Positioned(
                left: index * (size.size * 0.3),
                child: DoshaAvatar(
                  doshaType: doshaType,
                  size: size,
                  showGlow: index == 0, // Only first avatar glows
                ),
              );
            }).toList(),
          ),
        ),

        // Combination label
        if (combinationLabel != null) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            combinationLabel!,
            style: TextStyle(
              fontSize: _getLabelFontSize(),
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Individual labels (if enabled)
        if (showLabels && combinationLabel == null) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: doshaTypes.map((doshaType) {
              final isLast = doshaType == doshaTypes.last;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppTheme.getDoshaName(doshaType),
                    style: TextStyle(
                      fontSize: _getLabelFontSize(),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getDoshaColor(doshaType),
                    ),
                  ),
                  if (!isLast)
                    Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: _getLabelFontSize(),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// Get font size for label based on avatar size
  double _getLabelFontSize() {
    switch (size) {
      case DoshaAvatarSize.small:
        return AppConstants.captionTextSize - 2;
      case DoshaAvatarSize.medium:
        return AppConstants.captionTextSize;
      case DoshaAvatarSize.large:
        return AppConstants.bodyTextSize;
      case DoshaAvatarSize.extraLarge:
        return AppConstants.subheadingTextSize;
    }
  }
}

/// A widget that displays dosha avatars with score indicators
class DoshaScoreAvatar extends StatelessWidget {
  final DoshaType doshaType;
  final int score;
  final int maxScore;
  final DoshaAvatarSize size;

  const DoshaScoreAvatar({
    super.key,
    required this.doshaType,
    required this.score,
    required this.maxScore,
    this.size = DoshaAvatarSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doshaColor = AppTheme.getDoshaColor(doshaType);
    final doshaName = AppTheme.getDoshaName(doshaType);
    final percentage = maxScore > 0 ? (score / maxScore * 100).round() : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with score ring
        Stack(
          alignment: Alignment.center,
          children: [
            // Score ring
            SizedBox(
              width: size.size + 8,
              height: size.size + 8,
              child: CircularProgressIndicator(
                value: maxScore > 0 ? score / maxScore : 0,
                strokeWidth: 3,
                backgroundColor: doshaColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(doshaColor),
              ),
            ),

            // Dosha avatar
            DoshaAvatar(doshaType: doshaType, size: size),
          ],
        ),

        const SizedBox(height: AppConstants.smallPadding),

        // Dosha name
        Text(
          doshaName,
          style: TextStyle(
            fontSize: _getLabelFontSize(),
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),

        // Score and percentage
        Text(
          '$score ($percentage%)',
          style: TextStyle(
            fontSize: _getLabelFontSize() - 2,
            fontWeight: FontWeight.w500,
            color: doshaColor,
          ),
        ),
      ],
    );
  }

  /// Get font size for label based on avatar size
  double _getLabelFontSize() {
    switch (size) {
      case DoshaAvatarSize.small:
        return AppConstants.captionTextSize - 2;
      case DoshaAvatarSize.medium:
        return AppConstants.captionTextSize;
      case DoshaAvatarSize.large:
        return AppConstants.bodyTextSize;
      case DoshaAvatarSize.extraLarge:
        return AppConstants.subheadingTextSize;
    }
  }
}
