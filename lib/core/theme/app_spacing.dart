/// Centralized spacing system for CDAX App
/// Provides consistent spacing throughout the app
class AppSpacing {
  AppSpacing._();

  // Spacing scale (follows 4px grid)
  static const double xs = 4.0;   // Extra small
  static const double sm = 8.0;   // Small  
  static const double md = 12.0;  // Medium
  static const double lg = 16.0;  // Large
  static const double xl = 20.0;  // Extra large
  static const double xxl = 24.0; // Double extra large
  static const double xxxl = 32.0; // Triple extra large
  
  // Common padding values
  static const double cardPadding = lg;
  static const double screenPadding = lg;
  static const double buttonPadding = md;
  
  // Common margin values
  static const double listItemSpacing = md;
  static const double sectionSpacing = xxl;
  static const double elementSpacing = sm;
}
