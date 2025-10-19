/// App-wide constants for CDAX App
/// Contains all static values used throughout the application
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'CDAX';
  static const String appVersion = '1.0.0';
  
  // UI constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double iconSize = 24.0;
  static const double avatarRadius = 28.0;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Network timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Assessment constants
  static const int defaultQuestionTime = 60; // seconds
  static const int maxRetryAttempts = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Local storage keys (for future use)
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String appSettingsKey = 'app_settings';
}