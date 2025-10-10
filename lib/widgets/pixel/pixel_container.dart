import 'package:flutter/material.dart';
import '../../theme/pixel_pallete.dart';
/// PixelContainer: retro pixel-style container that uses a UiPalette.
/// - Defaults to 'Pixel Neon Retro' palette via getPaletteByName.
/// - Softer CRT flicker, scanline shimmer, and integer pixel-shift jitter.
class PixelContainer extends StatefulWidget {
  final Widget? child;
  final UiPalette? palette;
  final String? paletteName;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool enableFlicker;
  final bool enableScanline;
  final bool enableJitter;
  const PixelContainer({
    super.key,
    this.child,
    this.palette,
    this.paletteName,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.all(8),
    this.borderRadius,
    this.onTap,
    this.enableFlicker = true,
    this.enableScanline = true,
    this.enableJitter = true,
  });
  UiPalette get _effectivePalette {
    if (palette != null) return palette!;
    if (paletteName != null) return getPaletteByName(paletteName!);
    return getPaletteByName('Pixel Neon Retro');
  }
  @override
  State<PixelContainer> createState() => _PixelContainerState();
}
class _PixelContainerState extends State<PixelContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _flicker; // softer opacity pulses
  late final Animation<double> _scanPos; // scanline horizontal position
  late final Animation<double> _scanOpacity; // scanline alpha ramp
  late final Animation<int> _jitterX; // integer pixel X offset
  late final Animation<int> _jitterY; // integer pixel Y offset
  @override
  void initState() {
    super.initState();
    // Longer, gentler cycle for a soft CRT flicker and jitter timing
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    // Soft flicker: mostly steady near 1.0 with very subtle, smooth dips
    _flicker = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 72),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.97).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.97, end: 0.99).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.99, end: 0.96).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.96, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 6,
      ),
    ]).animate(_ctrl);
    // scan position moves left -> right in a loop; keep same timing as flicker
    _scanPos = Tween<double>(begin: -1.2, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)),
    );
    // scan opacity peaks near center of the shimmer for a soft ramp
    _scanOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.12), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: 0.06), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: 0.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)),
    );
    // Pixel jitter: intermittent integer offsets using TweenSequence of ConstantTween<int>
    final jitterSeqX = TweenSequence<int>([
      TweenSequenceItem(tween: ConstantTween<int>(0), weight: 76),
      TweenSequenceItem(tween: ConstantTween<int>(-2), weight: 6),
      TweenSequenceItem(tween: ConstantTween<int>(1), weight: 6),
      TweenSequenceItem(tween: ConstantTween<int>(0), weight: 12),
    ]);
    final jitterSeqY = TweenSequence<int>([
      TweenSequenceItem(tween: ConstantTween<int>(0), weight: 80),
      TweenSequenceItem(tween: ConstantTween<int>(1), weight: 6),
      TweenSequenceItem(tween: ConstantTween<int>(-1), weight: 6),
      TweenSequenceItem(tween: ConstantTween<int>(0), weight: 8),
    ]);
    _jitterX = jitterSeqX.animate(_ctrl);
    _jitterY = jitterSeqY.animate(_ctrl);
    if (widget.enableFlicker || widget.enableScanline || widget.enableJitter) {
      _ctrl.repeat();
    }
  }
  @override
  void didUpdateWidget(covariant PixelContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final want = widget.enableFlicker || widget.enableScanline || widget.enableJitter;
    if (want && !_ctrl.isAnimating) _ctrl.repeat();
    if (!want && _ctrl.isAnimating) _ctrl.stop();
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final p = widget._effectivePalette;
    // Palette roles
    final Color baseButtonColor = p.primary;
    final Color baseOutlineColor = p.accent;
    final Color pressedFillColor = p.highlight;
    final Color textColor = p.text;
    final Color glowColor = p.accent.withAlpha(230);
    Widget content() {
      final bool isFullyTransparent = baseButtonColor == const Color(0x00000000) || baseButtonColor == Colors.transparent;
      final Color fill = isFullyTransparent ? p.neutral : baseButtonColor;
      return Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: baseOutlineColor, width: 3),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: pressedFillColor.withAlpha((0.9 * 255).round()),
              offset: const Offset(2, 2),
              blurRadius: 0,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: glowColor.withAlpha((0.06 * 255).round()),
              offset: const Offset(0, 0),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: DefaultTextStyle(
          style: TextStyle(fontFamily: 'PressStart2P', fontSize: 12, color: textColor),
          child: widget.child ?? const SizedBox.shrink(),
        ),
      );
    }
    Widget withEffects(BuildContext context, Widget child) {
      return AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          // softer flicker clamped to a narrow readable range (0.92 - 1.0)
          final double flick = widget.enableFlicker ? _flicker.value.clamp(0.92, 1.0) : 1.0;
          // base content with flicker applied
          final base = Opacity(opacity: flick, child: child);
          // compute integer jitter offsets
          final int offsetX = widget.enableJitter ? _jitterX.value : 0;
          final int offsetY = widget.enableJitter ? _jitterY.value : 0;
          Widget stacked = base;
          // optionally overlay scanline shimmer
          if (widget.enableScanline) {
            stacked = Stack(
              fit: StackFit.passthrough,
              children: [
                base,
                Positioned.fill(
                  child: IgnorePointer(
                    child: FractionalTranslation(
                      translation: Offset(_scanPos.value, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withAlpha((_scanOpacity.value * 255).round()),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          backgroundBlendMode: BlendMode.overlay,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          // Apply integer pixel translation for jitter (avoid subpixel smoothing)
          return Transform.translate(
            offset: Offset(offsetX.toDouble(), offsetY.toDouble()),
            child: stacked,
          );
        },
        child: child,
      );
    }
    final core = content();
    final containerWithEffects = (widget.enableFlicker || widget.enableScanline || widget.enableJitter)
        ? withEffects(context, core)
        : core;
    final wrapped = widget.onTap != null
        ? GestureDetector(onTap: widget.onTap, child: RepaintBoundary(child: containerWithEffects))
        : RepaintBoundary(child: containerWithEffects);
    return wrapped;
  }
}