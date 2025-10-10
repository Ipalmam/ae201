import 'package:flutter/material.dart';
import 'package:ae201/widgets/audio_manager.dart';

class MusicSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> localizedStrings;

  const MusicSettingsWidget({super.key, required this.localizedStrings});

  @override
  State<MusicSettingsWidget> createState() => _MusicSettingsWidgetState();
}

class _MusicSettingsWidgetState extends State<MusicSettingsWidget> {
  bool _isMusicEnabled = AudioManager().isMusicEnabled;
  double _volume = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(25),
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.localizedStrings['music']?['title'] ?? 'Music Settings',
                style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: _isMusicEnabled,
                onChanged: (value) {
                  setState(() {
                    _isMusicEnabled = value;
                  });
                  AudioManager().toggleMusic(value);
                  if (value) {
                    AudioManager().playBackgroundLoop();
                  } else {
                    AudioManager().stopMusic();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              AudioManager().changeTrack('assets/audio/retro-game-synth_130bpm.wav');
            },
            child: const Text('Change to Synth Track'),
          ),
          ElevatedButton(
            onPressed: () {
              AudioManager().changeTrack('assets/audio/video-game-energetic-victory-mix_200bpm_C_major.wav');
            },
            child: const Text('Change to Victory Mix'),
          ),
          const SizedBox(height: 16),
          Text(
            widget.localizedStrings['music']?['volume'] ?? 'Volume',
            style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(_volume * 100).toInt()}%',
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
              AudioManager().setVolume(value);
            },
          ),
        ],
      ),
    );
  }
}