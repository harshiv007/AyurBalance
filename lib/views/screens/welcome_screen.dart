import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../models/dosha.dart';
import '../widgets/dosha_avatar.dart';
import 'assessment_screen.dart';

/// Welcome screen that introduces the app and Ayurvedic prakriti concept
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header with theme toggle
              _buildHeader(context),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // App logo/icon
              _buildAppIcon(context),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Welcome title
              _buildWelcomeTitle(context),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // App description
              _buildAppDescription(context),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Dosha overview
              _buildDoshaOverview(context),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Prakriti explanation
              _buildPrakritiExplanation(context),
              
              SizedBox(height: AppConstants.largePadding + 8),
              
              // Start assessment button
              _buildStartButton(context),
              
              const SizedBox(height: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App name
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: AppConstants.bodyTextSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        
        // Theme toggle button
        Consumer<ThemeViewModel>(
          builder: (context, themeViewModel, child) {
            return IconButton(
              onPressed: () => themeViewModel.toggleTheme(),
              icon: Icon(
                themeViewModel.isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              tooltip: themeViewModel.isDarkMode 
                  ? 'Switch to Light Mode' 
                  : 'Switch to Dark Mode',
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppIcon(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.spa,
        size: 60,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildWelcomeTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          'Welcome to Your',
          style: TextStyle(
            fontSize: AppConstants.headingTextSize,
            fontWeight: FontWeight.w300,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Ayurvedic Journey',
          style: TextStyle(
            fontSize: AppConstants.headingTextSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppDescription(BuildContext context) {
    final theme = Theme.of(context);
    
    return Text(
      'Discover your unique Ayurvedic constitution (Prakriti) through a comprehensive assessment. '
      'Understanding your dosha balance helps you make informed choices about diet, lifestyle, '
      'and wellness practices tailored specifically for you.',
      style: TextStyle(
        fontSize: AppConstants.bodyTextSize,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDoshaOverview(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          'The Three Doshas',
          style: TextStyle(
            fontSize: AppConstants.subheadingTextSize,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: AppConstants.defaultPadding),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDoshaPreview(context, 'Vata', 'Air & Space', AppTheme.vataColor),
            _buildDoshaPreview(context, 'Pitta', 'Fire & Water', AppTheme.pittaColor),
            _buildDoshaPreview(context, 'Kapha', 'Earth & Water', AppTheme.kaphaColor),
          ],
        ),
      ],
    );
  }

  Widget _buildDoshaPreview(BuildContext context, String name, String elements, Color color) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          color: color.withValues(alpha: 0.1),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            DoshaAvatar(
              doshaType: name.toLowerCase() == 'vata' 
                  ? DoshaType.vata 
                  : name.toLowerCase() == 'pitta' 
                      ? DoshaType.pitta 
                      : DoshaType.kapha,
              size: DoshaAvatarSize.small,
            ),
            
            const SizedBox(height: AppConstants.smallPadding),
            
            Text(
              name,
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            
            const SizedBox(height: 2),
            
            Text(
              elements,
              style: TextStyle(
                fontSize: AppConstants.captionTextSize,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrakritiExplanation(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        color: theme.colorScheme.surfaceContainerLow,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                'What is Prakriti?',
                style: TextStyle(
                  fontSize: AppConstants.subheadingTextSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.smallPadding),
          
          Text(
            'Prakriti is your unique Ayurvedic constitution determined at birth. It represents the '
            'natural balance of the three doshas (Vata, Pitta, Kapha) in your body and mind. '
            'Understanding your prakriti helps you:\n\n'
            '• Choose foods that support your constitution\n'
            '• Adopt lifestyle practices that promote balance\n'
            '• Recognize early signs of imbalance\n'
            '• Make wellness choices aligned with your nature',
            style: TextStyle(
              fontSize: AppConstants.bodyTextSize,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _navigateToAssessment(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 4,
          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Assessment',
              style: TextStyle(
                fontSize: AppConstants.subheadingTextSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToAssessment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AssessmentScreen(),
      ),
    );
  }
}