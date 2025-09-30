import 'package:cdax_app/screens/courses/presentation/course_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CourseListScreen shows course cards', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CourseListScreen()));
    // Initial loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Wait for mock fetch
    await tester.pumpAndSettle(const Duration(seconds: 2));
    // 3 courses
    expect(find.byType(Card), findsNWidgets(3));
  });
}


