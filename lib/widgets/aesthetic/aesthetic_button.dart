import 'package:flutter/material.dart';
import '/services/ui_sound_service.dart';
import '../../theme/aesthetic_pallete.dart';
class AestheticButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  final UiPalette? palette;
  final String? paletteName;
  const AestheticButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.palette,
    this.paletteName,
  });
  UiPalette get _effectivePalette {
    if (palette != null) return palette!;
    if (paletteName != null) return getAestheticByName(paletteName!);
    return getAestheticByName('Dark Academia');
  }
  @override
  State<AestheticButton> createState() => _AestheticButtonState();
}
class _AestheticButtonState extends State<AestheticButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gradientCtrl;
  late final Animation<double> _gradientAnim;
  @override
  void initState() {
    super.initState();
    _gradientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gradientAnim = CurvedAnimation(
      parent: _gradientCtrl,
      curve: Curves.easeInOut,
    );
  }
  @override
  void dispose() {
    _gradientCtrl.dispose();
    super.dispose();
  }
  Future<void> _handleTap() async {
    await UiSoundService.instance.playButtonAndAwaitStart();
    await _gradientCtrl.forward(from: 0.0);
    await _gradientCtrl.reverse();
    widget.onPressed();
  }
  @override
  Widget build(BuildContext context) {
    final palette = widget._effectivePalette;
    final Color primary = widget.isSelected ? palette.accent : palette.primary;
    //final Color highlight = palette.highlight;
    final Color accent = palette.accent;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _gradientAnim,
        builder: (context, child) {
          final Alignment primaryAlignment = Alignment.lerp(
            Alignment.centerLeft,
            Alignment.centerRight,
            _gradientAnim.value,
          )!;
          final Gradient animatedGradient = LinearGradient(
            begin: primaryAlignment,
            end: Alignment.centerRight,
            colors: [primary, accent],
            stops: [0.0, 0.6],
          );
          final Color animatedTextColor = Color.lerp(
            palette.text,
            palette.neutral,
            _gradientAnim.value,
          )!;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: animatedGradient,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: accent.withAlpha((0.95 * 255).round()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withAlpha((0.14 * 255).round()),
                  offset: const Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 13,
                  color: animatedTextColor,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}