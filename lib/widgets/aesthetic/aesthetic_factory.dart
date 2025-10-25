// lib/widgets/aesthetic/aesthetic_factory.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Necesario para acceder a StyleManager en los botones
import '../shared/visual_factory.dart';
import '../../theme/game_palettes.dart'; // 🔑 Importación UNIFICADA (asumimos que la creaste)
import '../../widgets/aesthetic/aesthetic_button.dart';
import '../../widgets/aesthetic/aesthetic_container.dart';

// NOTA: Usamos 'UiPalette' de la importación unificada 'game_palettes.dart'
// Si mantienes tu archivo 'aesthetic_pallete.dart' separado, ajusta la importación
// y asegúrate de que UiPalette incluye los campos 'disabledSurface' y 'disabledText'.

class AestheticFactory implements VisualFactory {
  // 🔑 Eliminamos la propiedad 'palette' del constructor.
  // La Factoría es ahora un singleton sin estado, y la paleta se pasa en los métodos.
  // La instancia de esta factoría se crea UNA VEZ en main.dart y se registra en StyleManager.
  final double _navHeight; // backing field for the navHeight getter

  const AestheticFactory({
    double navHeight = 80.0,
  }) : _navHeight = navHeight;

  @override
  double get navHeight => _navHeight;

  // ----------------------------------------------------------------------
  // IMPLEMENTACIÓN DE WIDGETS
  // ----------------------------------------------------------------------

  @override
  Widget buildNavButton({
    required BuildContext context,
    required Widget child,
    required bool active,
    required VoidCallback onTap,
  }) {
    // Aquí puedes usar context.read<StyleManager>().currentPalette para colores si fuera necesario,
    // pero el widget 'child' ya debería contener el color correcto (ej. IconTheme).
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: navHeight,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget buildIconContainer({
    required BuildContext context,
    required Widget child,
    required bool active,
  }) {
    // Si el StyleManager estuviera disponible, podríamos usarlo aquí, pero
    // confiamos en que el widget que llama a este método tiene acceso al color.
    // Para simplificar, usamos Theme.of(context) que ya contiene los colores
    // de la paleta gracias a StyleManager.themeData.
    final palette = Theme.of(context).colorScheme;
    return IconTheme(
      data: IconThemeData(
        color: active ? palette.secondary : palette.onSurface.withOpacity(0.6), // Usamos ColorScheme
        size: 24,
      ),
      child: child,
    );
  }

  @override
  Widget buildNavBarShell({
    required BuildContext context,
    required Widget child,
  }) {
    // Usa AestheticContainer para el fondo de la barra de navegación.
    return SafeArea(
      top: false,
      bottom: true,
      child: SizedBox(
        height: navHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AestheticContainer(
            // Asumimos que AestheticContainer toma su color del tema (StyleManager)
            height: navHeight,
            child: child,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // IMPLEMENTACIÓN DE PROPIEDADES DE ESTILO Y SETTINGS
  // ----------------------------------------------------------------------

  /// 🔑 CORRECCIÓN CLAVE: Debe coincidir con la nueva interfaz de VisualFactory
  @override
  Color iconColor(UiPalette palette, bool active) => active ? palette.highlight : palette.text;

  @override
  Widget buildSettingsButton({required BuildContext context}) =>
      AestheticButton(label: "Settings", onPressed: () {
        // Implementación de navegación a Settings (generalmente usa Provider aquí)
        // Ejemplo: context.read<UiSoundService>().playButton();
      });

  @override
  Widget buildSettingsContainer({required BuildContext context, required Widget child}) {
    return AestheticContainer(child: child);
  }
}