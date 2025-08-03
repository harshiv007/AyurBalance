# Technology Stack

## Framework & Platform
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language (SDK ^3.8.1)
- **Target Platforms**: Android, iOS, Web, Windows, macOS, Linux

## Dependencies
- **cupertino_icons**: iOS-style icons
- **shared_preferences**: Local storage for offline functionality and user preferences
- **provider**: State management using ChangeNotifier pattern
- **flutter_lints**: Code quality and style enforcement

## Architecture Pattern
- **MVVM (Model-View-ViewModel)**: Clean separation of concerns
- **Provider**: State management with ChangeNotifier
- **Local Storage**: SharedPreferences for offline data persistence

## Common Commands

### Development
```bash
# Get dependencies
fvm flutter pub get

# Run the app (debug mode)
fvm flutter run

# Run on specific device
fvm flutter run -d <device_id>

# Hot reload during development
# Press 'r' in terminal or save files in IDE
```

### Building
```bash
# Build APK for Android
fvm flutter build apk

# Build app bundle for Android
fvm flutter build appbundle

# Build for iOS (requires macOS)
fvm flutter build ios

# Build for web
fvm flutter build web
```

### Testing
```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run specific test file
fvm flutter test test/models/question_test.dart
```

### Code Quality
```bash
# Analyze code for issues
fvm flutter analyze

# Format code
fvm dart format .

# Check for outdated dependencies
fvm flutter pub outdated
```

## Development Environment
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA with Flutter plugin
- **Flutter Doctor**: Run `flutter doctor` to verify setup
- **Device Testing**: Use physical devices or emulators for testing