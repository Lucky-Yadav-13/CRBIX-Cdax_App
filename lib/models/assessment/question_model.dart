enum QuestionType {
  multipleChoice,
  multipleSelect,
  textInput,
}

class Question {
  final String id;
  final String assessmentId;
  final String question;
  final QuestionType type;
  final List<String> options;
  final dynamic correctAnswer; // Can be int, List<int>, or String
  final int points;
  final String? explanation;
  final String? codeSnippet;

  const Question({
    required this.id,
    required this.assessmentId,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.points = 1,
    this.explanation,
    this.codeSnippet,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      assessmentId: json['assessment_id'] as String,
      question: json['question'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'],
      points: json['points'] as int? ?? 1,
      explanation: json['explanation'] as String?,
      codeSnippet: json['code_snippet'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'question': question,
      'type': type.name,
      'options': options,
      'correct_answer': correctAnswer,
      'points': points,
      'explanation': explanation,
      'code_snippet': codeSnippet,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class UserAnswer {
  final String questionId;
  final dynamic answer; // Can be int, List<int>, or String
  final DateTime timestamp;

  const UserAnswer({
    required this.questionId,
    required this.answer,
    required this.timestamp,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['question_id'] as String,
      answer: json['answer'],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAnswer &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId;

  @override
  int get hashCode => questionId.hashCode;
}
