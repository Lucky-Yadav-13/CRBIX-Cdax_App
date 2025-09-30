// ASSUMPTION: Simple immutable model for a course module; ready for JSON hookup later.

import 'package:flutter/foundation.dart';

@immutable
class Module {
  final String id;
  final String title;
  final int durationSec;
  final bool isLocked;
  final String videoUrl; // placeholder for player

  const Module({
    required this.id,
    required this.title,
    required this.durationSec,
    required this.isLocked,
    required this.videoUrl,
  });
}


