import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';

/// Standardized card widget for CDAX App
/// Provides consistent card styling throughout the app
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
  });

  /// Factory constructor for standard card
  const AppCard.standard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
  }) : padding = const EdgeInsets.all(AppSpacing.lg),
       margin = const EdgeInsets.all(AppSpacing.sm),
       elevation = AppConstants.cardElevation,
       borderRadius = null,
       border = null;

  /// Factory constructor for outlined card
  const AppCard.outlined({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
  }) : padding = const EdgeInsets.all(AppSpacing.lg),
       margin = const EdgeInsets.all(AppSpacing.sm),
       elevation = 0,
       borderRadius = null,
       border = const Border.fromBorderSide(
         BorderSide(color: AppColors.outline, width: 1),
       );

  /// Factory constructor for compact card
  const AppCard.compact({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
  }) : padding = const EdgeInsets.all(AppSpacing.md),
       margin = const EdgeInsets.all(AppSpacing.xs),
       elevation = 1,
       borderRadius = null,
       border = null;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
        border: border,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.1),
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation!),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}