// lib/widgets/shared/visual_factory.dart

import 'package:flutter/material.dart';
import '../../theme/game_palettes.dart'; // Importamos la paleta para usar el tipo UiPalette

/// 🔑 INTERFAZ ABSTRACTA: Define un contrato para la construcción de widgets
/// específicos de estilo (PixelArt o Aesthetic).
///
/// La mejora clave es eliminar 'BuildContext context' de los métodos
/// que solo necesitan el color/estilo, ya que el StyleManager proporciona
/// la paleta actual (UiPalette) directamente.
abstract class VisualFactory {
  // ----------------------------------------------------------------------
  // MÉTODOS REQUERIDOS
  // ----------------------------------------------------------------------

  // Construye un botón de navegación estándar.
  // **Mantenemos BuildContext** porque el botón a menudo necesita hacer un
  // 'context.read<StyleManager>().setPalette()' o usar Theme.of(context).
  Widget buildNavButton({
    required BuildContext context,
    required Widget child,
    required bool active,
    required VoidCallback onTap,
  });

  // Construye un contenedor temático que puede usarse alrededor de íconos/etiquetas.
  // **Mantenemos BuildContext** por si la implementación necesita usar Theme.of(context)
  // para obtener la fuente o el ThemeData.
  Widget buildIconContainer({
    required BuildContext context,
    required Widget child,
    required bool active,
  });

  // Construye el contenedor o wrapper de la barra de navegación.
  Widget buildNavBarShell({
    required BuildContext context,
    required Widget child,
  });

  // Construye el botón de ajustes (SettingsButton).
  // Es mejor pasar la paleta si solo necesita colores, pero
  // **mantenemos BuildContext** por si el botón necesita lógica de navegación o Provider.
  Widget buildSettingsButton({required BuildContext context});

  // Construye el contenedor del panel de ajustes.
  // **Mantenemos BuildContext** por la misma razón anterior.
  Widget buildSettingsContainer({
    required BuildContext context, // Añadimos context para acceso a Provider/ThemeData
    required Widget child
  });
  
  // ----------------------------------------------------------------------
  // PROPIEDADES DE ESTILO
  // ----------------------------------------------------------------------

  // Devuelve el color apropiado para íconos/texto en el estado activo/inactivo.
  // **Mejora:** Ahora requiere la paleta (UiPalette) en lugar de BuildContext.
  Color iconColor(UiPalette palette, bool active);

  // Altura fija de la barra de navegación para este estilo.
  double get navHeight;
}