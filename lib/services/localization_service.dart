import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/widgets.dart';

class LocalizationService extends ChangeNotifier {
  Locale _locale;
  Map<String, dynamic> _data = {};
  final SharedPreferences? prefs; // optional injection for tests

  LocalizationService(this._locale, {this.prefs});

  Locale get locale => _locale;

  Future<void> loadLocale(Locale locale) async {
    _locale = locale;
    final code = locale.languageCode;
    try {
      final jsonStr = await rootBundle.loadString('assets/lang/$code.json');
      _data = json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      final jsonStr = await rootBundle.loadString('assets/lang/en.json');
      _data = json.decode(jsonStr) as Map<String, dynamic>;
      _locale = const Locale('en');
    }
    await prefs?.setString('locale', _locale.languageCode);
    notifyListeners();
  }

  String t(String keyPath, {Map<String, String>? vars, String? fallback}) {
    final parts = keyPath.split('.');
    dynamic node = _data;
    for (final p in parts) {
      if (node is Map<String, dynamic> && node.containsKey(p)) {
        node = node[p];
      } else {
        return fallback ?? keyPath;
      }
    }
    String result = node is String ? node : (fallback ?? keyPath);
    vars?.forEach((k, v) => result = result.replaceAll('{$k}', v));
    return result;
  }
}