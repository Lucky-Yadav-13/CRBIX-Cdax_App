import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/assessment_provider.dart';
import '../../providers/assessment_result_provider.dart';
import 'widgets/question_card.dart';
import 'widgets/progress_bar.dart';

class AssessmentQuestionScreen extends StatefulWidget {
  final String assessmentId;

  const AssessmentQuestionScreen({
    super.key,
    required this.assessmentId,
  });

  @override
  State<AssessmentQuestionScreen> createState() => _AssessmentQuestionScreenState();
}

class _AssessmentQuestionScreenState extends State<AssessmentQuestionScreen> {
  Timer? _timer;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startAssessment();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startAssessment() async {
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    await assessmentProvider.startAssessment(widget.assessmentId);
    
    // Start timer
    if (assessmentProvider.currentAssessment != null && mounted) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
      
      if (!assessmentProvider.isTimerRunning) {
        timer.cancel();
        return;
      }
      
      final newRemainingTime = Duration(
        seconds: assessmentProvider.remainingTime.inSeconds - 1,
      );
      
      assessmentProvider.updateTimer(newRemainingTime);
      
      // Auto-submit when time runs out
      if (newRemainingTime.inSeconds <= 0) {
        timer.cancel();
        _submitAssessment();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<AssessmentProvider>(
            builder: (context, provider, child) {
              if (provider.currentAssessment == null) {
                return const Text('Assessment');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.currentAssessment!.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    'Question ${provider.currentQuestionIndex + 1} of ${provider.totalQuestions}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitConfirmation,
          ),
          actions: [
            Consumer<AssessmentProvider>(
              builder: (context, provider, child) {
                if (!provider.isTimerRunning) return const SizedBox.shrink();
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: provider.remainingTime.inMinutes < 5
                        ? theme.colorScheme.errorContainer
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: provider.remainingTime.inMinutes < 5
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(provider.remainingTime),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: provider.remainingTime.inMinutes < 5
                              ? theme.colorScheme.onErrorContainer
                              : theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<AssessmentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading assessment...'),
                  ],
                ),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to Load Assessment',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('Go Back'),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            onPressed: _startAssessment,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.currentQuestion == null) {
              return const Center(
                child: Text('No questions available'),
              );
            }

            return Column(
              children: [
                // Progress bar
                AssessmentProgressBar(
                  progress: provider.progress,
                  answeredCount: provider.answeredCount,
                  totalQuestions: provider.totalQuestions,
                ),
                
                // Question content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: QuestionCard(
                      question: provider.currentQuestion!,
                      userAnswer: provider.getAnswerForQuestion(
                        provider.currentQuestion!.id,
                      ),
                      onAnswerChanged: (answer) {
                        provider.submitAnswer(answer);
                      },
                    ),
                  ),
                ),
                
                // Navigation buttons
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: _buildNavigationButtons(provider),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(AssessmentProvider provider) {
    return Row(
      children: [
        // Previous button
        if (provider.hasPreviousQuestion)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: provider.goToPreviousQuestion,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
          )
        else
          const Spacer(),
        
        const SizedBox(width: 16),
        
        // Next/Submit button
        Expanded(
          flex: 2,
          child: _isSubmitting
              ? const Center(child: CircularProgressIndicator())
              : FilledButton.icon(
                  onPressed: provider.isCurrentQuestionAnswered
                      ? () => _handleNext(provider)
                      : null,
                  icon: Icon(
                    provider.hasNextQuestion 
                        ? Icons.arrow_forward 
                        : Icons.check,
                  ),
                  label: Text(
                    provider.hasNextQuestion 
                        ? 'Next' 
                        : 'Submit Assessment',
                  ),
                ),
        ),
      ],
    );
  }

  void _handleNext(AssessmentProvider provider) {
    if (provider.hasNextQuestion) {
      provider.goToNextQuestion();
    } else {
      _showSubmitConfirmation();
    }
  }

  void _showSubmitConfirmation() {
    final provider = Provider.of<AssessmentProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submit Assessment?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to submit your assessment?'),
            const SizedBox(height: 12),
            Text(
              'Answered: ${provider.answeredCount}/${provider.totalQuestions} questions\n'
              'Remaining time: ${_formatTime(provider.remainingTime)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (provider.answeredCount < provider.totalQuestions) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Warning: You have ${provider.totalQuestions - provider.answeredCount} unanswered questions. These will be marked as incorrect.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitAssessment();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Assessment?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost and you won\'t be able to resume this assessment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _exitAssessment();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _exitAssessment() {
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    assessmentProvider.stopTimer();
    assessmentProvider.resetAssessment();
    context.pop();
  }

  Future<void> _submitAssessment() async {
    setState(() => _isSubmitting = true);
    
    try {
      final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
      final resultProvider = Provider.of<AssessmentResultProvider>(context, listen: false);
      
      assessmentProvider.stopTimer();
      
      // Submit to result provider
      await resultProvider.submitAssessment(
        assessmentId: widget.assessmentId,
        userId: 'current_user', // Replace with actual user ID
        userAnswers: assessmentProvider.userAnswers,
        startTime: assessmentProvider.assessmentStartTime ?? DateTime.now(),
      );

      if (mounted && resultProvider.result != null) {
        // Navigate to result screen
        context.pushReplacement(
          '/dashboard/assessment/result/${widget.assessmentId}',
        );
      } else if (mounted && resultProvider.error != null) {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultProvider.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _submitAssessment,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit assessment: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _submitAssessment,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
