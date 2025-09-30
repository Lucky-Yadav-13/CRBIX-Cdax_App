import 'package:cdax_app/screens/courses/data/mock_course_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MockCourseRepository.getCourses returns 3 items', () async {
    final repo = MockCourseRepository();
    final items = await repo.getCourses();
    expect(items.length, 3);
  });
}


