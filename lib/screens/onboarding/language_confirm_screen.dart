// lib/screens/onboarding/language_confirm_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🔑 Necesario para acceder a los servicios inyectados.
import '../../services/localization_service.dart'; // El servicio que proporciona las traducciones.

/// Pantalla para confirmar el idioma detectado o cambiarlo.
///
/// Este widget ahora obtiene las cadenas de texto del LocalizationService
/// a través de Provider, eliminando la necesidad de pasarlas por constructor.
class LanguageConfirmScreen extends StatelessWidget {
  
  // Mantenemos los callbacks para la navegación/interacción.
  final VoidCallback onConfirm;
  final VoidCallback onChange;

  const LanguageConfirmScreen({
    super.key,
    // ❌ ELIMINAMOS: required this.localizedStrings (ya no se inyecta aquí).
    required this.onConfirm,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    // 🔑 Paso 1: Acceder al LocalizationService.
    // Usamos context.watch() para que el widget se redibuje si el idioma cambia.
    final loc = context.watch<LocalizationService>();
    
    // 🔑 Paso 2: Usar el método 't' (translate) del servicio para obtener las cadenas.
    // Utilizamos paths y valores por defecto (fallbacks) para mayor robustez.
    final title = loc.t('language_confirm.title', fallback: 'Detected Language');
    final message = loc.t('language_confirm.message', fallback: 'Do you want to continue in this language?');
    final confirmText = loc.t('global.confirm', fallback: 'Confirm');
    final changeText = loc.t('global.change_language', fallback: 'Change Language');

    return Scaffold(
      // El AppBar usará el tema definido por StyleManager.
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Estiramos los botones a lo ancho de la columna.
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              // Mensaje central de confirmación.
              Text(
                message, 
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall, // Ajuste el estilo si es necesario
              ),
              const SizedBox(height: 32),
              
              // Botón de Confirmación (usa el estilo de Elevated Button del tema)
              ElevatedButton(
                onPressed: onConfirm, 
                child: Text(confirmText),
              ),
              const SizedBox(height: 16),

              // Botón para cambiar idioma (usa el estilo de Text Button del tema)
              TextButton(
                onPressed: onChange, 
                child: Text(changeText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}