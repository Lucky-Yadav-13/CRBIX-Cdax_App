import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for enhanced navigation experience
class AppPageTransitions {
  AppPageTransitions._();

  /// Slide transition from right to left
  static CustomTransitionPage<T> slideTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
    Offset beginOffset = const Offset(1.0, 0.0),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        
        final slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Scale transition with fade
  static CustomTransitionPage<T> scaleTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        
        final scaleAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Fade transition only
  static CustomTransitionPage<T> fadeTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Bottom sheet style transition (slide up from bottom)
  static CustomTransitionPage<T> bottomSheetTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  /// Custom hero-style transition with shared elements
  static CustomTransitionPage<T> heroTransition<T extends Object?>({
    required Widget child,
    required GoRouterState state,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        final scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Extension to easily apply transitions to GoRoute
extension GoRouteTransitions on GoRoute {
  /// Apply slide transition to this route
  GoRoute withSlideTransition({
    Offset beginOffset = const Offset(1.0, 0.0),
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => AppPageTransitions.slideTransition(
        child: builder!(context, state),
        state: state,
        beginOffset: beginOffset,
        duration: duration,
      ),
      routes: routes,
    );
  }

  /// Apply scale transition to this route
  GoRoute withScaleTransition({
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => AppPageTransitions.scaleTransition(
        child: builder!(context, state),
        state: state,
        duration: duration,
      ),
      routes: routes,
    );
  }

  /// Apply fade transition to this route
  GoRoute withFadeTransition({
    Duration duration = const Duration(milliseconds: 200),
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => AppPageTransitions.fadeTransition(
        child: builder!(context, state),
        state: state,
        duration: duration,
      ),
      routes: routes,
    );
  }
}
