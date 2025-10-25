// lib/services/ui_sound_service.dart

import 'dart:async';
import 'package:flutter/material.dart'; // Necesario para ChangeNotifier
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔑 CLAVE: El enum UiStyle. Debe estar aquí para que StyleManager lo importe.
enum UiStyle { pixel, aesthetic } 

/// Servicio que gestiona la reproducción de SFX (Sound Pool) y el volumen.
/// Extiende ChangeNotifier y NO es un Singleton.
class UiSoundService extends ChangeNotifier {
  // Config
  UiStyle _style = UiStyle.pixel;
  double _volume = 1.0;
  bool _muted = false;
  
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

  // 🔑 CONSTRUCTOR: Inicializa el pool aquí.
  UiSoundService() {
    _initPlayerPool();
  }

  // ----------------------------------------------------------------------
  // GETTERS y SETTERS
  // ----------------------------------------------------------------------
  double get volume => _volume;
  bool get isMuted => _muted;

  void setStyle(UiStyle style) {
    if (_style == style) return;
    _style = style;
    // No necesita notifyListeners, solo cambia la referencia para asset loading.
  }
  
  // ----------------------------------------------------------------------
  // LÓGICA DE CARGA/INICIALIZACIÓN
  // ----------------------------------------------------------------------

  Future<void> _initPlayerPool() async {
    for (int i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      // El volumen se ajusta en loadVolume()
      _players.add(player);
    }
  }

  /// 🔑 loadVolume reemplaza AudioManager.loadVolume()
  Future<void> loadVolume(SharedPreferences prefs) async {
    _volume = prefs.getDouble('sfx_volume') ?? 1.0;
    _muted = prefs.getBool('sfx_muted') ?? false;

    // Aplica volumen a los reproductores
    final effectiveVolume = _muted ? 0.0 : _volume;
    for (final p in _players) {
      await p.setVolume(effectiveVolume);
    }
    notifyListeners();
  }

  // ----------------------------------------------------------------------
  // LÓGICA DE REPRODUCCIÓN (playButtonAndAwaitStart está aquí)
  // ----------------------------------------------------------------------

  void play(String key) {
    if (_muted) return;
    final asset = _soundMap[_style]?[key];
    if (asset == null) return;

    final player = _nextPlayer();
    try {
      player.play(AssetSource(asset));
    } catch (_) {}
  }

  Future<void> playAndAwaitStart(String key) async {
    if (_muted) return;
    final asset = _soundMap[_style]?[key];
    if (asset == null) return;
    
    final player = _nextPlayer();
    try {
      await player.play(AssetSource(asset));
    } catch (_) {}
  }

  // Ayudantes de conveniencia (lo que los botones necesitan)
  void playButton() => play('button');
  Future<void> playButtonAndAwaitStart() => playAndAwaitStart('button'); 

  AudioPlayer _nextPlayer() {
    if (_players.isEmpty) return AudioPlayer(); // Fallback
    final p = _players[_roundRobinIndex % _players.length];
    _roundRobinIndex = (_roundRobinIndex + 1) % _players.length;
    return p;
  }

  @override
  void dispose() {
    for (final p in _players) {
      p.dispose();
    }
    super.dispose();
  }
}