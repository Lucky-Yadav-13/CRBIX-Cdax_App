import 'package:flutter_test/flutter_test.dart';
import 'package:cdax_app/screens/courses/data/mock_course_repository.dart';

void main() {
  test('MockCourseRepository.getCourses returns 3 items', () async {
    final repo = MockCourseRepository();
    final courses = await repo.getCourses();
    expect(courses.length, 3);
  });
}


