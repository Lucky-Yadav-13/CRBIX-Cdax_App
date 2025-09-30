// ASSUMPTION: Minimal row to display module with lock state.

import 'package:flutter/material.dart';
import '../../courses/data/models/module.dart';

class ModuleRow extends StatelessWidget {
  const ModuleRow({super.key, required this.module, this.onPlay});
  final Module module;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(module.isLocked ? Icons.lock : Icons.play_circle,
          color: module.isLocked ? theme.disabledColor : theme.colorScheme.primary),
      title: Text(module.title),
      subtitle: Text('${(module.durationSec / 60).round()} min'),
      trailing: module.isLocked
          ? TextButton(onPressed: () {}, child: const Text('Subscription required'))
          : IconButton(icon: const Icon(Icons.play_arrow), onPressed: onPlay),
    );
  }
}


