// ASSUMPTION: Provider-lite: expose repository types without Riverpod.
// TODO: Replace Mock with real backend repository when ready.

import '../data/mock_course_repository.dart';

export '../data/mock_course_repository.dart' show CourseRepository, MockCourseRepository;

/// Simple last-played store without Riverpod; can be swapped for provider later.
class LastPlayedStore {
  LastPlayedStore._();
  static final LastPlayedStore instance = LastPlayedStore._();
  final Map<String, String?> _courseToModule = <String, String?>{};

  void setLastPlayed(String courseId, String moduleId) {
    _courseToModule[courseId] = moduleId;
  }

  String? lastForCourse(String courseId) => _courseToModule[courseId];
}


