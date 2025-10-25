// lib/theme/game_palettes.dart
import 'package:flutter/material.dart';

// --------------------------------------------------------------------------
// CLASE DEL MODELO (UiPalette)
// --------------------------------------------------------------------------
/// Contenedor inmutable para una paleta de colores.
/// Se añade 'disabledSurface' y 'disabledText' para el manejo de estados deshabilitados.
class UiPalette {
  final String name;
  final Color primary;     // Color principal de botones, superficies activas
  final Color accent;      // Borde, resaltado secundario o acento
  final Color highlight;   // Botones presionados, éxito, o acento activo
  final Color neutral;     // Color de fondo o superficie neutra
  final Color text;        // Color primario del texto
  final Color disabledSurface; // NUEVO: Color de fondo para elementos deshabilitados
  final Color disabledText;    // NUEVO: Color de texto para elementos deshabilitados

  const UiPalette({
    required this.name,
    required this.primary,
    required this.accent,
    required this.highlight,
    required this.neutral,
    required this.text,
    required this.disabledSurface,
    required this.disabledText,
  });
}

// --------------------------------------------------------------------------
// PALETAS DE ESTILO "PIXEL ART"
// --------------------------------------------------------------------------

/// Pixel Neon Retro
const UiPalette pixelNeonRetro = UiPalette(
  name: 'Pixel Neon Retro',
  primary: Color(0xFF00AEEF),
  accent: Color(0xFFFF2D95),
  highlight: Color(0xFFB5FF00),
  neutral: Color(0xFF000000),
  text: Color(0xFFF6F6F8),
  // Colores Deshabilitados: Tonalidades oscuras para un tema oscuro
  disabledSurface: Color(0xFF222222), 
  disabledText: Color(0xFF555555),     
);

/// Miami Vice Pastel
const UiPalette miamiVicePastel = UiPalette(
  name: 'Miami Vice Pastel',
  primary: Color(0xFF6DD3D6),
  accent: Color(0xFFFFB3A7),
  highlight: Color(0xFFC9A9FF),
  neutral: Color(0xFFF6F6F8),
  text: Color(0xFF1E1E2F),
  // Colores Deshabilitados: Tonalidades claras para un tema claro
  disabledSurface: Color(0xFFCCCCCC),
  disabledText: Color(0xFF888888),
);

/// Memphis Graphic
const UiPalette memphisGraphic = UiPalette(
  name: 'Memphis Graphic',
  primary: Color(0xFF0047AB),
  accent: Color(0xFFFFD400),
  highlight: Color(0xFFD7263D),
  neutral: Color(0xFFFFFFFF),
  text: Color(0xFF000000),
  // Colores Deshabilitados: Tonalidades claras para un tema claro
  disabledSurface: Color(0xFFE0E0E0),
  disabledText: Color(0xFFAAAAAA),
);

/// Synthwave Sunset
const UiPalette synthwaveSunset = UiPalette(
  name: 'Synthwave Sunset',
  primary: Color(0xFF6A00F4),
  accent: Color(0xFFFF357F),
  highlight: Color(0xFFFF8C42),
  neutral: Color(0xFF1E1E2F),
  text: Color(0xFFF6F6F8),
  // Colores Deshabilitados: Tonalidades oscuras para un tema oscuro
  disabledSurface: Color(0xFF333344),
  disabledText: Color(0xFF666677),
);

// --------------------------------------------------------------------------
// PALETAS DE ESTILO "AESTHETIC / GEOMÉTRICO"
// --------------------------------------------------------------------------

/// Vaporwave / Vaporcore
const UiPalette vaporwave = UiPalette(
  name: 'Vaporwave',
  primary: Color(0xFF6C00FF),
  accent: Color(0xFF00D0FF),
  highlight: Color(0xFFFF2D95),
  neutral: Color(0xFF0B0B12),
  text: Color(0xFFF6F6F8),
  // Colores Deshabilitados: Tonalidades oscuras
  disabledSurface: Color(0xFF1A1A2A),
  disabledText: Color(0xFF4A4A66),
);

/// Pastel Core / Soft Pastel
const UiPalette pastelCore = UiPalette(
  name: 'Pastel Core',
  primary: Color(0xFFBDE0FE),
  accent: Color(0xFFFFC8DD),
  highlight: Color(0xFFFFE29A),
  neutral: Color(0xFFF6F6F8), // Cambiado a claro, si el texto es oscuro
  text: Color(0xFF2E2E2E),
  // Colores Deshabilitados: Tonalidades claras
  disabledSurface: Color(0xFFDCDCDC),
  disabledText: Color(0xFF888888),
);

/// Cottagecore / Earthy Pastoral
const UiPalette cottagecore = UiPalette(
  name: 'Cottagecore',
  primary: Color(0xFFB5C39E),
  accent: Color(0xFFD9A57A),
  highlight: Color(0xFFF3E5AB),
  neutral: Color(0xFFF6F6F8), // Cambiado a claro para seguir la lógica
  text: Color(0xFF3B352A),
  // Colores Deshabilitados: Tonalidades claras
  disabledSurface: Color(0xFFD8D8D8),
  disabledText: Color(0xFF999999),
);

/// Dark Academia
const UiPalette darkAcademia = UiPalette(
  name: 'Dark Academia',
  primary: Color(0xFF2E2A26),
  accent: Color(0xFF7A2F2F),
  highlight: Color(0xFFC9A16B),
  neutral: Color(0xFF0B0B12),
  text: Color(0xFFF6F6F8), // Ajustado a blanco/claro para contraste
  // Colores Deshabilitados: Tonalidades oscuras
  disabledSurface: Color(0xFF151515),
  disabledText: Color(0xFF404040),
);

// --------------------------------------------------------------------------
// MAPAS DE RECURSOS Y AYUDANTES
// --------------------------------------------------------------------------

/// Enumeración para distinguir entre los dos estilos visuales principales.
enum VisualStyle { pixelArt, aesthetic }

/// Colección de todas las paletas, categorizadas por estilo visual.
final Map<VisualStyle, List<UiPalette>> allStylePalettes = {
  VisualStyle.pixelArt: [
    pixelNeonRetro,
    miamiVicePastel,
    memphisGraphic,
    synthwaveSunset,
  ],
  VisualStyle.aesthetic: [
    vaporwave,
    pastelCore,
    cottagecore,
    darkAcademia,
  ],
};

/// Mapa de todas las paletas por su nombre (para usar en StyleManager)
final Map<String, UiPalette> allPalettes = {
  // Pixel Art
  pixelNeonRetro.name: pixelNeonRetro,
  miamiVicePastel.name: miamiVicePastel,
  memphisGraphic.name: memphisGraphic,
  synthwaveSunset.name: synthwaveSunset,
  
  // Aesthetic
  vaporwave.name: vaporwave,
  pastelCore.name: pastelCore,
  cottagecore.name: cottagecore,
  darkAcademia.name: darkAcademia,
};

ThemeData themeFromPalette(UiPalette p) {
  // NOTA: Esta es la implementación estándar para generar el tema.
  final base = p.neutral.computeLuminance() > 0.5 ? ThemeData.light() : ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: p.neutral,
    colorScheme: base.colorScheme.copyWith(
      primary: p.primary,
      secondary: p.accent,
      surface: p.neutral,
      onPrimary: p.text,
      onSecondary: p.text,
      // ... (añade más propiedades de colorScheme según necesites)
    ),
    textTheme: base.textTheme.apply(
      bodyColor: p.text,
      displayColor: p.text,
      fontFamily: 'RobotoMono', // o la fuente que uses
    ),
    // ... (otras propiedades de tema)
  );
}

/// Devuelve la paleta por defecto para un estilo (la primera de la lista).
UiPalette getDefaultPalette(VisualStyle style) {
  return allStylePalettes[style]?.first ?? pixelNeonRetro;
}