import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/hangar/start_screen.dart';
import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/language_confirm_screen.dart';
import 'widgets/audio_manager.dart';

Future<Map<String, dynamic>> loadLanguageFile(String languageCode) async {
  final supportedLanguages = ['en', 'es', 'zh', 'ja', 'ko', 'de', 'fr', 'hi', 'ar'];
  final fallback = 'en';
  final fileName = supportedLanguages.contains(languageCode) ? '$languageCode.json' : '$fallback.json';

  try {
    final jsonString = await rootBundle.loadString('assets/i18n/$fileName');
    return json.decode(jsonString);
  } catch (e) {
    debugPrint('Error loading language file: $e');
    return {};
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager().loadVolume();  // Load persisted volume
  await AudioManager().playStartupMusic();
  await Firebase.initializeApp();
  // Immersive fullscreen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Optional: lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString('selectedLanguage');
  final deviceLanguage = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final languageCode = savedLanguage ?? deviceLanguage;
  final localizedStrings = await loadLanguageFile(languageCode);
  final user = FirebaseAuth.instance.currentUser;

  runApp(MaterialApp(
    title: 'Aztec Eagles 201',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepOrange,
      fontFamily: 'RobotoMono',
    ),
    home: savedLanguage == null
        ? LanguageConfirmScreen(
            localizedStrings: localizedStrings,
            onConfirm: () async {
              await prefs.setString('selectedLanguage', languageCode);
              final user = FirebaseAuth.instance.currentUser;
              runApp(MaterialApp(
                title: 'Aztec Eagles 201',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.deepOrange,
                  fontFamily: 'RobotoMono',
                ),
                home: user != null
                    ? StartScreen(languageCode: languageCode, localizedStrings: localizedStrings)
                    : LoginScreen(languageCode: languageCode, localizedStrings: localizedStrings),
              ));
            },
            onChange: () {
              // Just re-show LanguageConfirmScreen with fallback language
              final fallbackCode = 'en';
              loadLanguageFile(fallbackCode).then((fallbackStrings) {
                runApp(MaterialApp(
                  title: 'Aztec Eagles 201',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.deepOrange,
                    fontFamily: 'RobotoMono',
                  ),
                  home: LanguageConfirmScreen(
                    localizedStrings: fallbackStrings,
                    onConfirm: () async {
                      await prefs.setString('selectedLanguage', fallbackCode);
                      final user = FirebaseAuth.instance.currentUser;
                      runApp(MaterialApp(
                        title: 'Aztec Eagles 201',
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          brightness: Brightness.dark,
                          primarySwatch: Colors.deepOrange,
                          fontFamily: 'RobotoMono',
                        ),
                        home: user != null
                            ? StartScreen(languageCode: fallbackCode, localizedStrings: fallbackStrings)
                            : LoginScreen(languageCode: fallbackCode, localizedStrings: fallbackStrings),
                      ));
                    },
                    onChange: () {}, // Optional: disable or loop back
                  ),
                ));
              });
            },
          )
        : (user != null
            ? StartScreen(languageCode: languageCode, localizedStrings: localizedStrings)
            : LoginScreen(languageCode: languageCode, localizedStrings: localizedStrings)),
  ));
}