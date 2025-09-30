// ASSUMPTION: Uses simple TextFormFields; replace with AppTextField when available.

import 'package:flutter/material.dart';
import 'package:cdax_app/core/widgets/app_text_field.dart';
import 'package:cdax_app/core/widgets/app_button.dart';

class ContactFormWidget extends StatefulWidget {
  const ContactFormWidget({super.key, required this.onSubmit});
  final Future<void> Function({required String name, required String email, required String message}) onSubmit;

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TODO: replace mock onSubmit with real API
          AppTextField(controller: _nameCtrl, labelText: 'Name', validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
          const SizedBox(height: 8),
          AppTextField(controller: _emailCtrl, labelText: 'Email', validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null),
          const SizedBox(height: 8),
          AppTextField(controller: _msgCtrl, labelText: 'Message', maxLines: 4, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
          const SizedBox(height: 12),
          AppButton(
            onPressed: _submitting
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() => _submitting = true);
                    await widget.onSubmit(
                      name: _nameCtrl.text.trim(),
                      email: _emailCtrl.text.trim(),
                      message: _msgCtrl.text.trim(),
                    );
                    if (mounted) setState(() => _submitting = false);
                  },
            label: _submitting ? 'Sending...' : 'Send',
          ),
        ],
      ),
    );
  }
}


