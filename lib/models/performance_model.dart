/// Performance Model
/// Represents user performance and analytics data
class PerformanceModel {
  final String id;
  final String userId;
  final String courseId;
  final String? modulId;
  final String? assessmentId;
  final double score;
  final double maxScore;
  final int timeSpent; // in minutes
  final int attempts;
  final String status; // completed, in_progress, failed
  final DateTime completedAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  
  PerformanceModel({
    required this.id,
    required this.userId,
    required this.courseId,
    this.modulId,
    this.assessmentId,
    required this.score,
    required this.maxScore,
    required this.timeSpent,
    required this.attempts,
    required this.status,
    required this.completedAt,
    required this.createdAt,
    this.metadata,
  });
  
  double get percentage => maxScore > 0 ? (score / maxScore) * 100 : 0;
  
  String get grade {
    final percent = percentage;
    if (percent >= 90) return 'A+';
    if (percent >= 80) return 'A';
    if (percent >= 70) return 'B';
    if (percent >= 60) return 'C';
    if (percent >= 50) return 'D';
    return 'F';
  }
  
  bool get isPassed => percentage >= 60;
  
  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? '',
      modulId: json['moduleId']?.toString(),
      assessmentId: json['assessmentId']?.toString(),
      score: (json['score'] ?? 0).toDouble(),
      maxScore: (json['maxScore'] ?? 0).toDouble(),
      timeSpent: json['timeSpent'] ?? 0,
      attempts: json['attempts'] ?? 1,
      status: json['status']?.toString() ?? 'in_progress',
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'].toString())
          : DateTime.now(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'moduleId': modulId,
      'assessmentId': assessmentId,
      'score': score,
      'maxScore': maxScore,
      'timeSpent': timeSpent,
      'attempts': attempts,
      'status': status,
      'completedAt': completedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}