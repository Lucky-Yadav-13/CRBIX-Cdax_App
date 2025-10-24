import 'dart:async';
import 'package:flutter/material.dart';

/// Styled button used across the app.
/// onPressed can be sync or async; async errors are caught to avoid unhandled exceptions.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.text,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
    this.isStyled = false,
  });

  final String? label; // preferred param
  final String? text; // backward-compatible
  final FutureOr<void> Function()? onPressed;
  final IconData? icon;
  final bool isExpanded;
  final bool isStyled;

  @override
  Widget build(BuildContext context) {
    final String? effectiveLabel = label ?? text;
    final bool enabled = onPressed != null;

    Future<void> handlePressed() async {
      if (onPressed == null) return;
      try {
        final result = onPressed!.call();
        if (result is Future) {
          await result.catchError((_) {});
        }
      } catch (_) {
        // swallow to avoid red screens; surface via error reporting later
      }
    }

    if (isStyled) {
      final Widget buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (effectiveLabel != null) ...[
            Text(
              effectiveLabel,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) const SizedBox(width: 8),
          ],
          if (icon != null)
            Icon(
              icon,
              color: Colors.black87,
              size: 20,
            ),
        ],
      );

      final Widget button = Opacity(
        opacity: enabled ? 1 : 0.6,
        child: IgnorePointer(
          ignoring: !enabled,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB), // Light blue background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: handlePressed,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: buttonChild,
                ),
              ),
            ),
          ),
        ),
      );

      if (isExpanded) {
        return SizedBox(width: double.infinity, child: button);
      }
      return button;
    }

    final Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        if (effectiveLabel != null) Text(effectiveLabel),
      ],
    );

    final Widget button = ElevatedButton(
      onPressed: enabled ? handlePressed : null,
      child: buttonChild,
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

