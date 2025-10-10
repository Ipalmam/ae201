import 'package:flutter/material.dart';
/// Reuse the same UiPalette shape used in pixel_palletes.dart
/// If you already have UiPalette defined in pixel_palletes.dart, you can
/// import that type instead of redefining it here. This file keeps the
/// same structure so it's a drop-in for your palette system.
class UiPalette {
  final String name;
  final Color primary;   // main accent / surface color
  final Color accent;    // border / highlight / secondary accent
  final Color highlight; // pressed / active / success accent
  final Color neutral;   // background or neutral surface
  final Color text;      // primary text color for contrast
  const UiPalette({
    required this.name,
    required this.primary,
    required this.accent,
    required this.highlight,
    required this.neutral,
    required this.text,
  });
}
/// 1) Vaporwave / Vaporcore
/// Neon-magenta and cyan on dark backgrounds; strong synthwave vibe.
const UiPalette vaporwave = UiPalette(
  name: 'Vaporwave',
  primary: Color(0xFF6C00FF),   // deep purple
  accent: Color(0xFF00D0FF),    // cyan / electric
  highlight: Color(0xFFFF2D95), // magenta highlight
  neutral: Color(0xFF0B0B12),   // near-black background
  text: Color(0xFFF6F6F8),      // off-white
);

/// 2) Pastel Core / Soft Pastel
/// Soft, airy pastels for dreamy, gentle interfaces.
const UiPalette pastelCore = UiPalette(
  name: 'Pastel Core',
  primary: Color(0xFFBDE0FE),   // baby blue
  accent: Color(0xFFFFC8DD),    // soft pink
  highlight: Color(0xFFFFE29A), // warm pale yellow
  neutral: Color(0xFF0B0B12),   // near-black background
  text: Color(0xFF2E2E2E),      // soft charcoal
  
);

/// 3) Cottagecore / Earthy Pastoral
/// Warm, muted naturals and desaturated florals.
const UiPalette cottagecore = UiPalette(
  name: 'Cottagecore',
  primary: Color(0xFFB5C39E),   // sage green
  accent: Color(0xFFD9A57A),    // warm terracotta
  highlight: Color(0xFFF3E5AB), // dried flower yellow
  neutral: Color(0xFF0B0B12),   // near-black background
  text: Color(0xFF3B352A),      // deep brown
);

/// 4) Dark Academia
/// Moody, scholarly tones: deep browns, oxblood, parchment.
const UiPalette darkAcademia = UiPalette(
  name: 'Dark Academia',
  primary: Color(0xFF2E2A26),   // dark warm charcoal
  accent: Color(0xFF7A2F2F),    // oxblood / muted red
  highlight: Color(0xFFC9A16B), // aged gold / parchment
  neutral: Color(0xFF0B0B12),   // near-black background
  text: Color(0xFF0B0B0B),      // black for high contrast
);

/// Map of palettes for lookup or iteration
final Map<String, UiPalette> aestheticPalettes = {
  vaporwave.name: vaporwave,
  pastelCore.name: pastelCore,
  cottagecore.name: cottagecore,
  darkAcademia.name: darkAcademia,
};

/// Helper to retrieve by name, falling back to Pastel Core if not found
UiPalette getAestheticByName(String name) =>
    aestheticPalettes[name] ?? pastelCore;