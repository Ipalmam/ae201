// lib/services/style_manager.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; 

// Importaciones Clave
import '../theme/game_palettes.dart'; // Define VisualStyle, UiPalette, allPalettes, themeFromPalette
import 'ui_sound_service.dart';      // Importamos el UiStyle { pixel, aesthetic }
import '../widgets/shared/visual_factory.dart';
import '../widgets/pixel/pixel_factory.dart';
import '../widgets/aesthetic/aesthetic_factory.dart';


// AYUDANTE: Mapear VisualStyle a UiStyle
// 🔑 CLAVE 1: Usamos VisualStyle.pixelArt
UiStyle _getUiStyleFromVisual(VisualStyle style) {
  return style == VisualStyle.pixelArt ? UiStyle.pixel : UiStyle.aesthetic;
}

/// Servicio central que gestiona el Estilo Visual y la Paleta de Color.
class StyleManager extends ChangeNotifier {
  static const _kStylePrefsKey = 'visual_style';
  static const _kPalettePrefsKeyPrefix = 'palette_name_'; 
  ThemeData get themeData => themeFromPalette(_currentPalette);
  final UiSoundService _soundService; 
  final SharedPreferences _prefs; 
  final Map<VisualStyle, VisualFactory> _registry; 

  // 🔑 CLAVE 2: Usamos VisualStyle.pixelArt para la inicialización
  VisualStyle _currentStyle = VisualStyle.pixelArt; 
  late UiPalette _currentPalette; 
  
  // GETTERS PÚBLICOS
  VisualStyle get currentStyle => _currentStyle;
  UiPalette get currentPalette => _currentPalette;
  VisualFactory get factory => _registry[_currentStyle]!; // Getter para la fábrica visual

  final Completer<void> _loadingCompleter = Completer<void>();
  Future<void> get loadingFuture => _loadingCompleter.future;

  StyleManager({
    required SharedPreferences prefs,
    required UiSoundService soundService, 
    Map<VisualStyle, VisualFactory>? registry,
  })  : _prefs = prefs,
        _soundService = soundService,
        _registry = registry ?? {
          // 🔑 CLAVE 3: Usamos VisualStyle.pixelArt en el registro de Factories
          VisualStyle.pixelArt:  PixelFactory(), 
          VisualStyle.aesthetic: const AestheticFactory(),
        } {
    _currentPalette = _findPaletteByName(null, _currentStyle);
  }
  
  // LÓGICA DE CARGA INICIAL (ASÍNCRONA)
  Future<void> load() async {
    // 1. Cargar Estilo preferido
    final styleName = _prefs.getString(_kStylePrefsKey);
    if (styleName != null) {
      _currentStyle = VisualStyle.values.firstWhere(
        (v) => v.name == styleName,
        // 🔑 CLAVE 4: Usamos VisualStyle.pixelArt como fallback
        orElse: () => VisualStyle.pixelArt, 
      );
    }
    
    // 2. Cargar Paleta preferida para el estilo actual
    final paletteName = _prefs.getString(_kPalettePrefsKeyPrefix + _currentStyle.name);
    _currentPalette = _findPaletteByName(paletteName, _currentStyle);
    
    // 3. Coordinar con el servicio de sonido
    _soundService.setStyle(_getUiStyleFromVisual(_currentStyle));

    if (!_loadingCompleter.isCompleted) {
      _loadingCompleter.complete();
    }
    notifyListeners();
  }
  
  // ----------------------------------------------------------------------
  // MÉTODOS PÚBLICOS PARA CAMBIAR EL ESTILO (CORRECCIÓN CLAVE)
  // ----------------------------------------------------------------------

  /// 1. Cambia el Estilo Visual (e.g., PixelArt a Aesthetic)
  Future<void> setStyle(VisualStyle style) async {
    if (_currentStyle == style) return;
    
    _currentStyle = style;
    
    // Al cambiar de estilo, cargar la paleta que estaba guardada para ese estilo 
    // o usar la paleta por defecto si no hay nada guardado.
    final savedPaletteName = _prefs.getString(_kPalettePrefsKeyPrefix + style.name);
    _currentPalette = _findPaletteByName(savedPaletteName, style);
    
    // Coordinación: Notificar al servicio de sonido
    _soundService.setStyle(_getUiStyleFromVisual(style));

    notifyListeners();
    await _prefs.setString(_kStylePrefsKey, style.name);
    // La paleta ya está guardada o se guardará si se selecciona una.
  }

  /// 2. Cambia la Paleta de Color (Mantiene el Estilo Visual)
  Future<void> setPalette(UiPalette palette) async {
    // Si ya es la paleta actual, salir.
    if (_currentPalette.name == palette.name) return;

    // Prevención de errores: Asegúrate de que la paleta pertenezca al estilo actual
    final availablePalettes = allStylePalettes[_currentStyle] ?? <UiPalette>[];
    if (!availablePalettes.contains(palette)) return;
    
    _currentPalette = palette;
    
    notifyListeners();
    // Persistir la paleta usando la clave específica del estilo actual
    await _prefs.setString(_kPalettePrefsKeyPrefix + _currentStyle.name, palette.name);
  }
  
  // AYUDANTES PRIVADOS
  UiPalette _findPaletteByName(String? name, VisualStyle style) {
    // 🔑 CLAVE 5: Usamos VisualStyle.pixelArt como fallback
    final palettes = allStylePalettes[style] ?? allStylePalettes[VisualStyle.pixelArt]!; 
    return palettes.firstWhere(
      (p) => p.name == name,
      orElse: () => palettes.first, 
    );
  }
}