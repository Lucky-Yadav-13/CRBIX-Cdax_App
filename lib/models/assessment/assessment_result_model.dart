class AssessmentResult {
  final String id;
  final String assessmentId;
  final String userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final double percentage;
  final bool passed;
  final DateTime startTime;
  final DateTime endTime;
  final Duration timeTaken;
  final Map<String, dynamic> answers;

  const AssessmentResult({
    required this.id,
    required this.assessmentId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.percentage,
    required this.passed,
    required this.startTime,
    required this.endTime,
    required this.timeTaken,
    required this.answers,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'] as String,
      assessmentId: json['assessment_id'] as String,
      userId: json['user_id'] as String,
      score: json['score'] as int,
      totalQuestions: json['total_questions'] as int,
      correctAnswers: json['correct_answers'] as int,
      wrongAnswers: json['wrong_answers'] as int,
      skippedAnswers: json['skipped_answers'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      passed: json['passed'] as bool,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      timeTaken: Duration(seconds: json['time_taken_seconds'] as int),
      answers: Map<String, dynamic>.from(json['answers'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'user_id': userId,
      'score': score,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'skipped_answers': skippedAnswers,
      'percentage': percentage,
      'passed': passed,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'time_taken_seconds': timeTaken.inSeconds,
      'answers': answers,
    };
  }

  String get performanceMessage {
    if (percentage >= 90) return 'Excellent! Outstanding performance!';
    if (percentage >= 80) return 'Great job! Well done!';
    if (percentage >= 70) return 'Good work! Keep it up!';
    if (percentage >= 60) return 'Fair performance. Try harder next time!';
    return 'Needs improvement. Please study more!';
  }

  String get gradeLevel {
    if (percentage >= 90) return 'A+';
    if (percentage >= 85) return 'A';
    if (percentage >= 80) return 'B+';
    if (percentage >= 75) return 'B';
    if (percentage >= 70) return 'C+';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentResult &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
