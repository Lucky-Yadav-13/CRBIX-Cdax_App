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
    // Parse options from backend format (optionA, optionB, optionC, optionD)
    List<String> optionsList = [];
    if (json['optionA'] != null) optionsList.add(json['optionA'].toString());
    if (json['optionB'] != null) optionsList.add(json['optionB'].toString());
    if (json['optionC'] != null) optionsList.add(json['optionC'].toString());
    if (json['optionD'] != null) optionsList.add(json['optionD'].toString());
    
    // If no individual options, try options array (fallback)
    if (optionsList.isEmpty && json['options'] is List) {
      optionsList = List<String>.from(json['options']);
    }
    
    // Parse correct answer - backend uses letter (A, B, C, D), convert to index
    dynamic correctAns = json['correctAnswer'] ?? json['correct_answer'];
    if (correctAns is String) {
      switch (correctAns.toUpperCase()) {
        case 'A': correctAns = 0; break;
        case 'B': correctAns = 1; break;
        case 'C': correctAns = 2; break;
        case 'D': correctAns = 3; break;
        default: correctAns = 0;
      }
    }

    return Question(
      id: json['id']?.toString() ?? '',
      assessmentId: json['assessment_id']?.toString() ?? json['assessmentId']?.toString() ?? '',
      question: json['questionText']?.toString() ?? json['question']?.toString() ?? '',
      type: QuestionType.multipleChoice, // Backend only supports multiple choice
      options: optionsList,
      correctAnswer: correctAns,
      points: json['marks'] ?? json['points'] ?? 1,
      explanation: json['explanation']?.toString(),
      codeSnippet: json['code_snippet']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    // Convert to backend format
    String correctLetter = 'A';
    if (correctAnswer is int) {
      switch (correctAnswer as int) {
        case 0: correctLetter = 'A'; break;
        case 1: correctLetter = 'B'; break;
        case 2: correctLetter = 'C'; break;
        case 3: correctLetter = 'D'; break;
      }
    }
    
    return {
      'id': id,
      'questionText': question,
      'optionA': options.isNotEmpty ? options[0] : '',
      'optionB': options.length > 1 ? options[1] : '',
      'optionC': options.length > 2 ? options[2] : '',
      'optionD': options.length > 3 ? options[3] : '',
      'correctAnswer': correctLetter,
      'marks': points,
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
