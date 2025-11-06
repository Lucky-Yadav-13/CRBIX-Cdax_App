/// Application Routes Configuration
/// Centralized route definitions for the entire app
class AppRoutes {
  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  
  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  
  // Dashboard routes
  static const String dashboard = '/dashboard';
  static const String courseDetail = '/course-detail';
  static const String moduleDetail = '/module-detail';
  static const String progress = '/progress';
  static const String notifications = '/notifications';
  
  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  
  // Performance routes
  static const String performanceOverview = '/performance-overview';
  static const String performanceDetail = '/performance-detail';
  
  // Settings routes
  static const String settings = '/settings';
  static const String aboutApp = '/about-app';
  
  // Assessment routes
  static const String assessmentOverview = '/assessment-overview';
  static const String assessmentDetail = '/assessment-detail';
  static const String takeAssessment = '/take-assessment';
  
  // Course routes
  static const String coursesList = '/courses-list';
  static const String myCourses = '/my-courses';
  
  // Placement routes
  static const String placementDashboard = '/placement-dashboard';
  static const String jobDetails = '/job-details';
  
  // Get route name from path
  static String getRouteName(String path) {
    switch (path) {
      case splash:
        return 'Splash';
      case onboarding:
        return 'Onboarding';
      case login:
        return 'Login';
      case register:
        return 'Register';
      case dashboard:
        return 'Dashboard';
      case profile:
        return 'Profile';
      case settings:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }
  
  // Check if route requires authentication
  static bool requiresAuth(String route) {
    const publicRoutes = [
      splash,
      onboarding,
      login,
      register,
      forgotPassword,
      verifyOtp,
    ];
    return !publicRoutes.contains(route);
  }
}