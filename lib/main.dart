import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

void main() {
  runApp(
    DevicePreview(enabled: true, builder: (context) => AyurvedicPrakritiApp()),
  );
}

class AyurvedicPrakritiApp extends StatelessWidget {
  const AyurvedicPrakritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PlaceholderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Placeholder screen for initial setup
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa,
              size: 80,
              color: Color(AppConstants.vataColorValue),
            ),
            SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Ayurvedic Prakriti Assessment',
              style: TextStyle(
                fontSize: AppConstants.headingTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConstants.smallPadding),
            Text(
              'Discover your Ayurvedic constitution',
              style: TextStyle(
                fontSize: AppConstants.bodyTextSize,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: AppConstants.largePadding),
            Text(
              'Project structure and dependencies set up successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppConstants.bodyTextSize),
            ),
          ],
        ),
      ),
    );
  }
}
