import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Widget that provides smooth theme transition animations
/// Note: MaterialApp already handles theme transitions natively,
/// so this widget simply passes through the child
class ThemeTransition extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  final Duration duration;

  const ThemeTransition({
    super.key,
    required this.child,
    required this.isDarkMode,
    this.duration = AppConstants.mediumAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    // MaterialApp already handles theme transitions smoothly
    return child;
  }
}

/// Theme toggle button with smooth animations
class AnimatedThemeToggle extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const AnimatedThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Set initial state
    if (widget.isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      if (widget.isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
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
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () {
        widget.onToggle();
        // Add a small bounce animation on tap
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 3.14159, // 180 degrees
              child: Container(
                width: widget.size + 16,
                height: widget.size + 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    inactiveColor.withValues(alpha: 0.1),
                    activeColor.withValues(alpha: 0.1),
                    _rotationAnimation.value,
                  ),
                ),
                child: Icon(
                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: widget.size,
                  color: Color.lerp(
                    inactiveColor,
                    activeColor,
                    _rotationAnimation.value,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Smooth theme switch widget with slide animation
class ThemeSwitch extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;

  const ThemeSwitch({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
    this.width = 60.0,
    this.height = 30.0,
  });

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.shortAnimationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Set initial state
    if (widget.isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ThemeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      if (widget.isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    _colorAnimation = ColorTween(
      begin: theme.colorScheme.outline,
      end: theme.colorScheme.primary,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.isDarkMode),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2),
              color: _colorAnimation.value,
            ),
            child: Stack(
              children: [
                // Background icons
                Positioned(
                  left: 6,
                  top: 6,
                  child: Icon(
                    Icons.light_mode,
                    size: widget.height - 12,
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: 1.0 - _slideAnimation.value,
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Icon(
                    Icons.dark_mode,
                    size: widget.height - 12,
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: _slideAnimation.value,
                    ),
                  ),
                ),
                
                // Sliding thumb
                AnimatedPositioned(
                  duration: AppConstants.shortAnimationDuration,
                  curve: Curves.easeInOut,
                  left: _slideAnimation.value * (widget.width - widget.height) + 2,
                  top: 2,
                  child: Container(
                    width: widget.height - 4,
                    height: widget.height - 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: (widget.height - 4) * 0.6,
                      color: _colorAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}