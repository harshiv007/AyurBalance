# Implementation Plan

- [x] 1. Set up project dependencies and basic structure





  - Add required dependencies to pubspec.yaml (shared_preferences for local storage)
  - Create the folder structure as defined in the design (models, viewmodels, views, services, utils)
  - Set up basic app theme and constants
  - _Requirements: 8.1, 8.2, 10.1_

- [x] 2. Implement core data models





  - [x] 2.1 Create Question and QuestionOption models


    - Define Question class with id, text, category, and options
    - Define QuestionOption class with text, primaryDosha, and weight
    - Create QuestionCategory enum
    - Add JSON serialization methods
    - _Requirements: 1.2, 2.1, 3.1, 4.1, 5.1_

  - [x] 2.2 Create Dosha and PrakritiType models


    - Define DoshaType enum (vata, pitta, kapha)
    - Create Dosha class with type, name, description, color, and characteristics
    - Define PrakritiType enum for all constitution types
    - _Requirements: 6.2, 6.3_

  - [x] 2.3 Create AssessmentResult model


    - Define AssessmentResult class with id, timestamp, scores, prakriti type, traits, and recommendations
    - Create Recommendation model with type, title, description, and suggestions
    - Add JSON serialization for local storage
    - _Requirements: 6.1, 6.4, 7.1, 7.2, 7.3, 7.4, 7.5, 9.1, 9.3_

- [x] 3. Create assessment service and dosha calculation logic




  - [x] 3.1 Implement DoshaCalculator service


    - Create calculateDoshaScores method to tally answers by dosha type
    - Implement determinePrakritiType method with single/dual/tridoshic logic
    - Add extractSelectedTraits method to map answers to trait categories
    - Write unit tests for calculation accuracy
    - _Requirements: 6.1, 6.2_


  - [x] 3.2 Create AssessmentService with question data

    - Define hardcoded question data covering all four categories (Physical, Mental/Emotional, Habits, Environmental)
    - Implement getQuestions method to return structured question list
    - Create generateRecommendations method based on prakriti type
    - Add calculateResult method that uses DoshaCalculator
    - _Requirements: 1.2, 2.1, 2.2, 3.1, 3.2, 4.1, 4.2, 5.1, 5.2, 7.1, 7.2, 7.3, 7.4, 7.5_

- [ ] 4. Implement local storage service




  - [x] 4.1 Create StorageService using SharedPreferences


    - Implement saveAssessmentResult method with JSON serialization
    - Create getAssessmentHistory method to retrieve all saved results
    - Add getAssessmentResult method for single result retrieval
    - Implement deleteAssessmentResult method
    - _Requirements: 9.1, 9.2, 9.3, 10.1, 10.2_

  - [x] 4.2 Add theme preference storage


    - Implement saveThemePreference and getThemePreference methods
    - Handle storage errors gracefully with try-catch blocks
    - _Requirements: 8.2_

- [x] 5. Create ViewModels for state management





  - [x] 5.1 Implement AssessmentViewModel


    - Extend ChangeNotifier for state management
    - Add properties for questions, current index, answers, loading state
    - Implement loadQuestions, answerQuestion, nextQuestion, previousQuestion methods
    - Create completeAssessment method that calculates and saves results
    - Add progress calculation and navigation state getters
    - _Requirements: 1.1, 1.3, 1.4, 1.5, 2.5, 3.3, 4.3, 5.3_

  - [x] 5.2 Implement ResultsViewModel


    - Extend ChangeNotifier for results state management
    - Add properties for current result, history, and loading state
    - Implement loadResult, loadHistory, deleteResult methods
    - Create setCurrentResult method for displaying specific results
    - _Requirements: 6.3, 6.4, 6.5, 9.2, 9.3_

  - [x] 5.3 Create ThemeViewModel


    - Extend ChangeNotifier for theme state management
    - Implement loadThemePreference and toggleTheme methods
    - Add isDarkMode getter and state persistence
    - _Requirements: 8.2_

- [x] 6. Build core UI widgets and components





  - [x] 6.1 Create QuestionCard widget


    - Build StatelessWidget for displaying individual questions
    - Add radio button or selection UI for question options
    - Implement onAnswerSelected callback
    - Style with wellness-focused design and proper spacing
    - _Requirements: 1.2, 8.1, 8.3_

  - [x] 6.2 Create ProgressIndicator widget


    - Build custom progress bar showing assessment completion
    - Add smooth animations for progress updates
    - Display current question number and total questions
    - _Requirements: 1.3, 8.4_



  - [x] 6.3 Create DoshaAvatar widget
    - Design visual representations for each dosha type
    - Add color-coded avatars/icons for Vata, Pitta, Kapha
    - Implement different sizes for various use cases


    - _Requirements: 6.5, 8.3_

  - [x] 6.4 Create RecommendationCard widget
    - Build expandable cards for different recommendation types
    - Add icons and styling for diet, lifestyle, sleep, stress management categories
    - Implement smooth expand/collapse animations
    - _Requirements: 7.5, 8.1_

- [ ] 7. Implement main application screens





  - [x] 7.1 Create WelcomeScreen


    - Build welcome UI with app introduction and dosha overview
    - Add "Start Assessment" button with navigation to assessment
    - Include brief explanation of Ayurvedic prakriti concept
    - Implement theme toggle functionality
    - _Requirements: 1.1, 8.1, 8.2_



  - [x] 7.2 Create AssessmentScreen

    - Build main assessment UI using AssessmentViewModel
    - Integrate QuestionCard and ProgressIndicator widgets
    - Add navigation buttons (Previous/Next) with proper state management
    - Implement question flow logic and answer persistence
    - Handle assessment completion and navigation to results


    - _Requirements: 1.2, 1.3, 1.4, 1.5, 8.4_

  - [x] 7.3 Create ResultsScreen

    - Build results display using ResultsViewModel
    - Show prakriti type with DoshaAvatar and description
    - Display dosha score breakdown with visual charts or bars


    - Integrate RecommendationCard widgets for personalized advice
    - Add "Save Results" and "Retake Assessment" buttons
    - _Requirements: 6.1, 6.3, 6.4, 6.5, 7.5, 8.5_

  - [x] 7.4 Create HistoryScreen

    - Build assessment history list using ResultsViewModel
    - Display saved results with timestamps and prakriti types
    - Add tap-to-view functionality for detailed results
    - Implement swipe-to-delete for result management
    - _Requirements: 9.2, 9.3_

- [ ] 8. Set up navigation and app structure
  - [ ] 8.1 Configure app routing and navigation
    - Set up named routes for all screens
    - Implement navigation flow: Welcome → Assessment → Results → History
    - Add bottom navigation or drawer for screen switching
    - Handle back button behavior appropriately
    - _Requirements: 1.1, 1.5_

  - [ ] 8.2 Integrate ViewModels with dependency injection
    - Set up Provider or similar for ViewModel injection
    - Configure ChangeNotifierProvider for each ViewModel
    - Ensure proper ViewModel lifecycle management
    - _Requirements: All ViewModels_

- [ ] 9. Implement app theming and styling
  - [ ] 9.1 Create comprehensive app theme
    - Define light and dark theme color schemes with wellness-focused colors
    - Set up typography scales and text styles
    - Create custom button styles and component themes
    - _Requirements: 8.1, 8.2_

  - [ ] 9.2 Add theme switching functionality
    - Integrate ThemeViewModel with MaterialApp
    - Implement smooth theme transition animations
    - Persist theme preference using StorageService
    - _Requirements: 8.2_

- [ ] 10. Add error handling and user feedback
  - [ ] 10.1 Implement comprehensive error handling
    - Add try-catch blocks in all async operations
    - Create user-friendly error messages for storage failures
    - Handle edge cases in assessment flow (incomplete answers, navigation errors)
    - _Requirements: All error scenarios_

  - [ ] 10.2 Add loading states and user feedback
    - Implement loading indicators for async operations
    - Add success/error snackbars for user actions
    - Create smooth transitions between screens
    - _Requirements: 1.3, 8.4_

- [ ] 11. Write comprehensive tests
  - [ ] 11.1 Create unit tests for models and services
    - Test DoshaCalculator scoring logic with various answer combinations
    - Test AssessmentService question loading and result generation
    - Test StorageService CRUD operations with mock data
    - Verify JSON serialization/deserialization for all models
    - _Requirements: All calculation and storage logic_

  - [ ] 11.2 Create widget tests for UI components
    - Test QuestionCard interaction and answer selection
    - Test ProgressIndicator accuracy and animations
    - Test navigation flow between screens
    - Test theme switching functionality
    - _Requirements: All UI components and navigation_

  - [ ] 11.3 Write integration tests for complete user flows
    - Test complete assessment journey from start to results
    - Test result saving and history retrieval
    - Test app restart with persisted data
    - _Requirements: Complete user journey_

- [ ] 12. Final polish and optimization
  - [ ] 12.1 Optimize app performance
    - Implement efficient list rendering for question and history screens
    - Add image optimization and caching for dosha avatars
    - Optimize JSON parsing and storage operations
    - _Requirements: Performance considerations_

  - [ ] 12.2 Add accessibility features
    - Implement semantic labels for screen readers
    - Add proper focus management and keyboard navigation
    - Ensure color contrast meets accessibility standards
    - Test with accessibility tools and screen readers
    - _Requirements: 8.1, accessibility considerations_

  - [ ] 12.3 Final testing and bug fixes
    - Perform end-to-end testing on multiple devices
    - Fix any remaining UI/UX issues
    - Optimize for different screen sizes and orientations
    - Validate all requirements are met
    - _Requirements: All requirements validation_