# Project Structure

## Root Directory Organization
```
yakshasur/
├── lib/                    # Main application code
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration  
├── web/                   # Web-specific configuration
├── windows/               # Windows-specific configuration
├── macos/                 # macOS-specific configuration
├── linux/                 # Linux-specific configuration
├── test/                  # Unit and widget tests
├── .kiro/                 # Kiro IDE configuration and specs
├── pubspec.yaml           # Dependencies and project metadata
└── README.md              # Project documentation
```

## lib/ Directory Structure (MVVM Pattern)
```
lib/
├── main.dart              # App entry point
├── models/                # Data models and business logic
│   ├── question.dart      # Question and QuestionOption models
│   ├── dosha.dart         # Dosha and Prakriti type definitions
│   ├── assessment_result.dart # Assessment results model
│   └── recommendation.dart # Wellness recommendations model
├── viewmodels/            # State management (ChangeNotifier)
│   ├── assessment_viewmodel.dart # Assessment flow state
│   ├── results_viewmodel.dart    # Results display state
│   └── theme_viewmodel.dart      # Theme switching state
├── views/                 # UI components
│   ├── screens/           # Full-screen widgets
│   │   ├── welcome_screen.dart
│   │   ├── assessment_screen.dart
│   │   ├── results_screen.dart
│   │   └── history_screen.dart
│   └── widgets/           # Reusable UI components
│       ├── question_card.dart
│       ├── progress_indicator.dart
│       ├── dosha_avatar.dart
│       └── recommendation_card.dart
├── services/              # Business logic and data access
│   ├── assessment_service.dart   # Question loading and result calculation
│   ├── storage_service.dart      # Local data persistence
│   └── dosha_calculator.dart     # Dosha scoring algorithms
└── utils/                 # Shared utilities and constants
    ├── constants.dart     # App-wide constants and enums
    ├── theme.dart         # Theme configuration
    └── extensions.dart    # Dart extensions
```

## Naming Conventions

### Files and Directories
- Use `snake_case` for file and directory names
- Suffix screen files with `_screen.dart`
- Suffix widget files with `_widget.dart` or descriptive names
- Suffix viewmodel files with `_viewmodel.dart`
- Suffix service files with `_service.dart`

### Classes and Enums
- Use `PascalCase` for class names
- Use `PascalCase` for enum names
- Use `camelCase` for enum values

### Variables and Methods
- Use `camelCase` for variables, methods, and parameters
- Use `_privateVariable` for private members
- Use descriptive names that clearly indicate purpose

## Code Organization Principles

### Models
- Pure data classes with JSON serialization
- Include equality operators and hashCode
- Use const constructors where possible
- Keep business logic minimal

### ViewModels
- Extend ChangeNotifier for state management
- Use private fields with public getters
- Handle loading states and error handling
- Keep UI logic separate from business logic

### Views
- Separate screens from reusable widgets
- Use StatelessWidget where possible
- Extract complex widgets into separate files
- Follow Material Design guidelines

### Services
- Handle data access and business logic
- Return Future for async operations
- Use dependency injection patterns
- Keep services stateless

## Import Organization
```dart
// 1. Dart core libraries
import 'dart:async';
import 'dart:convert';

// 2. Flutter framework
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 4. Local imports (relative paths)
import '../models/question.dart';
import '../services/assessment_service.dart';
import '../utils/constants.dart';
```

## Asset Organization
```
assets/
├── icons/                 # App and dosha icons
│   ├── vata.png
│   ├── pitta.png
│   └── kapha.png
├── images/                # Illustrations and backgrounds
└── data/                  # JSON data files
    └── questions.json     # Assessment questions data
```