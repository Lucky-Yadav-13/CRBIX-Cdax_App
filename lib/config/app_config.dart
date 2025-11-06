/// Application Configuration
/// Centralized configuration for API endpoints, app settings, and environment variables
class AppConfig {
  static const String appName = 'CDAX Learning Platform';
  static const String version = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'YOUR_SPRING_BOOT_API_URL'; // Update this with your actual API URL
  static const String apiVersion = '/api/v1';
  static const String fullApiUrl = '$baseUrl$apiVersion';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String coursesEndpoint = '/courses';
  static const String assessmentsEndpoint = '/assessments';
  static const String jobsEndpoint = '/jobs';
  static const String usersEndpoint = '/users';
  static const String paymentsEndpoint = '/payments';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  
  // Environment
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableDebugLogs = true;
}