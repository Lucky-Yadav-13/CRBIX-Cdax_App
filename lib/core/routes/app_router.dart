import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/presentation/forgot_password_screen.dart';
import '../../screens/auth/presentation/login_screen.dart';
import '../../screens/auth/presentation/signup_screen.dart';
import '../../screens/auth/presentation/splash_screen.dart';
import '../../screens/dashboard/presentation/dashboard_screen.dart';
import '../../screens/dashboard/presentation/home_screen.dart';
import '../../screens/courses/presentation/course_list_screen.dart';
import '../../screens/courses/presentation/course_detail_screen.dart';
import '../../screens/courses/presentation/module_player_screen.dart';
import '../../screens/support/presentation/support_screen.dart';
import '../../screens/profile/presentation/profile_screen.dart';
import '../../screens/profile/presentation/profile_edit_screen.dart';

/// Centralized application router using GoRouter
/// Defines all app routes and navigation logic.
class AppRouter {
  AppRouter._();

  /// Global navigator key if needed in the future for dialogs, etc.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    routes: <GoRoute>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      /// Dashboard routes
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'home',
            name: 'dashboardHome',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: 'courses',
            name: 'dashboardCourses',
            builder: (context, state) => const CourseListScreen(),
          ),
          GoRoute(
            path: 'courses/:id',
            name: 'dashboardCourseDetail',
            builder: (context, state) => CourseDetailScreen(courseId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'courses/:courseId/module/:moduleId',
            name: 'dashboardModulePlayer',
            builder: (context, state) => ModulePlayerScreen(
              courseId: state.pathParameters['courseId']!,
              moduleId: state.pathParameters['moduleId']!,
            ),
          ),
          GoRoute(
            path: 'profile',
            name: 'dashboardProfile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'dashboardProfileEdit',
                builder: (context, state) => const ProfileEditScreen(),
              )
            ],
          ),
          GoRoute(
            path: 'support',
            name: 'dashboardSupport',
            builder: (context, state) => const SupportScreen(),
          ),
        ],
      ),
    ],
  );
}

/// Simple placeholder for not-yet-implemented sections.
class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({this.title = 'Dashboard coming soon...'});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}


