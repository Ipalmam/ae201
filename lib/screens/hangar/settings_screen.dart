import 'package:flutter/material.dart';
import 'package:ae201/screens/settings/profile_settings_screen.dart';
import 'package:ae201/screens/settings/language_settings_screen.dart';
import 'package:ae201/screens/settings/music_settings_screen.dart';
import 'package:ae201/screens/settings/control_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> localizedStrings;

  const SettingsScreen({super.key, required this.localizedStrings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _purpleStop;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _purpleStop = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.localizedStrings['settings menu'] ?? {};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.localizedStrings['menu']?['settings'] ?? 'Settings',
          style: const TextStyle(color: Colors.purpleAccent),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _purpleStop,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(24),
                width: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, _purpleStop.value, 1.0],
                    colors: [Colors.black, Colors.purple, Colors.black],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNavButton(
                  context,
                  labels['button1'] ?? '🧑‍✈️ Profile Settings',
                  ProfileSettingsScreen(localizedStrings: widget.localizedStrings),
                ),
                _buildNavButton(
                  context,
                  labels['button2'] ?? '🌐 Language & Session',
                  LanguageSettingsScreen(localizedStrings: widget.localizedStrings),
                ),
                _buildNavButton(
                  context,
                  labels['button3'] ?? '🎵 Music Settings',
                  MusicSettingsScreen(localizedStrings: widget.localizedStrings),
                ),
                _buildNavButton(
                  context,
                  labels['button4'] ?? '⚙️ Control Settings',
                  ControlSettingsScreen(localizedStrings: widget.localizedStrings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.purpleAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 4,
          side: const BorderSide(color: Colors.purpleAccent, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)), // ✅ Squared corners
          ),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Text(label),
      ),
    );
  }
}