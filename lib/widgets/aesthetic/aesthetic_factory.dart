import 'package:flutter/material.dart';
import '../shared/visual_factory.dart';
import '../../theme/aesthetic_pallete.dart';
import '../../widgets/aesthetic/aesthetic_button.dart';
import '../../widgets/aesthetic/aesthetic_container.dart';

class AestheticFactory implements VisualFactory {
  final UiPalette palette;
  final double _navHeight; // backing field for the navHeight getter

  const AestheticFactory({
    required this.palette,
    double navHeight = 80.0,
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
    return IconTheme(
      data: IconThemeData(
        color: active ? palette.highlight : palette.text,
        size: 24,
      ),
      child: child,
    );
  }

  /// AppBar-compatible shell that reuses AestheticContainer.
  /// Use inside PreferredSize: appBar: PreferredSize(preferredSize: Size.fromHeight(factory.navHeight), child: factory.buildAppBarShell(...))
  Widget buildAppBarShell({
    required BuildContext context,
    required Widget child,
    double? height,
  }) {
    return AestheticContainer(
      height: height ?? navHeight,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget buildNavBarShell({
    required BuildContext context,
    required Widget child,
  }) {
    // Replaced rotating gradient shell with the canonical AestheticContainer
    return SafeArea(
      top: false,
      bottom: true,
      child: SizedBox(
        height: navHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AestheticContainer(
            height: navHeight,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Color iconColor(bool active) => active ? palette.accent : palette.text;

  @override
  Widget buildSettingsButton() =>
      AestheticButton(label: "Settings", onPressed: () {});

  @override
  Widget buildSettingsContainer({required Widget child}) {
    return AestheticContainer(child: child);
  }
}