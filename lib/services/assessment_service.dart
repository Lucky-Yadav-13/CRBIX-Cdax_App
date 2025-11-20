// Assessment Service for fetching module assessments and questions
// Similar to video_service.dart but for assessments

import 'package:flutter/foundation.dart';
import '../screens/courses/application/course_providers.dart';
import '../models/assessment/assessment_model.dart';
import '../models/assessment/question_model.dart';

class AssessmentService {
  
  /// Get assessments for a specific module
  static Future<List<Assessment>> getModuleAssessments({
    required String courseId,
    required String moduleId,
  }) async {
    if (kDebugMode) {
      debugPrint('🎯 AssessmentService: Fetching assessments for module $moduleId in course $courseId');
    }
    
    try {
      // Get repository using factory (same as video service)
      final repo = CourseProviders.getCourseRepository();
      print('📚 Using repository: ${repo.runtimeType}');
      
      // Fetch assessments for this module
      final assessments = await repo.getModuleAssessments(moduleId);
      
      if (kDebugMode) {
        debugPrint('✅ Found ${assessments.length} assessments for module $moduleId');
      }
      for (final assessment in assessments) {
        if (kDebugMode) {
          debugPrint('   ├─ ${assessment.title} (${assessment.totalQuestions} questions)');
        }
      }
      
      return assessments;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching module assessments: $e');
      }
      return [];
    }
  }
  
  /// Get questions for a specific assessment
  static Future<List<Question>> getAssessmentQuestions({
    required String assessmentId,
  }) async {
    if (kDebugMode) {
      debugPrint('❓ AssessmentService: Fetching questions for assessment $assessmentId');
    }
    
    try {
      // Get repository using factory
      final repo = CourseProviders.getCourseRepository();
      print('📚 Using repository: ${repo.runtimeType}');
      
      // Fetch questions for this assessment
      final questions = await repo.getAssessmentQuestions(assessmentId);
      
      if (kDebugMode) {
        debugPrint('✅ Found ${questions.length} questions for assessment $assessmentId');
      }
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        if (kDebugMode) {
          debugPrint('   ├─ Q${i + 1}: ${q.question.substring(0, q.question.length.clamp(0, 50))}...');
        }
      }
      
      return questions;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching assessment questions: $e');
      }
      return [];
    }
  }
}