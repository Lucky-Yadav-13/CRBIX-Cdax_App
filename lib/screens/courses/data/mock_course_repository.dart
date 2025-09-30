// ASSUMPTION: This mock repository simulates network calls with delays
// and returns canned data. Replace with RemoteCourseRepository later.

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'models/course.dart';
import 'models/module.dart';

/// CourseRepository interface (documented for swap-in)
/// Implementations should provide methods used by providers below.
abstract class CourseRepository {
  Future<List<Course>> getCourses({String? search, int page = 1});
  Future<Course> getCourseById(String id);
}

class MockCourseRepository implements CourseRepository {
  MockCourseRepository();

  static final List<Course> _courses = _buildMockCourses();

  static List<Course> _buildMockCourses() {
    List<Course> list = [];
    for (int i = 1; i <= 3; i++) {
      final String id = 'c$i';
      final bool isSubscribed = i % 2 == 1; // mix
      final modules = List<Module>.generate(4, (index) {
        final int num = index + 1;
        final bool locked = !isSubscribed && num > 1; // only first open if not subscribed
        return Module(
          id: 'm${i}_$num',
          title: 'Module $num',
          durationSec: 600 + num * 120,
          isLocked: locked,
          videoUrl: 'https://example.com/video/$id/$num',
        );
      });
      list.add(Course(
        id: id,
        title: 'Course $i',
        description: 'Concise description for course $i with key outcomes.',
        thumbnailUrl: 'https://picsum.photos/seed/$id/800/450',
        progressPercent: isSubscribed ? (0.15 * i).clamp(0, 1) : 0.0,
        isSubscribed: isSubscribed,
        modules: modules,
      ));
    }
    return list;
  }

  Duration _delay() => Duration(milliseconds: 700 + Random().nextInt(300));

  @override
  Future<List<Course>> getCourses({String? search, int page = 1}) async {
    await Future.delayed(_delay());
    Iterable<Course> data = _courses;
    if (search != null && search.trim().isNotEmpty) {
      final s = search.trim().toLowerCase();
      data = data.where((c) => c.title.toLowerCase().contains(s));
    }
    // Pagination stub: return all; later slice by page.
    return data.toList(growable: false);
  }

  @override
  Future<Course> getCourseById(String id) async {
    await Future.delayed(_delay());
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      // Safe fallback to avoid UI crashes; return a lightweight placeholder
      return Course(
        id: id,
        title: 'Course',
        description: 'Details will be available soon.',
        thumbnailUrl: 'https://picsum.photos/seed/$id/800/450',
        progressPercent: 0.0,
        isSubscribed: false,
        modules: const <Module>[],
      );
    }
  }
}


