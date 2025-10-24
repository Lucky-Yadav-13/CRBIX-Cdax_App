import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Standardized loading widget for CDAX App
/// Provides consistent loading states throughout the app
class AppLoadingWidget extends StatefulWidget {
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
  State<AppLoadingWidget> createState() => _AppLoadingWidgetState();
}

class _AppLoadingWidgetState extends State<AppLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildByType(),
    );
  }

  Widget _buildByType() {
    switch (widget.type) {
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
      color: AppColors.surface.withValues(alpha: 0.8),
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCustomSpinner(
                    size: widget.size ?? 40,
                    color: widget.color ?? AppColors.primary,
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      widget.message!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInlineLoading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCustomSpinner(
          size: widget.size ?? 20,
          color: widget.color ?? AppColors.primary,
        ),
        if (widget.message != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            widget.message!,
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
          _buildCustomSpinner(
            size: widget.size ?? 32,
            color: widget.color ?? AppColors.primary,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.message!,
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
    return _buildCustomSpinner(
      size: widget.size ?? 16,
      color: widget.color ?? AppColors.onPrimary,
    );
  }

  Widget _buildCustomSpinner({required double size, required Color color}) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: SizedBox(
            height: size,
            width: size,
            child: CustomPaint(
              painter: _SpinnerPainter(
                color: color,
                strokeWidth: size * 0.08,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SpinnerPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw the spinner arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.14159 * 1.5, // 270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Loading widget type variants
enum AppLoadingType {
  fullScreen,
  inline,
  spinner,
  button,
}
