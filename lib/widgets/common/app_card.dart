import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';

/// Standardized card widget for CDAX App
/// Provides consistent card styling throughout the app
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseElevation = widget.elevation ?? AppConstants.cardElevation;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_elevationAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              if (widget.onTap != null) {
                _hoverController.forward();
              }
            },
            onExit: (_) {
              if (widget.onTap != null) {
                _hoverController.reverse();
              }
            },
            child: _buildCard(baseElevation * _elevationAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildCard(double currentElevation) {
    Widget card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
        border: widget.border,
        boxShadow: currentElevation > 0
            ? [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.1),
                  blurRadius: currentElevation * 2,
                  offset: Offset(0, currentElevation),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}
