import 'package:flutter/material.dart';
import '../../../models/assessment/assessment_model.dart';

class AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onStartAssessment;

  const AssessmentCard({
    super.key,
    required this.assessment,
    required this.onStartAssessment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onStartAssessment,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and difficulty
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Assessment icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(assessment.difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(assessment.category),
                      color: _getDifficultyColor(assessment.difficulty),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Title and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assessment.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assessment.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(assessment.difficulty),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      assessment.difficulty,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                assessment.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Assessment details
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.access_time,
                    label: '${assessment.duration} min',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.quiz,
                    label: '${assessment.totalQuestions} questions',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.grade,
                    label: '${assessment.passingScore}% to pass',
                    theme: theme,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Action button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onStartAssessment,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Assessment'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mobile development':
        return Icons.phone_android;
      case 'programming language':
        return Icons.code;
      case 'design':
        return Icons.design_services;
      case 'backend integration':
        return Icons.api;
      default:
        return Icons.quiz;
    }
  }
}