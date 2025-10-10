// lib/services/ui_sound_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum UiStyle { pixel, aesthetic }

class UiSoundService {
  UiSoundService._internal();

  static final UiSoundService instance = UiSoundService._internal();

  // Config
  UiStyle _style = UiStyle.pixel;
  double _volume = 1.0;
  bool _muted = false;
  bool _initialized = false;

  // Pool size tuned for short UI blips; adjust if you need more overlap
  final int _poolSize = 3;
  final List<AudioPlayer> _players = [];
  int _roundRobinIndex = 0;
  // Map logical sound keys to asset paths
  final Map<UiStyle, Map<String, String>> _soundMap = {
    UiStyle.pixel: {
      'button': 'audio/sounds/ui/pixelButtonSound.wav',
      'container': 'audio/sounds/ui/pixelContainerSound.wav',
    },
    UiStyle.aesthetic: {
      'button': 'audio/sounds/ui/aestheticButtonSound.wav',
      'container': 'audio/sounds/ui/aestheticContainerSound.wav',
    },
  };
  Future<void> init({double volume = 1.0}) async {
    if (_initialized) return;
    _volume = volume;
    // create and configure pool players
    for (var i = 0; i < _poolSize; i++) {
      final p = AudioPlayer();
      try {
        await p.setVolume(_volume);
      } catch (e) {
        debugPrint('UiSoundService: player.setVolume failed: $e');
      }
      _players.add(p);
    }
    _initialized = true;
    debugPrint('UiSoundService initialized with pool=$_poolSize volume=$_volume');
  }
//change sounds based on style
  void setStyle(UiStyle style) {
    _style = style;
    debugPrint('UiSoundService style set to $_style');
  }
  UiStyle get style => _style;
  void setVolume(double v) {
    _volume = v.clamp(0.0, 1.0);
    for (final p in _players) {
      p.setVolume(_volume);
    }
    debugPrint('UiSoundService volume set to $_volume');
  }
  void mute() {
    _muted = true;
    for (final p in _players) {
      p.setVolume(0.0);
    }
    debugPrint('UiSoundService muted');
  }
  void unmute() {
    _muted = false;
    for (final p in _players) {
      p.setVolume(_volume);
    }
    debugPrint('UiSoundService unmuted');
  }
  // Fire-and-forget low-latency play using pool. Does not await.
  void play(String key) {
    if (!_initialized) {
      debugPrint('UiSoundService.play called before init');
      return;
    }
    if (_muted) return;
    final asset = _soundMap[_style]?[key];
    if (asset == null) {
      debugPrint('UiSoundService: no asset for key=$key style=$_style');
      return;
    }
    final player = _nextPlayer();
    try {
      // start playback without awaiting completion
      player.play(AssetSource(asset));
    } catch (e) {
      debugPrint('UiSoundService.play failed: $e');
    }
  }
  // Await that the player started playing the asset. Useful when you need
  // to ensure playback started before navigation.
  Future<void> playAndAwaitStart(String key) async {
    if (!_initialized) {
      debugPrint('UiSoundService.playAndAwaitStart called before init');
      return;
    }
    if (_muted) return;
    final asset = _soundMap[_style]?[key];
    if (asset == null) {
      debugPrint('UiSoundService: no asset for key=$key style=$_style');
      return;
    }
    final player = _nextPlayer();
    try {
      await player.play(AssetSource(asset));
    } catch (e) {
      debugPrint('UiSoundService.playAndAwaitStart failed: $e');
    }
  }

  // Convenience helpers
  void playButton() => play('button');
  Future<void> playButtonAndAwaitStart() => playAndAwaitStart('button');

  void playContainer() => play('container');
  Future<void> playContainerAndAwaitStart() => playAndAwaitStart('container');

  AudioPlayer _nextPlayer() {
    if (_players.isEmpty) {
      // fallback: create ephemeral player if init was skipped
      final fallback = AudioPlayer();
      fallback.setVolume(_volume);
      return fallback;
    }
    final p = _players[_roundRobinIndex % _players.length];
    _roundRobinIndex = (_roundRobinIndex + 1) % _players.length;
    return p;
  }

  Future<void> dispose() async {
    for (final p in _players) {
      try {
        await p.dispose();
      } catch (e) {
        debugPrint('UiSoundService.dispose error: $e');
      }
    }
    _players.clear();
    _initialized = false;
    debugPrint('UiSoundService disposed');
  }
}