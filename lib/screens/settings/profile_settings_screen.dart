import 'package:flutter/material.dart';
import 'package:ae201/widgets/avatar_selector_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> localizedStrings;

  const ProfileSettingsScreen({super.key, required this.localizedStrings});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String selectedAvatar = 'assets/images/pilots/pixelArt/Adolf Galland.png';
  final TextEditingController _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final title = widget.localizedStrings['menu']?['profile'] ?? 'Profile Settings';

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
            AvatarSelectorWidget(
              localizedStrings: widget.localizedStrings,
              initialDisplayName: _displayNameController.text,
              onAvatarSelected: (avatarPath) {
                setState(() => selectedAvatar = avatarPath);
              },
              onDisplayNameChanged: (newName) {
                setState(() => _displayNameController.text = newName);
              },
            ),
          ],
        ),
      ),
    );
  }
}