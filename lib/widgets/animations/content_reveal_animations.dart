import 'package:flutter/material.dart';

/// Professional expandable content widget with smooth animations
class ExpandableCard extends StatefulWidget {
  final Widget header;
  final Widget content;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final Curve expandCurve;
  final Curve collapseCurve;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final VoidCallback? onExpansionChanged;

  const ExpandableCard({
    super.key,
    required this.header,
    required this.content,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 400),
    this.expandCurve = Curves.easeOutCubic,
    this.collapseCurve = Curves.easeInCubic,
    this.padding,
    this.decoration,
    this.onExpansionChanged,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: _isExpanded ? widget.expandCurve : widget.collapseCurve.flipped,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: widget.expandCurve),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.expandCurve,
    ));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration ??
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header (always visible)
            InkWell(
              onTap: _toggleExpansion,
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: widget.header),
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Expandable content
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16).copyWith(top: 0),
                  child: widget.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated accordion widget for multiple expandable sections
class AnimatedAccordion extends StatefulWidget {
  final List<AccordionSection> sections;
  final bool allowMultiple;
  final Duration animationDuration;
  final EdgeInsets? sectionPadding;
  final double sectionSpacing;

  const AnimatedAccordion({
    super.key,
    required this.sections,
    this.allowMultiple = false,
    this.animationDuration = const Duration(milliseconds: 400),
    this.sectionPadding,
    this.sectionSpacing = 8.0,
  });

  @override
  State<AnimatedAccordion> createState() => _AnimatedAccordionState();
}

class _AnimatedAccordionState extends State<AnimatedAccordion> {
  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = widget.sections
        .map((section) => section.initiallyExpanded)
        .toList();
  }

  void _toggleSection(int index) {
    setState(() {
      if (widget.allowMultiple) {
        _expandedStates[index] = !_expandedStates[index];
      } else {
        // Close all others
        for (int i = 0; i < _expandedStates.length; i++) {
          _expandedStates[i] = i == index ? !_expandedStates[i] : false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < widget.sections.length - 1 ? widget.sectionSpacing : 0,
          ),
          child: ExpandableCard(
            header: section.header,
            content: section.content,
            initiallyExpanded: _expandedStates[index],
            animationDuration: widget.animationDuration,
            padding: widget.sectionPadding,
            onExpansionChanged: () => _toggleSection(index),
          ),
        );
      }).toList(),
    );
  }
}

/// Data class for accordion sections
class AccordionSection {
  final Widget header;
  final Widget content;
  final bool initiallyExpanded;

  const AccordionSection({
    required this.header,
    required this.content,
    this.initiallyExpanded = false,
  });
}

/// Card reveal animation for content that slides in
class RevealCard extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final RevealDirection direction;
  final double distance;
  final Curve curve;

  const RevealCard({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.direction = RevealDirection.up,
    this.distance = 100.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<RevealCard> createState() => _RevealCardState();
}

class _RevealCardState extends State<RevealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    Offset beginOffset;
    switch (widget.direction) {
      case RevealDirection.up:
        beginOffset = Offset(0, widget.distance / 100);
        break;
      case RevealDirection.down:
        beginOffset = Offset(0, -widget.distance / 100);
        break;
      case RevealDirection.left:
        beginOffset = Offset(widget.distance / 100, 0);
        break;
      case RevealDirection.right:
        beginOffset = Offset(-widget.distance / 100, 0);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

enum RevealDirection {
  up,
  down,
  left,
  right,
}

/// Bounce-in animation for highlighting content
class BounceInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double scaleFactor;

  const BounceInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.scaleFactor = 1.2,
  });

  @override
  State<BounceInWidget> createState() => _BounceInWidgetState();
}

class _BounceInWidgetState extends State<BounceInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}