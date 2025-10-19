import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Standardized loading widget for CDAX App
/// Provides consistent loading states throughout the app
class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final AppLoadingType type;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.size,
    this.color,
    this.type = AppLoadingType.spinner,
  });

  /// Factory constructor for full screen loading
  const AppLoadingWidget.fullScreen({
    super.key,
    this.message,
  }) : size = 40,
       color = AppColors.primary,
       type = AppLoadingType.fullScreen;

  /// Factory constructor for inline loading
  const AppLoadingWidget.inline({
    super.key,
    this.message,
  }) : size = 20,
       color = AppColors.primary,
       type = AppLoadingType.inline;

  /// Factory constructor for button loading
  const AppLoadingWidget.button({
    super.key,
  }) : message = null,
       size = 16,
       color = AppColors.onPrimary,
       type = AppLoadingType.button;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppLoadingType.fullScreen:
        return _buildFullScreenLoading();
      case AppLoadingType.inline:
        return _buildInlineLoading();
      case AppLoadingType.spinner:
        return _buildSpinner();
      case AppLoadingType.button:
        return _buildButtonLoading();
    }
  }

  Widget _buildFullScreenLoading() {
    return Container(
      color: AppColors.surface.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color: color ?? AppColors.primary,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInlineLoading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size ?? 20,
          width: size ?? 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color ?? AppColors.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSpinner() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size ?? 32,
            width: size ?? 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: color ?? AppColors.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButtonLoading() {
    return SizedBox(
      height: size ?? 16,
      width: size ?? 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? AppColors.onPrimary,
      ),
    );
  }
}

/// Loading widget type variants
enum AppLoadingType {
  fullScreen,
  inline,
  spinner,
  button,
}