// lib/theme/palette.dart

import 'package:flutter/material.dart';

/// Small immutable container describing a palette used by your UI widgets.
class UiPalette {
  final String name;
  final Color primary;     // main button/background accent
  final Color accent;      // border, highlight, or secondary accent
  final Color highlight;   // pressed/active or success accent
  final Color neutral;     // background or neutral surface
  final Color text;        // primary text color for contrast

  const UiPalette({
    required this.name,
    required this.primary,
    required this.accent,
    required this.highlight,
    required this.neutral,
    required this.text,
  });
}

/// Pixel Neon Retro (your requested pixel set)
const UiPalette pixelNeonRetro = UiPalette(
  name: 'Pixel Neon Retro',
  primary: Color(0xFF00AEEF),    // Electric Blue
  accent: Color(0xFFFF2D95),     // Hot Pink
  highlight: Color(0xFFB5FF00),  // Acid Green (pressed)
  neutral: Color(0xFF000000),    // Black
  text: Color(0xFFF6F6F8),       // Off-white for legibility
);

/// Miami Vice Pastel
const UiPalette miamiVicePastel = UiPalette(
  name: 'Miami Vice Pastel',
  primary: Color(0xFF6DD3D6),    // Pastel Teal
  accent: Color(0xFFFFB3A7),     // Peach
  highlight: Color(0xFFC9A9FF),  // Lavender
  neutral: Color(0xFFF6F6F8),    // Off-white
  text: Color(0xFF1E1E2F),       // Charcoal for contrast
);

/// Memphis Graphic
const UiPalette memphisGraphic = UiPalette(
  name: 'Memphis Graphic',
  primary: Color(0xFF0047AB),    // Cobalt
  accent: Color(0xFFFFD400),     // Lemon Yellow
  highlight: Color(0xFFD7263D),  // Crimson
  neutral: Color(0xFFFFFFFF),    // White
  text: Color(0xFF000000),       // Black text
);

/// Synthwave Sunset (gradient-friendly)
const UiPalette synthwaveSunset = UiPalette(
  name: 'Synthwave Sunset',
  primary: Color(0xFF6A00F4),    // Deep Purple
  accent: Color(0xFFFF357F),     // Magenta
  highlight: Color(0xFFFF8C42),  // Orange
  neutral: Color(0xFF1E1E2F),    // Charcoal
  text: Color(0xFFF6F6F8),       // Off-white
);

/// All palettes collected for lookup or iteration
final Map<String, UiPalette> palettes = {
  pixelNeonRetro.name: pixelNeonRetro,
  miamiVicePastel.name: miamiVicePastel,
  memphisGraphic.name: memphisGraphic,
  synthwaveSunset.name: synthwaveSunset,
};

/// Convenience: get palette by name (falls back to pixelNeonRetro)
UiPalette getPaletteByName(String name) =>
    palettes[name] ?? pixelNeonRetro;

/// Build a ThemeData from a UiPalette for quick app theming.
ThemeData themeFromPalette(UiPalette p) {
  final base = p.neutral.computeLuminance() > 0.5 ? ThemeData.light() : ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: p.neutral,
    colorScheme: base.colorScheme.copyWith(
      primary: p.primary,
      secondary: p.accent,
      surface: p.neutral,
      onPrimary: p.text,
      onSecondary: p.text,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: p.text,
      displayColor: p.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: p.text,
      ),
    ),
    iconTheme: IconThemeData(color: p.accent),
  );
}