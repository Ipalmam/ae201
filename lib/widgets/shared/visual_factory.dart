import 'package:flutter/material.dart';

abstract class VisualFactory {
  // build a standard nav button
  Widget buildNavButton({
    required BuildContext context,
    required Widget child,
    required bool active,
    required VoidCallback onTap,
  });

  // build a themed container that may be used around icons/labels
  Widget buildIconContainer({
    required BuildContext context,
    required Widget child,
    required bool active,
  });

  // optionally build the overall nav bar background/wrapper
  Widget buildNavBarShell({
    required BuildContext context,
    required Widget child,
  });

  // new: return the proper icon/text color for this style
  Color iconColor(bool active);

    // ✅ new: return the correct settings button for this style
  Widget buildSettingsButton();

  // ✅ new: return the correct settings container for this style
  Widget buildSettingsContainer({required Widget child});
  double get navHeight;
  
}