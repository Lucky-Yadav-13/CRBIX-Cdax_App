import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/assessment_result_provider.dart';
import '../../models/assessment/assessment_result_model.dart';
import 'widgets/result_summary.dart';

class AssessmentResultScreen extends StatefulWidget {
  final String assessmentId;

  const AssessmentResultScreen({
    super.key,
    required this.assessmentId,
  });

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _celebrationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.elasticOut,
    ));

    _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Consumer<AssessmentResultProvider>(
          builder: (context, provider, child) {
            if (provider.result == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading results...',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            final result = provider.result!;
            
            // Trigger celebration animation for passed results
            if (result.passed && _celebrationController.status == AnimationStatus.dismissed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _celebrationController.forward();
              });
            }

            return AnimatedBuilder(
              animation: _mainAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(_slideAnimation),
                    child: _buildResultContent(context, result, theme),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultContent(BuildContext context, AssessmentResult result, ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header section
            ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  // Result icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: result.passed 
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: result.passed 
                              ? AppColors.success 
                              : AppColors.error,
                        ),
                        child: Icon(
                          result.passed 
                              ? Icons.check_circle 
                              : Icons.cancel,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      if (result.passed)
                        AnimatedBuilder(
                          animation: _celebrationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_celebrationController.value * 0.3),
                              child: Opacity(
                                opacity: 1.0 - _celebrationController.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.success,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Result status
                  Text(
                    result.passed ? 'Congratulations!' : 'Better Luck Next Time!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: result.passed 
                          ? AppColors.success 
                          : AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    result.passed 
                        ? 'You have successfully completed the assessment!' 
                        : 'You didn\'t pass this time, but keep learning!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Result summary
            ResultSummary(result: result),
            
            const SizedBox(height: 32),
            
            // Performance message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Performance Review',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              result.performanceMessage,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Grade display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grade: ',
                        style: theme.textTheme.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getGradeColor(result.gradeLevel),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          result.gradeLevel,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Column(
              children: [
                if (result.passed) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _navigateToCertificate(result),
                      icon: const Icon(Icons.workspace_premium),
                      label: const Text('Get Certificate'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _reviewAnswers(result),
                    icon: const Icon(Icons.quiz),
                    label: const Text('Review Answers'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                if (!result.passed)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _retakeAssessment(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake Assessment'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _retakeAssessment(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake Assessment'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _goToHome(),
                    icon: const Icon(Icons.home),
                    label: const Text('Go to Dashboard'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Footer info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your assessment results are automatically saved. You can view them anytime from your profile.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.success;
      case 'B+':
      case 'B':
        return AppColors.info;
      case 'C+':
      case 'C':
        return AppColors.warning;
      case 'D':
        return AppColors.error;
      case 'F':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  void _navigateToCertificate(AssessmentResult result) {
    context.push('/dashboard/assessment/certificate/${widget.assessmentId}');
  }

  void _reviewAnswers(AssessmentResult result) {
    // TODO: Implement answer review screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Answer review feature coming soon!'),
      ),
    );
  }

  void _retakeAssessment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retake Assessment?'),
        content: const Text(
          'Are you sure you want to retake this assessment? Your current result will be replaced.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Clear current result and go back to assessment
              Provider.of<AssessmentResultProvider>(context, listen: false).clearResult();
              context.pushReplacement('/dashboard/assessment/question/${widget.assessmentId}');
            },
            child: const Text('Retake'),
          ),
        ],
      ),
    );
  }

  void _goToHome() {
    // Clear the result and go to dashboard
    Provider.of<AssessmentResultProvider>(context, listen: false).clearResult();
    context.go('/dashboard');
  }
}