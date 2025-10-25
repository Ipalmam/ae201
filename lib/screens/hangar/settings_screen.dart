// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 🔑 Importaciones necesarias para la nueva arquitectura:
import '../../services/localization_service.dart'; 
import '../../services/style_manager.dart'; 
// Opcional: si la clase necesita los enums/paletas
import '../../theme/game_palettes.dart'; 


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar context.watch para acceder a los servicios.
    // El widget se reconstruirá si el idioma cambia.
    final loc = context.watch<LocalizationService>();
    
    // Puedes usar context.read o context.watch para StyleManager
    // dependiendo de si necesitas que el Scaffold se reconstruya con el estilo.
    // final styleManager = context.watch<StyleManager>(); 

    final title = loc.t('menu.settings', fallback: 'Settings');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          loc.t('messages.settings_placeholder', fallback: 'Aquí va el contenido de ajustes.'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}