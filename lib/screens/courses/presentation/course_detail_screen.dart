// ASSUMPTION: Local enroll toggle only; backend integration later.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../application/course_providers.dart';
import '../../courses/presentation/module_row.dart';
import '../../courses/data/mock_course_repository.dart';
import '../../courses/data/models/module.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool? _enrolledOverride; // null means use course.isSubscribed
  final _repo = MockCourseRepository();

  @override
  Widget build(BuildContext context) {
    final asyncCourse = _repo.getCourseById(widget.courseId);
    final theme = Theme.of(context);
    return FutureBuilder(
      future: asyncCourse,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(appBar: AppBar(), body: Center(child: Text('Error: ${snapshot.error}')));
        }
        final course = snapshot.data;
        if (course == null) {
          return const Scaffold(
            body: Center(child: Text('Course not found')),
          );
        }
        final bool enrolled = _enrolledOverride ?? course.isSubscribed;
        return Scaffold(
          appBar: AppBar(title: Text(course.title)),
          body: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Module? firstUnlocked;
                  for (final m in course.modules) {
                    if (!m.isLocked) {
                      firstUnlocked = m;
                      break;
                    }
                  }
                  firstUnlocked ??= course.modules.isNotEmpty ? course.modules.first : null;
                  if (firstUnlocked != null) {
                    context.go('/dashboard/courses/${course.id}/module/${firstUnlocked.id}');
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(course.thumbnailUrl, fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.play_arrow, size: 48, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(course.description),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () => setState(() => _enrolledOverride = !enrolled),
                          child: Text(enrolled ? 'Unenroll' : 'Enroll'),
                        ),
                        const SizedBox(width: 12),
                        Text('Progress: ${(course.progressPercent * 100).round()}%'),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: course.modules.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: Text('No modules available')),
                          )
                        ]
                      : course.modules.map((m) {
                          return ModuleRow(
                            module: m,
                            onPlay: m.isLocked
                                ? null
                                : () => context.go('/dashboard/courses/${course.id}/module/${m.id}'),
                          );
                        }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


