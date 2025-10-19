import 'package:flutter/material.dart';

/// Centralized color palette for CDAX App
/// Extends the existing theme colors with semantic colors
class AppColors {
  AppColors._();

  // Primary colors (already defined in AppTheme)
  static const Color primary = Color(0xFF1E3A8A); // Dark blue
  static const Color secondary = Color(0xFF87CEEB); // Light blue
  
  // Semantic colors for status and feedback
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange  
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Surface colors
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF8F9FA); // Light gray
  static const Color outline = Color(0xFFE5E7EB); // Border gray
  
  // Text colors
  static const Color onSurface = Color(0xFF111827); // Dark text
  static const Color onSurfaceVariant = Color(0xFF6B7280); // Light text
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
}