import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LanguageSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> localizedStrings;

  const LanguageSettingsScreen({super.key, required this.localizedStrings});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final supportedLanguages = ['en', 'es', 'zh', 'ja', 'ko', 'de', 'fr', 'hi', 'ar'];
  String? selectedLanguage;
  final TextEditingController _nameController = TextEditingController();
  bool isEditingName = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? user?.email ?? 'Unknown';
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    });
  }

  Future<void> _updateLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', code);
    setState(() => selectedLanguage = code);
  }

  Future<void> _updateDisplayName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && newName.isNotEmpty) {
      await user.updateDisplayName(newName);
      setState(() {
        isEditingName = false;
        _nameController.text = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.localizedStrings['menu']?['language'] ?? 'Language & Session';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.purpleAccent)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logged in as:', style: const TextStyle(color: Colors.purpleAccent)),
            GestureDetector(
              onTap: () => setState(() => isEditingName = true),
              child: isEditingName
                  ? TextField(
                      controller: _nameController,
                      autofocus: true,
                      onSubmitted: _updateDisplayName,
                      decoration: InputDecoration(
                        hintText: 'Enter new username',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _updateDisplayName(_nameController.text),
                        ),
                      ),
                    )
                  : Text(_nameController.text, style: const TextStyle(color: Colors.purpleAccent)),
            ),
            const SizedBox(height: 24),
            Text('Language:', style: const TextStyle(color: Colors.purpleAccent)),
            DropdownButton<String>(
              value: selectedLanguage,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.purpleAccent),
              items: supportedLanguages.map((code) {
                return DropdownMenuItem(value: code, child: Text(code.toUpperCase()));
              }).toList(),
              onChanged: (newCode) {
                if (newCode != null) _updateLanguage(newCode);
              },
            ),
          ],
        ),
      ),
    );
  }
}