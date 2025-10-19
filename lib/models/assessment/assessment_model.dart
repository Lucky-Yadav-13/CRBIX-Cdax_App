class Assessment {
  final String id;
  final String title;
  final String category;
  final int duration; // in minutes
  final String difficulty;
  final String description;
  final int totalQuestions;
  final int passingScore;
  final bool isActive;

  const Assessment({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.totalQuestions,
    required this.passingScore,
    this.isActive = true,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      duration: json['duration'] as int,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String,
      totalQuestions: json['total_questions'] as int,
      passingScore: json['passing_score'] as int,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'description': description,
      'total_questions': totalQuestions,
      'passing_score': passingScore,
      'is_active': isActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Assessment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}