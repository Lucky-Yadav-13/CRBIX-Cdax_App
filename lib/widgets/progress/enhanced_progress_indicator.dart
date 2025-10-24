import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enhanced progress indicator with smooth animations and professional styling
class EnhancedProgressIndicator extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final bool showPercentage;
  final bool showLabel;
  final Duration animationDuration;
  final Curve animationCurve;
  final BorderRadius? borderRadius;

  const EnhancedProgressIndicator({
    super.key,
    required this.progress,
    this.label,
    this.progressColor,
    this.backgroundColor,
    this.height = 8.0,
    this.showPercentage = true,
    this.showLabel = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeOutCubic,
    this.borderRadius,
  });

  @override
  State<EnhancedProgressIndicator> createState() => _EnhancedProgressIndicatorState();
}

class _EnhancedProgressIndicatorState extends State<EnhancedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textAnimation;
  
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: widget.animationCurve),
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(EnhancedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;
    final backgroundColor = widget.backgroundColor ?? 
        theme.colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label and percentage row
              if (widget.showLabel || widget.showPercentage) ...[
                FadeTransition(
                  opacity: _textAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.showLabel && widget.label != null)
                        Text(
                          widget.label!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (widget.showPercentage)
                        TweenAnimationBuilder<double>(
                          duration: widget.animationDuration,
                          tween: Tween(begin: 0, end: widget.progress * 100),
                          builder: (context, value, child) {
                            return Text(
                              '${value.round()}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: progressColor,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Progress bar
              Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(widget.height / 2),
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(widget.height / 2),
                  child: Stack(
                    children: [
                      // Animated progress fill
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              progressColor,
                              progressColor.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(),
                        ),
                      ),
                      
                      // Shimmer effect for active progress
                      if (_progressAnimation.value > 0) ...[
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Circular progress indicator with enhanced animations
class EnhancedCircularProgress extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const EnhancedCircularProgress({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<EnhancedCircularProgress> createState() => _EnhancedCircularProgressState();
}

class _EnhancedCircularProgressState extends State<EnhancedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(EnhancedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;
    final backgroundColor = widget.backgroundColor ?? 
        theme.colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background circle
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: widget.strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                ),
                
                // Progress circle with gradient
                CustomPaint(
                  painter: _GradientCircularProgressPainter(
                    progress: _progressAnimation.value,
                    strokeWidth: widget.strokeWidth,
                    progressColor: progressColor,
                  ),
                ),
                
                // Center text
                if (widget.showPercentage)
                  Center(
                    child: TweenAnimationBuilder<double>(
                      duration: widget.animationDuration,
                      tween: Tween(begin: 0, end: widget.progress * 100),
                      builder: (context, value, child) {
                        return Text(
                          '${value.round()}%',
                          style: widget.textStyle ?? theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: progressColor,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Create gradient
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 2 * math.pi - math.pi / 2,
      colors: [
        progressColor,
        progressColor.withValues(alpha: 0.7),
        progressColor,
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}