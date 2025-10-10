import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme/aesthetic_pallete.dart';

/// Thin 2px rotating two-color border (clockwise) using palette.accent and palette.highlight.
/// Keeps the same visual weight as `Border.all(color: accent, width: 2)` but replaces the solid
/// color with a rotating gradient along the single thin stroke.
class AestheticContainer extends StatefulWidget {
  final Widget? child;
  final UiPalette? palette;
  final String? paletteName;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool elevated;

  const AestheticContainer({
    super.key,
    this.child,
    this.palette,
    this.paletteName,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.borderRadius,
    this.onTap,
    this.elevated = true,
  });

  UiPalette get _effectivePalette {
    if (palette != null) return palette!;
    if (paletteName != null) return getAestheticByName(paletteName!);
    return getAestheticByName('Dark Academia');
  }

  @override
  State<AestheticContainer> createState() => _AestheticContainerState();
}

class _AestheticContainerState extends State<AestheticContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  static const double _stroke = 2.0; // match original Border.all width
  static const double _outerInset = _stroke / 2; // ensure stroke is centered inside bounds

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200), // adjust speed if desired
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant AestheticContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_ctrl.isAnimating) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  BorderRadius _resolvedRadius(BuildContext ctx) =>
      (widget.borderRadius ?? BorderRadius.circular(12)).resolve(Directionality.of(ctx));

  @override
  Widget build(BuildContext context) {
    final UiPalette p = widget._effectivePalette;
    final Color surface = p.neutral;
    final Color accent = p.accent;
    final Color highlight = p.highlight;
    final Color edge = p.primary;
    final Color textColor = p.text;
    final BorderRadius resolvedRadius = _resolvedRadius(context);

    final base = Container(
      width: widget.width,
      height: widget.height,
      // leave original padding for content; stroke is drawn inside ClipRRect so we inset child slightly
      padding: widget.padding,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: resolvedRadius,
        boxShadow: widget.elevated
            ? [
                BoxShadow(
                  color: edge.withAlpha((0.06 * 255).round()),
                  offset: const Offset(0, 6),
                  blurRadius: 18,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: accent.withAlpha(36),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: textColor, fontSize: 14),
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );

    final painted = AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final double rotation = _ctrl.value * 2 * math.pi;
        return ClipRRect(
          borderRadius: resolvedRadius,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              // Content is inset slightly so the thin stroke sits centered on the edge visually identical to Border.all
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(_outerInset),
                  child: base,
                ),
              ),
              // Foreground painter draws the thin rotating gradient stroke on top of the content
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ThinRotatingGradientBorderPainter(
                      rotation: rotation,
                      accent: accent,
                      highlight: highlight,
                      borderRadius: resolvedRadius,
                      strokeWidth: _stroke,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    final wrapped = Padding(padding: widget.margin, child: RepaintBoundary(child: painted));

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, behavior: HitTestBehavior.translucent, child: wrapped);
    }
    return wrapped;
  }
}

class _ThinRotatingGradientBorderPainter extends CustomPainter {
  final double rotation; // radians clockwise
  final Color accent;
  final Color highlight;
  final BorderRadius borderRadius;
  final double strokeWidth;

  _ThinRotatingGradientBorderPainter({
    required this.rotation,
    required this.accent,
    required this.highlight,
    required this.borderRadius,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    // Draw the stroke centered on the edge; deflate by half stroke to keep it inside the clip
    final RRect drawRRect = rrect.deflate(strokeWidth / 2);

    // Create a SweepGradient with accent and highlight adjacent.
    final SweepGradient sweep = SweepGradient(
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: [
        accent,
        Color.lerp(accent, highlight, 0.5)!,
        highlight,
        Color.lerp(highlight, accent, 0.5)!,
        accent,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(rotation),
      tileMode: TileMode.repeated,
    );

    final Shader shader = sweep.createShader(drawRRect.outerRect);

    final Paint paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;

    canvas.drawRRect(drawRRect, paint);
  }

  @override
  bool shouldRepaint(covariant _ThinRotatingGradientBorderPainter old) {
    return old.rotation != rotation ||
        old.accent != accent ||
        old.highlight != highlight ||
        old.borderRadius != borderRadius ||
        old.strokeWidth != strokeWidth;
  }
}