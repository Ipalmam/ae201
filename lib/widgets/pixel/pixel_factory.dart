import 'package:flutter/material.dart';
import '../shared/visual_factory.dart';
import '../../theme/pixel_pallete.dart';
import '../../widgets/pixel/pixel_button.dart';
import '../../widgets/pixel/pixel_container.dart';

class PixelFactory implements VisualFactory {
  final UiPalette palette;
  final double liftAmount;
  final Duration animDuration;
  final Curve animCurve;
  final double _navHeight; // backing field for navHeight getter

  PixelFactory({
    required this.palette,
    this.liftAmount = 8,
    this.animDuration = const Duration(milliseconds: 220),
    this.animCurve = Curves.easeOut,
    double navHeight = 64, // default pixel nav height (can be overridden)
  }) : _navHeight = navHeight;

  @override
  double get navHeight => _navHeight;

  @override
  Widget buildNavButton({
    required BuildContext context,
    required Widget child,
    required bool active,
    required VoidCallback onTap,
  }) {
    final double effectiveLift = active ? -liftAmount : 0.0;
    final Color bgColor = active ? palette.primary : Colors.transparent;
    final borderLeft = BorderSide(color: palette.highlight.withAlpha(200), width: 1);

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
    return Container(
      height: navHeight, // match button/nav height via getter
      color: palette.neutral,
      child: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: palette.highlight, width: 2))),
        child: child,
      ),
    );
  }

  @override
  Color iconColor(bool active) => active ? palette.highlight : palette.text;

  // Note: buildAppBar is not part of VisualFactory interface, do not annotate with @override
  PreferredSizeWidget buildAppBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    // Match Aesthetic: larger toolbar and ornament
    const double toolbarHeight = 72; // adjusted height
    const double topOrnamentHeight = 16; // slightly larger decorative band
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    final double totalHeight = toolbarHeight + topOrnamentHeight + bottomHeight;

    return PreferredSize(
      preferredSize: Size.fromHeight(totalHeight),
      child: Material(
        color: palette.primary,
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // decorative stripe
            Container(height: topOrnamentHeight, color: palette.highlight.withAlpha(220)),
            // main toolbar with internal vertical padding for balanced look
            SizedBox(
              height: toolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    // optional leading area (keeps space consistent with aesthetic)
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P', // keep pixel font if used
                          fontSize: 16, // slightly larger to match Aesthetic visual weight
                          letterSpacing: 0.5,
                          height: 1.0,
                        ),
                      ),
                    ),
                    if (actions != null) ...actions,
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            if (bottom != null) bottom,
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSettingsButton() => PixelButton(label: "Settings", onPressed: () {});

  @override
  Widget buildSettingsContainer({required Widget child}) => PixelContainer(child: child);
}