import 'package:flutter/material.dart';
import 'package:ae201/widgets/music_settings_widget.dart';

class MusicSettingsScreen extends StatelessWidget {
  final Map<String, dynamic> localizedStrings;

  const MusicSettingsScreen({super.key, required this.localizedStrings});

  @override
  Widget build(BuildContext context) {
    final title = localizedStrings['menu']?['music'] ?? 'Music Settings';

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
            MusicSettingsWidget(localizedStrings: localizedStrings),
          ],
        ),
      ),
    );
  }
}