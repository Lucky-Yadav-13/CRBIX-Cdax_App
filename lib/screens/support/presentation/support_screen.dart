// ASSUMPTION: FAQs are static; contact submission shows SnackBar and calls mock.

import 'package:flutter/material.dart';

import 'contact_form_widget.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      ['How do I enroll in a course?', 'Open the course and tap Enroll.'],
      ['How to reset password?', 'Use Forgot Password on login.'],
      ['Can I learn offline?', 'Offline downloads coming soon.'],
      ['How to report an issue?', 'Use the contact form below.'],
      ['What is subscription?', 'Unlocks all premium modules.'],
      ['Refund policy?', 'Contact support within 14 days.'],
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('FAQs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...faqs.map((q) => ExpansionTile(title: Text(q[0]), children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(alignment: Alignment.centerLeft, child: Text(q[1])),
                )
              ])),
          const SizedBox(height: 16),
          Text('Contact us', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ContactFormWidget(
            onSubmit: ({required String name, required String email, required String message}) async {
              // Mock provider call placeholder
              await Future<void>.delayed(const Duration(milliseconds: 500));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent (mock)')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


