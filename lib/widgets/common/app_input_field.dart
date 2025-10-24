import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_constants.dart';

/// Standardized input field widget for CDAX App
/// Provides consistent input field styling throughout the app
class AppInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppInputField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  /// Factory constructor for password field
  const AppInputField.password({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  }) : obscureText = true,
       readOnly = false,
       onTap = null,
       keyboardType = TextInputType.visiblePassword,
       inputFormatters = null,
       maxLines = 1,
       maxLength = null,
       prefixIcon = const Icon(Icons.lock_outline),
       suffixIcon = null;

  /// Factory constructor for email field
  const AppInputField.email({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  }) : obscureText = false,
       readOnly = false,
       onTap = null,
       keyboardType = TextInputType.emailAddress,
       inputFormatters = null,
       maxLines = 1,
       maxLength = null,
       prefixIcon = const Icon(Icons.email_outlined),
       suffixIcon = null;

  /// Factory constructor for multiline field
  const AppInputField.multiline({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxLines = 3,
    this.maxLength,
    this.focusNode,
    this.onSubmitted,
  }) : obscureText = false,
       readOnly = false,
       onTap = null,
       keyboardType = TextInputType.multiline,
       inputFormatters = null,
       prefixIcon = null,
       suffixIcon = null,
       textInputAction = TextInputAction.newline;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _shakeController;
  late Animation<double> _focusAnimation;
  late Animation<double> _shakeAnimation;
  late FocusNode _internalFocusNode;
  bool _isFocused = false;
  String? _previousErrorText;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
    _previousErrorText = widget.errorText;
  }

  @override
  void didUpdateWidget(AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger shake animation when error appears
    if (widget.errorText != null && 
        widget.errorText != _previousErrorText &&
        _previousErrorText == null) {
      _shakeController.reset();
      _shakeController.forward();
    }
    _previousErrorText = widget.errorText;
  }

  @override
  void dispose() {
    _focusController.dispose();
    _shakeController.dispose();
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
    
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_focusAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * 10 * (1 - _shakeAnimation.value), 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null) ...[
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: _isFocused ? 15 : 14,
                    fontWeight: FontWeight.w500,
                    color: _isFocused 
                        ? AppColors.primary
                        : (widget.errorText != null 
                            ? AppColors.error 
                            : AppColors.onSurface),
                  ),
                  child: Text(widget.label!),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: _isFocused 
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  validator: widget.validator,
                  obscureText: widget.obscureText,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  focusNode: _internalFocusNode,
                  textInputAction: widget.textInputAction,
                  onFieldSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    errorText: widget.errorText,
                    helperText: widget.helperText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon,
                    filled: true,
                    fillColor: widget.enabled ? AppColors.surface : AppColors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.error, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.error, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    helperStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
