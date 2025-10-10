import 'package:flutter/material.dart';

class LanguageConfirmScreen extends StatelessWidget {
  final Map<String, dynamic> localizedStrings;
  final VoidCallback onConfirm;
  final VoidCallback onChange;

  const LanguageConfirmScreen({
    super.key,
    required this.localizedStrings,
    required this.onConfirm,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final detected = localizedStrings['detected language'] ?? {};
    final title = detected['title'] ?? 'Detected Language';
    final message = detected['message'] ?? 'Do you want to continue in this language?';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: onConfirm, child: const Text('Confirm')),
            TextButton(onPressed: onChange, child: const Text('Change Language')),
          ],
        ),
      ),
    );
  }
}