// ASSUMPTION: This mock repository simulates network calls with delays
// and returns canned data. Replace with RemoteCourseRepository later.

import 'dart:math';
import 'models/course.dart';
import 'models/module.dart';
import '../../../models/assessment/question_model.dart';
import '../../../models/assessment/assessment_model.dart';

/// CourseRepository interface (documented for swap-in)
/// Implementations should provide methods used by providers below.
abstract class CourseRepository {
  Future<List<Course>> getCourses({String? search, int page = 1});
  Future<Course> getCourseById(String id);
  Future<bool> enrollInCourse(String courseId);
  Future<bool> unenrollFromCourse(String courseId);
  Future<bool> purchaseCourse(String courseId);
  Future<List<Question>> getAssessmentQuestions(String assessmentId);
  Future<List<Assessment>> getModuleAssessments(String moduleId);
}

class MockCourseRepository implements CourseRepository {
  MockCourseRepository();

  static final List<Course> _courses = _buildMockCourses();
  
  // Track enrollment state separately from subscription
  static final Set<String> _enrolledCourses = <String>{};
  static final Set<String> _purchasedCourses = <String>{};

  static List<Course> _buildMockCourses() {
    List<Course> list = [];
    for (int i = 1; i <= 3; i++) {
      final String id = 'c$i';
      final bool isSubscribed = i % 2 == 1 || _purchasedCourses.contains(id); // mix + purchased
      final String courseTitle = i == 1 ? 'Flutter Development' : 
                            i == 2 ? 'Python Development' : 
                            'Java Programming';
      
      final modules = List<Module>.generate(4, (index) {
        final int num = index + 1;
        final bool locked = !isSubscribed && num > 1; // only first open if not subscribed
        final String videoUrl = i == 1 ? 'https://youtu.be/RFThBMUs3e0' :
                               i == 2 ? 'https://youtu.be/7MQe8B5n2t8' :
                               'https://youtu.be/loYQ4CkTngo';
        
        // Create assessment for modules 2 and 4 to add variety
        Assessment? assessment;
        if (num == 2 || num == 4) {
          assessment = Assessment(
            id: 'assessment_${i}_$num',
            title: 'Module $num Assessment',
            category: courseTitle,
            duration: 15 + num * 5, // 20-35 minutes
            difficulty: num == 2 ? 'Easy' : 'Medium',
            description: 'Test your understanding of Module $num concepts',
            totalQuestions: 5 + num,
            passingScore: 70,
            isActive: !locked, // Only active if module is unlocked
          );
        }
        
        // Create module with assessment
        final baseModule = Module.legacy(
          id: 'm${i}_$num',
          title: 'Module $num',
          durationSec: 600 + num * 120,
          isLocked: locked,
          videoUrl: videoUrl,
        );
        
        // Return module with assessment if exists
        return Module(
          id: baseModule.id,
          title: baseModule.title,
          description: baseModule.description,
          durationSec: baseModule.durationSec,
          isLocked: baseModule.isLocked,
          orderIndex: baseModule.orderIndex,
          videos: baseModule.videos,
          assessment: assessment,
        );
      });
      final String courseDescription = i == 1 ? 'Comprehensive Flutter development course with practical projects.' :
                                     i == 2 ? 'Complete Python development course from basics to advanced.' :
                                     'Complete Java programming course with hands-on coding.';
      
      list.add(Course.legacy(
        id: id,
        title: courseTitle,
        description: courseDescription,
        thumbnailUrl: 'https://picsum.photos/seed/$id/800/450',
        progressPercent: isSubscribed ? (0.15 * i).clamp(0, 1) : 0.0,
        isSubscribed: isSubscribed,
        isEnrolled: false, // Initially not enrolled
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
      final course = _courses.firstWhere((c) => c.id == id);
      // Compute dynamic purchase state
      final bool purchasedNow = course.isSubscribed || _purchasedCourses.contains(id);
      // If purchased, unlock all modules dynamically; else keep original lock state
      final List<Module> dynamicModules = course.modules
          .map((m) => Module(
                id: m.id,
                title: m.title,
                durationSec: m.durationSec,
                isLocked: purchasedNow ? false : m.isLocked,
                videos: m.videos, // Use the videos list instead of videoUrl
              ))
          .toList(growable: false);
      // Return course with updated enrollment and purchase status
      return Course.legacy(
        id: course.id,
        title: course.title,
        description: course.description,
        thumbnailUrl: course.thumbnailUrl,
        progressPercent: course.progressPercent,
        isSubscribed: purchasedNow, // Dynamic purchase status
        modules: dynamicModules,
        isEnrolled: _enrolledCourses.contains(id), // Dynamic enrollment status
      );
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
        isEnrolled: false,
      );
    }
  }

  @override
  Future<bool> enrollInCourse(String courseId) async {
    await Future.delayed(_delay());
    // Only allow enrollment if course is purchased (isSubscribed or purchased)
    final course = _courses.firstWhere((c) => c.id == courseId);
    final isPurchased = course.isSubscribed || _purchasedCourses.contains(courseId);
    if (isPurchased) {
      _enrolledCourses.add(courseId);
      return true;
    }
    return false; // Cannot enroll in unpurchased course
  }

  @override
  Future<bool> unenrollFromCourse(String courseId) async {
    await Future.delayed(_delay());
    _enrolledCourses.remove(courseId);
    return true;
  }

  @override
  Future<bool> purchaseCourse(String courseId) async {
    await Future.delayed(_delay());
    _purchasedCourses.add(courseId);
    // Auto-enroll user after purchase
    _enrolledCourses.add(courseId);
    return true;
  }

  @override
  Future<List<Question>> getAssessmentQuestions(String assessmentId) async {
    print('🔧 MockCourseRepository: Generating questions for assessment $assessmentId');
    await Future.delayed(_delay());
    // Generate mock questions for the assessment
    final random = Random(assessmentId.hashCode);
    final questionCount = 3 + random.nextInt(5); // 3-7 questions
    
    final questions = List<Question>.generate(questionCount, (index) {
      final questionNumber = index + 1;
      final optionCount = 4;
      final correctIndex = random.nextInt(optionCount);
      
      return Question(
        id: '${assessmentId}_q$questionNumber',
        assessmentId: assessmentId,
        question: 'Question $questionNumber: What is the correct concept related to this topic?',
        type: QuestionType.multipleChoice,
        options: List<String>.generate(optionCount, (i) => 'Option ${String.fromCharCode(65 + i)}'),
        correctAnswer: correctIndex,
        points: 1,
        explanation: 'Option ${String.fromCharCode(65 + correctIndex)} is correct because it represents the fundamental concept.',
      );
    });
    
    print('✅ MockCourseRepository: Generated ${questions.length} questions');
    return questions;
  }

  @override
  Future<List<Assessment>> getModuleAssessments(String moduleId) async {
    await Future.delayed(_delay());
    print('🎯 MockCourseRepository: getModuleAssessments called for module $moduleId');
    
    // Always return an assessment for testing
    final assessments = [
      Assessment(
        id: '${moduleId}_assessment',
        title: 'Module Assessment',
        category: 'Quiz',
        duration: 15,
        difficulty: 'Medium',
        description: 'Test your understanding of this module',
        totalQuestions: 5,
        passingScore: 60,
        isActive: true,
      ),
    ];
    
    print('✅ MockCourseRepository: Returning ${assessments.length} assessments');
    return assessments;
  }
}


