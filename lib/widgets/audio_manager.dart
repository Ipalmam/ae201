import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _musicEnabled = true;
  double _currentVolume = 1.0;

  // ✅ Getter for external access
  double get currentVolume => _currentVolume;
  bool get isMusicEnabled => _musicEnabled;

  // ✅ Load volume from SharedPreferences
  Future<void> loadVolume() async {
    final prefs = await SharedPreferences.getInstance();
    _currentVolume = prefs.getDouble('volume') ?? 1.0;
    await _player.setVolume(_currentVolume);
    debugPrint('Loaded volume: ${(_currentVolume * 100).toInt()}%');
  }

  // ✅ Set volume and persist it
  Future<void> setVolume(double value) async {
    _currentVolume = value;
    await _player.setVolume(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
    debugPrint('Volume set to ${(_currentVolume * 100).toInt()}%');
  }

  // ✅ Toggle music on/off
  void toggleMusic(bool enabled) {_musicEnabled = enabled;}

  // ✅ Play startup music
  Future<void> playStartupMusic() async {
    if (!_musicEnabled) return;
    await _player.setAsset('assets/audio/retro-game-synth_130bpm.wav');
    await _player.play();
  }

  // ✅ Loop background music
  Future<void> playBackgroundLoop() async {
    if (!_musicEnabled) return;
    await _player.setAsset('assets/audio/video-game-energetic-victory-mix_200bpm_C_major.wav');
    await _player.setLoopMode(LoopMode.one);
    await _player.play();
  }

  // ✅ Stop music
  void stopMusic() => _player.stop();

  // ✅ Change track with fade transition
  Future<void> changeTrack(String assetPath) async {
    if (!_musicEnabled) return;

    // Fade out
    await _player.setVolume(0.0);
    await Future.delayed(const Duration(milliseconds: 300));

    await _player.setAsset(assetPath);
    await _player.setLoopMode(LoopMode.one);
    await _player.play();

    // Fade in
    await _player.setVolume(_currentVolume);
  }
}