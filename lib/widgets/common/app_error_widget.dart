import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';

/// Standardized error widget for CDAX App
/// Provides consistent error display throughout the app
class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final IconData? icon;
  final AppErrorType type;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryButtonText,
    this.icon,
    this.type = AppErrorType.general,
  });

  /// Factory constructor for network error
  const AppErrorWidget.network({
    super.key,
    this.message = 'Unable to connect to the network. Please check your internet connection.',
    this.onRetry,
  }) : title = 'Network Error',
       retryButtonText = 'Retry',
       icon = Icons.wifi_off,
       type = AppErrorType.network;

  /// Factory constructor for server error
  const AppErrorWidget.server({
    super.key,
    this.message = 'Something went wrong on our end. Please try again later.',
    this.onRetry,
  }) : title = 'Server Error',
       retryButtonText = 'Try Again',
       icon = Icons.error_outline,
       type = AppErrorType.server;

  /// Factory constructor for not found error
  const AppErrorWidget.notFound({
    super.key,
    this.message = 'The requested content could not be found.',
  }) : title = 'Not Found',
       onRetry = null,
       retryButtonText = null,
       icon = Icons.search_off,
       type = AppErrorType.notFound;

  /// Factory constructor for inline error
  const AppErrorWidget.inline({
    super.key,
    required this.message,
    this.onRetry,
  }) : title = null,
       retryButtonText = 'Retry',
       icon = Icons.warning_amber,
       type = AppErrorType.inline;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppErrorType.general:
      case AppErrorType.network:
      case AppErrorType.server:
      case AppErrorType.notFound:
        return _buildFullError();
      case AppErrorType.inline:
        return _buildInlineError();
    }
  }

  Widget _buildFullError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInlineError() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.warning_amber,
            size: 20,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(retryButtonText ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error widget type variants
enum AppErrorType {
  general,
  network,
  server,
  notFound,
  inline,
}