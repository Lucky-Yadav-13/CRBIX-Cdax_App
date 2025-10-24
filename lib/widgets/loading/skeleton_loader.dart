import 'package:flutter/material.dart';

/// Professional skeleton loading widget with shimmer effect
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// Skeleton for text lines
  const SkeletonLoader.text({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// Skeleton for circular elements (avatars, icons)
  const SkeletonLoader.circular({
    super.key,
    required double size,
    this.baseColor,
    this.highlightColor,
  }) : width = size,
       height = size,
       borderRadius = null;

  /// Skeleton for rectangular cards
  const SkeletonLoader.card({
    super.key,
    this.width,
    this.height = 120,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? 
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ??
                (widget.width == widget.height 
                    ? BorderRadius.circular(widget.height / 2)
                    : BorderRadius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlideGradientTransform(_animation.value),
            ),
          ),
        );
      },
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlideGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Pre-built skeleton layouts for common UI patterns
class SkeletonLayouts {
  /// Course card skeleton
  static Widget courseCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course image
          const SkeletonLoader.card(height: 120),
          const SizedBox(height: 16),
          // Course title
          const SkeletonLoader.text(width: double.infinity, height: 20),
          const SizedBox(height: 8),
          // Course description
          const SkeletonLoader.text(width: 250, height: 14),
          const SizedBox(height: 4),
          const SkeletonLoader.text(width: 180, height: 14),
          const SizedBox(height: 16),
          // Course stats
          Row(
            children: [
              const SkeletonLoader.text(width: 60, height: 12),
              const SizedBox(width: 16),
              const SkeletonLoader.text(width: 80, height: 12),
              const Spacer(),
              const SkeletonLoader.text(width: 40, height: 12),
            ],
          ),
        ],
      ),
    );
  }

  /// Assessment card skeleton
  static Widget assessmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Assessment icon
              const SkeletonLoader.circular(size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader.text(width: double.infinity, height: 18),
                    const SizedBox(height: 8),
                    const SkeletonLoader.text(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Assessment details chips
          Row(
            children: [
              const SkeletonLoader.text(width: 80, height: 24),
              const SizedBox(width: 12),
              const SkeletonLoader.text(width: 100, height: 24),
              const SizedBox(width: 12),
              const SkeletonLoader.text(width: 90, height: 24),
            ],
          ),
          const SizedBox(height: 20),
          // Start button
          const SkeletonLoader.card(width: double.infinity, height: 48),
        ],
      ),
    );
  }

  /// Job card skeleton
  static Widget jobCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Company logo
              const SkeletonLoader.circular(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader.text(width: double.infinity, height: 16),
                    const SizedBox(height: 4),
                    const SkeletonLoader.text(width: 120, height: 12),
                  ],
                ),
              ),
              const SkeletonLoader.text(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: 16),
          // Job requirements
          const SkeletonLoader.text(width: double.infinity, height: 14),
          const SizedBox(height: 4),
          const SkeletonLoader.text(width: 200, height: 14),
          const SizedBox(height: 12),
          // Tags
          Row(
            children: [
              const SkeletonLoader.text(width: 60, height: 20),
              const SizedBox(width: 8),
              const SkeletonLoader.text(width: 80, height: 20),
              const SizedBox(width: 8),
              const SkeletonLoader.text(width: 70, height: 20),
            ],
          ),
        ],
      ),
    );
  }

  /// List skeleton with multiple items
  static Widget list({
    required Widget Function() itemBuilder,
    int itemCount = 5,
    EdgeInsets? padding,
  }) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(),
    );
  }
}