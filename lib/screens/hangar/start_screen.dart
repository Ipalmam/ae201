// lib/screens/hangar/start_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importaciones de tus servicios y temas
import '../../services/localization_service.dart';
import '../../services/style_manager.dart'; 
import '../../theme/game_palettes.dart'; 
import '../hangar/settings_screen.dart'; // Importamos, por si quieres mantener la navegación

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 🔑 OBTENCIÓN DE SERVICIOS (WATCH para reconstrucción automática)
    final loc = context.watch<LocalizationService>();
    final styleManager = context.watch<StyleManager>(); 
    
    // ESTADO ACTUAL
    final currentStyle = styleManager.currentStyle;
    final currentPalette = styleManager.currentPalette;
    
    // TRADUCCIONES
    final screenTitle = loc.t('menu.main_menu', fallback: 'Main Menu');
    final styleLabel = loc.t('settings.visual_style', fallback: 'Visual Style');
    final paletteLabel = loc.t('settings.color_palette', fallback: 'Color Palette');
    
    // LISTA DINÁMICA DE PALETAS
    final availablePalettes = allStylePalettes[currentStyle] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [
          // 🔑 BOTÓN DE AJUSTES (Mantenemos la navegación a la pantalla si existe)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegará a la pantalla de ajustes real (SettingsScreen)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: loc.t('menu.settings', fallback: 'Settings'),
          ),
        ],
      ),
      body: Center(
        child: ListView( // Usamos ListView para hacer el contenido desplazable
          padding: const EdgeInsets.all(24.0),
          children: [
            // Texto de bienvenida simple (para confirmar que estamos aquí)
            Text(
              loc.t('messages.start_screen_welcome', fallback: 'Welcome to Aztec Eagles 201'),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // --------------------------------------------------------
            // A) SELECTOR DE ESTILO VISUAL (SegmentedButton)
            // --------------------------------------------------------
            Text(styleLabel, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Center(
              child: SegmentedButton<VisualStyle>(
                segments: VisualStyle.values.map((style) {
                  return ButtonSegment<VisualStyle>(
                    value: style,
                    label: Text(loc.t('styles.${style.name}', fallback: style.name)), 
                  );
                }).toList(),
                
                selected: {currentStyle}, 

                onSelectionChanged: (newSelection) {
                  styleManager.setStyle(newSelection.first);
                },
              ),
            ),
            
            const Divider(height: 48),

            // --------------------------------------------------------
            // B) SELECTOR DE PALETA DE COLORES (Wrap con Color Swatches)
            // --------------------------------------------------------
            Text(paletteLabel, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: availablePalettes.map((palette) {
                final isSelected = palette.name == currentPalette.name;
                
                return GestureDetector(
                  onTap: () {
                    styleManager.setPalette(palette);
                  },
                  child: Tooltip( 
                    message: palette.name,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: palette.primary, 
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                          width: isSelected ? 4.0 : 2.0,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            blurRadius: 6,
                          )
                        ] : [],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const Divider(height: 48),

            // --------------------------------------------------------
            // C) BOTÓN DE JUGAR (Para verificar que el estilo cambió)
            // --------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Lógica del juego
                },
                child: Text(loc.t('buttons.play', fallback: 'PLAY')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}