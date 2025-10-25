// lib/services/localization_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/widgets.dart';

class LocalizationService extends ChangeNotifier {
  Locale _locale;
  Map<String, dynamic> _data = {};
  // CAMBIO: Ahora es obligatorio inyectar SharedPreferences
  final SharedPreferences prefs;

  // CAMBIO: Constructor ajustado para requerir SharedPreferences
  LocalizationService(this._locale, {required this.prefs});

  Locale get locale => _locale;

  // ----------------------------------------------------------------------
  // CARGA INICIAL
  // ----------------------------------------------------------------------

  // CAMBIO: Método de carga separado para inicializar el idioma
  Future<void> load() async {
    final savedCode = prefs.getString('locale');
    if (savedCode != null) {
      _locale = Locale(savedCode);
    } else {
      // Si no hay guardado, usa el locale inicial del constructor (o por defecto)
    }
    await _loadData(_locale);
  }

  Future<void> _loadData(Locale locale) async {
    _locale = locale;
    final code = locale.languageCode;
    try {
      final jsonStr = await rootBundle.loadString('assets/lang/$code.json');
      _data = json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      // Si falla, carga el fallback (en.json)
      final jsonStr = await rootBundle.loadString('assets/lang/en.json');
      _data = json.decode(jsonStr) as Map<String, dynamic>;
      _locale = const Locale('en');
    }
    // No guarda en prefs aquí, ya que loadLocale lo hace.
    notifyListeners();
  }

  Future<void> loadLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    await _loadData(locale);
    // Guarda el nuevo locale en SharedPreferences
    await prefs.setString('locale', _locale.languageCode); 
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