import 'package:flutter/material.dart';

class ControlSettingsScreen extends StatelessWidget {
  final Map<String, dynamic> localizedStrings;

  const ControlSettingsScreen({super.key, required this.localizedStrings});

  @override
  Widget build(BuildContext context) {
    final title = localizedStrings['menu']?['controls'] ?? 'Control Settings';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.purpleAccent)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 🕹️ Add your control scheme widgets here
            const Text('Control scheme configuration coming soon...',
                style: TextStyle(color: Colors.purpleAccent)),
          ],
        ),
      ),
    );
  }
}