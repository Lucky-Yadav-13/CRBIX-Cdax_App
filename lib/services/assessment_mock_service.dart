import 'dart:math';
import '../models/assessment/assessment_model.dart';
import '../models/assessment/question_model.dart';
import '../models/assessment/assessment_result_model.dart';

class AssessmentMockService {
  static const AssessmentMockService _instance = AssessmentMockService._internal();
  factory AssessmentMockService() => _instance;
  const AssessmentMockService._internal();

  // Mock data - simulates Supabase data
  final List<Assessment> _mockAssessments = const [
    Assessment(
      id: 'flutter_basics',
      title: 'Flutter Fundamentals',
      category: 'Mobile Development',
      duration: 30,
      difficulty: 'Beginner',
      description: 'Test your knowledge of Flutter basics including widgets, state management, and navigation.',
      totalQuestions: 10,
      passingScore: 70,
    ),
    Assessment(
      id: 'dart_advanced',
      title: 'Advanced Dart Programming',
      category: 'Programming Language',
      duration: 45,
      difficulty: 'Advanced',
      description: 'Advanced concepts in Dart including async programming, generics, and design patterns.',
      totalQuestions: 15,
      passingScore: 80,
    ),
    Assessment(
      id: 'ui_ux_design',
      title: 'UI/UX Design Principles',
      category: 'Design',
      duration: 25,
      difficulty: 'Intermediate',
      description: 'Fundamental UI/UX design principles and best practices for mobile applications.',
      totalQuestions: 8,
      passingScore: 75,
    ),
    Assessment(
      id: 'state_management',
      title: 'State Management in Flutter',
      category: 'Mobile Development',
      duration: 40,
      difficulty: 'Intermediate',
      description: 'Different state management approaches in Flutter including Provider, Riverpod, and BLoC.',
      totalQuestions: 12,
      passingScore: 70,
    ),
    Assessment(
      id: 'api_integration',
      title: 'API Integration & Networking',
      category: 'Backend Integration',
      duration: 35,
      difficulty: 'Intermediate',
      description: 'REST API integration, HTTP requests, error handling, and data serialization.',
      totalQuestions: 10,
      passingScore: 75,
    ),
  ];

  /// Simulates fetching assessments from Supabase
  Future<List<Assessment>> getAvailableAssessments() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    // Simulate occasional network error (5% chance)
    if (Random().nextInt(100) < 5) {
      throw Exception('Failed to fetch assessments. Please check your internet connection.');
    }
    
    return _mockAssessments.where((assessment) => assessment.isActive).toList();
  }

  /// Simulates fetching questions for a specific assessment from Supabase
  Future<List<Question>> getQuestionsForAssessment(String assessmentId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    // Simulate occasional network error (3% chance)
    if (Random().nextInt(100) < 3) {
      throw Exception('Failed to load questions. Please try again.');
    }
    
    return _generateMockQuestions(assessmentId);
  }

  /// Simulates submitting assessment result to Supabase
  Future<AssessmentResult> submitAssessmentResult({
    required String assessmentId,
    required String userId,
    required Map<String, UserAnswer> userAnswers,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200)); // Simulate processing time
    
    // Simulate occasional submission error (2% chance)
    if (Random().nextInt(100) < 2) {
      throw Exception('Failed to submit assessment. Please try again.');
    }
    
    // Calculate result
    final questions = await getQuestionsForAssessment(assessmentId);
    final assessment = _mockAssessments.firstWhere((a) => a.id == assessmentId);
    
    int correctAnswers = 0;
    int wrongAnswers = 0;
    int skippedAnswers = 0;
    int totalScore = 0;
    
    for (final question in questions) {
      final userAnswer = userAnswers[question.id];
      if (userAnswer == null) {
        skippedAnswers++;
      } else {
        final isCorrect = _isAnswerCorrect(question, userAnswer.answer);
        if (isCorrect) {
          correctAnswers++;
          totalScore += question.points;
        } else {
          wrongAnswers++;
        }
      }
    }
    
    final percentage = (correctAnswers / questions.length) * 100;
    final passed = percentage >= assessment.passingScore;
    
    return AssessmentResult(
      id: 'result_${DateTime.now().millisecondsSinceEpoch}',
      assessmentId: assessmentId,
      userId: userId,
      score: totalScore,
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      skippedAnswers: skippedAnswers,
      percentage: percentage,
      passed: passed,
      startTime: startTime,
      endTime: endTime,
      timeTaken: endTime.difference(startTime),
      answers: userAnswers.map((k, v) => MapEntry(k, v.toJson())),
    );
  }

  /// Generate mock questions for an assessment
  List<Question> _generateMockQuestions(String assessmentId) {
    final random = Random(assessmentId.hashCode);
    final assessment = _mockAssessments.firstWhere((a) => a.id == assessmentId);
    
    return List.generate(assessment.totalQuestions, (index) {
      final questionTypes = [QuestionType.multipleChoice, QuestionType.multipleSelect];
      final type = questionTypes[random.nextInt(questionTypes.length)];
      
      switch (assessmentId) {
        case 'flutter_basics':
          return _generateFlutterBasicsQuestion(index, type, random);
        case 'dart_advanced':
          return _generateDartAdvancedQuestion(index, type, random);
        case 'ui_ux_design':
          return _generateUIUXQuestion(index, type, random);
        case 'state_management':
          return _generateStateManagementQuestion(index, type, random);
        case 'api_integration':
          return _generateAPIIntegrationQuestion(index, type, random);
        default:
          return _generateGenericQuestion(index, type, random, assessmentId);
      }
    });
  }

  Question _generateFlutterBasicsQuestion(int index, QuestionType type, Random random) {
    final questions = [
      {
        'question': 'Which widget is used to create a scrollable list in Flutter?',
        'options': ['ListView', 'Column', 'Row', 'Container'],
        'correct': 0,
        'explanation': 'ListView is the primary widget for creating scrollable lists in Flutter.',
      },
      {
        'question': 'What is the purpose of the StatefulWidget in Flutter?',
        'options': ['Static UI', 'Dynamic UI with state', 'Navigation', 'Styling'],
        'correct': 1,
        'explanation': 'StatefulWidget allows you to create widgets that can change their state dynamically.',
      },
      {
        'question': 'Which method is called when a StatefulWidget is first created?',
        'options': ['build()', 'initState()', 'dispose()', 'setState()'],
        'correct': 1,
        'explanation': 'initState() is called once when the StatefulWidget is first created.',
      },
      {
        'question': 'What does the "hot reload" feature in Flutter do?',
        'options': ['Restarts the app', 'Updates UI instantly', 'Clears cache', 'Rebuilds project'],
        'correct': 1,
        'explanation': 'Hot reload allows you to see changes in your code instantly without restarting the app.',
      },
      {
        'question': 'Which widget is used for creating buttons in Flutter?',
        'options': ['TextButton', 'ElevatedButton', 'OutlinedButton', 'All of the above'],
        'correct': 3,
        'explanation': 'Flutter provides multiple button widgets: TextButton, ElevatedButton, and OutlinedButton.',
      },
    ];
    
    if (index < questions.length) {
      final q = questions[index];
      return Question(
        id: 'flutter_q_$index',
        assessmentId: 'flutter_basics',
        question: q['question'] as String,
        type: type,
        options: q['options'] as List<String>,
        correctAnswer: type == QuestionType.multipleSelect 
            ? [q['correct'] as int] 
            : q['correct'] as int,
        explanation: q['explanation'] as String,
      );
    }
    
    return _generateGenericQuestion(index, type, random, 'flutter_basics');
  }

  Question _generateDartAdvancedQuestion(int index, QuestionType type, Random random) {
    final questions = [
      {
        'question': 'What is the purpose of the "async" keyword in Dart?',
        'options': ['Synchronous execution', 'Asynchronous execution', 'Error handling', 'Type casting'],
        'correct': 1,
        'explanation': 'The async keyword is used to mark functions that perform asynchronous operations.',
      },
      {
        'question': 'Which of these is a correct way to handle Future in Dart?',
        'options': ['await', 'then()', 'catchError()', 'All of the above'],
        'correct': 3,
        'explanation': 'Dart provides multiple ways to handle Futures: await, then(), and catchError().',
      },
      {
        'question': 'What does the "late" keyword do in Dart?',
        'options': ['Delays execution', 'Late initialization', 'Error handling', 'Type inference'],
        'correct': 1,
        'explanation': 'The late keyword allows you to declare non-nullable variables that are initialized later.',
      },
    ];
    
    if (index < questions.length) {
      final q = questions[index];
      return Question(
        id: 'dart_q_$index',
        assessmentId: 'dart_advanced',
        question: q['question'] as String,
        type: type,
        options: q['options'] as List<String>,
        correctAnswer: type == QuestionType.multipleSelect 
            ? [q['correct'] as int] 
            : q['correct'] as int,
        explanation: q['explanation'] as String,
      );
    }
    
    return _generateGenericQuestion(index, type, random, 'dart_advanced');
  }

  Question _generateUIUXQuestion(int index, QuestionType type, Random random) {
    final questions = [
      {
        'question': 'What is the primary goal of UI/UX design?',
        'options': ['Visual appeal', 'User experience', 'Performance', 'Code quality'],
        'correct': 1,
        'explanation': 'The primary goal of UI/UX design is to create the best possible user experience.',
      },
      {
        'question': 'Which principle emphasizes the importance of consistency in design?',
        'options': ['Contrast', 'Hierarchy', 'Unity', 'Balance'],
        'correct': 2,
        'explanation': 'Unity principle emphasizes consistency and coherence in design elements.',
      },
    ];
    
    if (index < questions.length) {
      final q = questions[index];
      return Question(
        id: 'ui_q_$index',
        assessmentId: 'ui_ux_design',
        question: q['question'] as String,
        type: type,
        options: q['options'] as List<String>,
        correctAnswer: type == QuestionType.multipleSelect 
            ? [q['correct'] as int] 
            : q['correct'] as int,
        explanation: q['explanation'] as String,
      );
    }
    
    return _generateGenericQuestion(index, type, random, 'ui_ux_design');
  }

  Question _generateStateManagementQuestion(int index, QuestionType type, Random random) {
    final questions = [
      {
        'question': 'Which is NOT a state management solution for Flutter?',
        'options': ['Provider', 'Riverpod', 'BLoC', 'Redux'],
        'correct': 3,
        'explanation': 'Redux is primarily a JavaScript state management library, though there are Flutter adaptations.',
      },
      {
        'question': 'What does Provider package help with in Flutter?',
        'options': ['Navigation', 'State management', 'HTTP requests', 'Animations'],
        'correct': 1,
        'explanation': 'Provider is a popular state management solution for Flutter applications.',
      },
    ];
    
    if (index < questions.length) {
      final q = questions[index];
      return Question(
        id: 'state_q_$index',
        assessmentId: 'state_management',
        question: q['question'] as String,
        type: type,
        options: q['options'] as List<String>,
        correctAnswer: type == QuestionType.multipleSelect 
            ? [q['correct'] as int] 
            : q['correct'] as int,
        explanation: q['explanation'] as String,
      );
    }
    
    return _generateGenericQuestion(index, type, random, 'state_management');
  }

  Question _generateAPIIntegrationQuestion(int index, QuestionType type, Random random) {
    final questions = [
      {
        'question': 'Which HTTP method is typically used to retrieve data from an API?',
        'options': ['POST', 'GET', 'PUT', 'DELETE'],
        'correct': 1,
        'explanation': 'GET method is used to retrieve data from a server without modifying it.',
      },
      {
        'question': 'What does JSON stand for?',
        'options': ['Java Script Object Notation', 'JavaScript Object Notation', 'Java Syntax Object Notation', 'JavaScript Oriented Notation'],
        'correct': 1,
        'explanation': 'JSON stands for JavaScript Object Notation, a lightweight data interchange format.',
      },
    ];
    
    if (index < questions.length) {
      final q = questions[index];
      return Question(
        id: 'api_q_$index',
        assessmentId: 'api_integration',
        question: q['question'] as String,
        type: type,
        options: q['options'] as List<String>,
        correctAnswer: type == QuestionType.multipleSelect 
            ? [q['correct'] as int] 
            : q['correct'] as int,
        explanation: q['explanation'] as String,
      );
    }
    
    return _generateGenericQuestion(index, type, random, 'api_integration');
  }

  Question _generateGenericQuestion(int index, QuestionType type, Random random, String assessmentId) {
    final options = ['Option A', 'Option B', 'Option C', 'Option D'];
    final correctIndex = random.nextInt(options.length);
    
    return Question(
      id: '${assessmentId}_q_$index',
      assessmentId: assessmentId,
      question: 'Sample question ${index + 1} for $assessmentId assessment?',
      type: type,
      options: options,
      correctAnswer: type == QuestionType.multipleSelect 
          ? [correctIndex] 
          : correctIndex,
      explanation: 'This is a sample explanation for question ${index + 1}.',
    );
  }

  bool _isAnswerCorrect(Question question, dynamic userAnswer) {
    if (question.type == QuestionType.multipleChoice) {
      return userAnswer == question.correctAnswer;
    } else if (question.type == QuestionType.multipleSelect) {
      final correctAnswers = question.correctAnswer as List<int>;
      final userAnswers = userAnswer as List<int>;
      if (correctAnswers.length != userAnswers.length) return false;
      correctAnswers.sort();
      userAnswers.sort();
      for (int i = 0; i < correctAnswers.length; i++) {
        if (correctAnswers[i] != userAnswers[i]) return false;
      }
      return true;
    }
    return false;
  }
}
