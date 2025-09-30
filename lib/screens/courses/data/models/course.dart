// ASSUMPTION: Course model holds modules list; replace with DTO + mapper when backend arrives.

import 'package:flutter/foundation.dart';
import 'module.dart';

@immutable
class Course {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final double progressPercent; // 0..1
  final bool isSubscribed;
  final List<Module> modules;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.progressPercent,
    required this.isSubscribed,
    required this.modules,
  });
}


