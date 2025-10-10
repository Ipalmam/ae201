// lib/widgets/pixel_button.dart

import 'package:flutter/material.dart';
import '/services/ui_sound_service.dart';
import '../../theme/pixel_pallete.dart';

class PixelButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  /// Optional explicit palette instance to use for this button.
  final UiPalette? palette;

  /// Optional palette name to look up from pixel_palletes.dart.
  /// Ignored if [palette] is provided.
  final String? paletteName;

  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.palette,
    this.paletteName,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pressAnim;

  // Pixelified parameters
  static const Duration _pressDuration = Duration(milliseconds: 90);
  static const double _pressedScale = 0.92; // scale down when pressed
  static const int _pixelOffset = 2; // integer pixel offset for pressed look

  UiPalette get _effectivePalette {
    if (widget.palette != null) return widget.palette!;
    if (widget.paletteName != null) return getPaletteByName(widget.paletteName!);
    return pixelNeonRetro; // default palette
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _pressDuration);
    _pressAnim = CurvedAnimation(parent: _ctrl, curve: Curves.linear);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // helper to start a quick press animation
  Future<void> _doPressAnimation() async {
    try {
      await _ctrl.forward();
      await _ctrl.reverse();
    } catch (_) {
      // ignore if disposed mid-flight
    }
  }
  // integer-friendly transform: compute scale and offset using integer math
  Matrix4 _computeTransform(double t) {
    final rawScale = 1.0 - (1.0 - _pressedScale) * t;
    final steppedScale = (rawScale * 100).roundToDouble() / 100.0;
    final offset = (_pixelOffset * t).roundToDouble();
    // Translation matrix (x, y, z)
  final translation = Matrix4.translationValues(offset, offset, 0.0);
  // Scale matrix (sx, sy, sz)
  final scale = Matrix4.diagonal3Values(steppedScale, steppedScale, 1.0);
  // Apply translation then scale by multiplying matrices in order
  // If you want to scale first then translate, reverse the multiplication order.
  final matrix = translation * scale;
    return matrix;
  }

  Future<void> _handleTap() async {
    await UiSoundService.instance.playButtonAndAwaitStart();
    await _doPressAnimation();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _effectivePalette;
    // Pull colors from the selected palette
    final Color baseButtonColor = palette.primary;    // Electric Blue or chosen primary
    final Color baseOutlineColor = palette.accent;    // Hot Pink or chosen accent
    final Color pressedFillColor = palette.highlight; // Acid Green or chosen highlight
    final Color textColor = palette.accent;           // Use accent for text by default
    final Color glowColor = palette.accent.withAlpha(230);

    return AnimatedBuilder(
      animation: _pressAnim,
      builder: (context, child) {
        final t = _pressAnim.value;
        final transform = _computeTransform(t);
        final fillColor = Color.lerp(baseButtonColor, pressedFillColor, t)!;
        final outlineColor = baseOutlineColor;
        final shadowColor = glowColor.withAlpha((255 * (0.6 + 0.4 * t)).round());

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(color: outlineColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(2, 2),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) async {
          await _handleTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: AnimatedBuilder(
                  animation: _pressAnim,
                  builder: (context, _) {
                    final currentTextColor = textColor;
                    return Text(
                      widget.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 12,
                        color: currentTextColor,
                        letterSpacing: 1.5,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}