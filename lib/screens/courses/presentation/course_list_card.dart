// ASSUMPTION: Stateless card uses theme; taps navigate via context.go.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../courses/data/models/course.dart';

class CourseListCard extends StatelessWidget {
  const CourseListCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.go('/dashboard/courses/${course.id}'),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  course.thumbnailUrl,
                  width: 120,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(course.title, style: theme.textTheme.titleMedium),
                        ),
                        if (!course.isSubscribed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: theme.colorScheme.secondaryContainer,
                            ),
                            child: Text('Subscribe', style: theme.textTheme.labelSmall),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: course.progressPercent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


