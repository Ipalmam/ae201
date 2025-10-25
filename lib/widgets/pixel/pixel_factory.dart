// lib/widgets/pixel/pixel_factory.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Añadido para futuras integraciones de Provider/StyleManager
import '../shared/visual_factory.dart';
import '../../theme/game_palettes.dart'; // Contiene la definición de UiPalette
import '../../widgets/pixel/pixel_button.dart';
import '../../widgets/pixel/pixel_container.dart';


class PixelFactory implements VisualFactory {
  // 🔑 CAMBIO 1: Eliminamos la propiedad 'palette'. La Factory es ahora sin estado (stateless).
  // final UiPalette palette; // <-- ELIMINADO

  final double liftAmount;
  final Duration animDuration;
  final Curve animCurve;
  final double _navHeight;

  // 🔑 CAMBIO 2: Eliminamos 'required this.palette' del constructor.
  PixelFactory({
    this.liftAmount = 8,
    this.animDuration = const Duration(milliseconds: 220),
    this.animCurve = Curves.easeOut,
    double navHeight = 64,
  }) : _navHeight = navHeight;

  @override
  double get navHeight => _navHeight;

  // ----------------------------------------------------------------------
  // IMPLEMENTACIÓN DE WIDGETS
  // ----------------------------------------------------------------------
  // NOTA: Los métodos build NavButton, IconContainer y NavBarShell utilizan
  // el ThemeData del contexto, que es inyectado por StyleManager.

  @override
  Widget buildNavButton({
    required BuildContext context,
    required Widget child,
    required bool active,
    required VoidCallback onTap,
  }) {
    // Obtenemos la paleta del tema actual (inyectado por StyleManager)
    final palette = Theme.of(context).colorScheme; // Usando ColorScheme para adaptarnos al Theme
    final Color bgColor = active ? palette.primary : Colors.transparent;
    final double effectiveLift = active ? -liftAmount : 0.0;
    
    // Usamos el accent para el borde, asumiendo que es el color 'highlight' del tema
    final borderLeft = BorderSide(color: palette.secondary.withAlpha(200), width: 1); 

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: animDuration,
          curve: animCurve,
          transform: Matrix4.translationValues(0, effectiveLift, 0),
          child: Container(
            height: navHeight,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(left: borderLeft),
            ),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: active ? 1.06 : 1.0),
                duration: animDuration,
                curve: animCurve,
                builder: (context, scale, _) {
                  return Transform.translate(
                    offset: Offset(0, effectiveLift),
                    child: Transform.scale(scale: scale, child: child),
                  );
                },
              ),
            ),
          ),
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
    return SizedBox(width: 36, height: 36, child: Center(child: child));
  }

  @override
  Widget buildNavBarShell({
    required BuildContext context,
    required Widget child,
  }) {
    // Usamos el tema inyectado por StyleManager
    final palette = Theme.of(context).colorScheme;
    return Container(
      height: navHeight,
      color: palette.surface, // neutral color
      child: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: palette.secondary, width: 2))), // highlight color
        child: child,
      ),
    );
  }
  
  // ----------------------------------------------------------------------
  // IMPLEMENTACIÓN DE PROPIEDADES DE ESTILO Y SETTINGS
  // ----------------------------------------------------------------------

  /// 🔑 CAMBIO 3: Actualizamos la firma para recibir la paleta.
  @override
  Color iconColor(UiPalette palette, bool active) => active ? palette.highlight : palette.text;

  /// 🔑 CAMBIO 4: Actualizamos la firma para recibir BuildContext.
  @override
  Widget buildSettingsButton({required BuildContext context}) =>
      PixelButton(label: "Settings", onPressed: () {
        // Lógica de audio/navegación a través de Provider/Context
        // Ejemplo: context.read<UiSoundService>().playButton();
      });

  /// 🔑 CAMBIO 5: Actualizamos la firma para recibir BuildContext.
  @override
  Widget buildSettingsContainer({required BuildContext context, required Widget child}) => PixelContainer(child: child);
}