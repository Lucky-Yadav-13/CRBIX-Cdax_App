import 'package:flutter/material.dart';

// ASSUMPTION: Backward-compatible wrapper over TextFormField supporting old and new params.
// - Accepts both label/labelText and hint/hintText.
// - Keeps a styled variant for specific UI needs.
// Examples:
// AppTextField(controller: c, labelText: 'Email');
// AppTextField(controller: c, label: 'Message', maxLines: 4);
// AppTextField(controller: c, hint: 'Search...');

/// Reusable text field wrapper over TextFormField with styling support.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.labelText,
    this.hint,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.isStyled = false,
  });

  final TextEditingController controller;
  final String? label; // friendly name
  final String? labelText; // backward-compatible
  final String? hint; // friendly name
  final String? hintText; // backward-compatible
  final IconData? icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool isStyled;

  @override
  Widget build(BuildContext context) {
    final String? effectiveLabel = labelText ?? label;
    final String? effectiveHint = hintText ?? hint;

    if (isStyled) {
      return Container(
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
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          textInputAction: textInputAction,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: effectiveLabel,
            hintText: effectiveHint,
            hintStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: Colors.black54,
                    size: 20,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: effectiveLabel,
        hintText: effectiveHint,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}

