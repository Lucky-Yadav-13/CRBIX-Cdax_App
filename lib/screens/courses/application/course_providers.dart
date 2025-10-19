// ASSUMPTION: Provider-lite: expose repository types without external dependencies.
// TODO: Replace Mock with real backend repository when ready.

export '../data/mock_course_repository.dart' show CourseRepository, MockCourseRepository;

// ASSUMPTION: Provider-lite: expose repository types without external dependencies.

/// Simple last-played store without external dependencies; can be swapped for provider later.
class LastPlayedStore {
  LastPlayedStore._();
  static final LastPlayedStore instance = LastPlayedStore._();
  final Map<String, String?> _courseToModule = <String, String?>{};

  void setLastPlayed(String courseId, String moduleId) {
    _courseToModule[courseId] = moduleId;
  }

  String? lastForCourse(String courseId) => _courseToModule[courseId];
}


