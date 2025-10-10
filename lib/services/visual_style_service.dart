import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ae201/widgets/shared/visual_factory.dart';
enum VisualStyle { pixel, aesthetic }

class VisualStyleService extends ChangeNotifier {
  Widget get settingsButton => factory.buildSettingsButton();
  Widget settingsContainer({required Widget child}) =>
    factory.buildSettingsContainer(child: child);
  static const _kPrefsKey = 'visual_style';
  VisualStyle _current = VisualStyle.pixel;

  VisualStyle get current => _current;

  // A registry so you can override or extend factories if needed
  final Map<VisualStyle, VisualFactory> _registry;

  VisualStyleService({required Map<VisualStyle, VisualFactory> registry})
      : _registry = registry;

  VisualFactory get factory => _registry[_current]!;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kPrefsKey);
    if (s != null) {
      _current = VisualStyle.values.firstWhere(
        (v) => v.toString().split('.').last == s,
        orElse: () => VisualStyle.pixel,
      );
      notifyListeners();
    }
  }

  Future<void> setStyle(VisualStyle style) async {
    if (_current == style) return;
    _current = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, style.toString().split('.').last);
  }
}