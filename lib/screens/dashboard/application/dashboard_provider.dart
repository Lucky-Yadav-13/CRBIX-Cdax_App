// Assumptions
// - Provider-based state management using simple mock accessors.
// - Replace with real repository/services when backend is available.
// - Keep model lightweight and serializable-friendly.

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.progressPercent,
    this.description = '',
    this.isLocked = false,
  });

  final String id;
  final String title;
  final String thumbnailUrl;
  final double progressPercent; // 0.0 - 1.0
  final String description; // short summary shown on dashboard card
  final bool isLocked;
}

/// TODO: Integrate authenticated user info
String getMockUserName() => 'Rohit';

/// Mock: Enrolled courses for the user
Future<List<Course>> getMockEnrolledCourses() async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return const [
    Course(
      id: 'c1',
      title: 'Flutter Foundations',
      thumbnailUrl: 'https://picsum.photos/seed/flutter_foundations/400/240',
      progressPercent: 0.62,
      description: 'Master widgets, layouts, and state basics.',
      isLocked: false,
    ),
    Course(
      id: 'c2',
      title: 'Dart Essentials',
      thumbnailUrl: 'https://picsum.photos/seed/dart_essentials/400/240',
      progressPercent: 0.35,
      description: 'Core Dart language features for Flutter devs.',
      isLocked: false,
    ),
    Course(
      id: 'c3',
      title: 'UI/UX Basics',
      thumbnailUrl: 'https://picsum.photos/seed/ui_ux_basics/400/240',
      progressPercent: 0.12,
      description: 'Design fundamentals and accessibility.',
      isLocked: true,
    ),
  ];
}


