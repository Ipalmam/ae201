// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// Importa tus servicios y pantallas (Asegúrate de que estas rutas son correctas)
import 'services/localization_service.dart';
import 'services/ui_sound_service.dart'; 
import 'services/style_manager.dart';      
import 'screens/hangar/start_screen.dart';
import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/language_confirm_screen.dart';
import 'theme/game_palettes.dart'; // Para el tema por defecto de la pantalla de carga

// 🔑 CLAVE: Eliminamos la función loadLanguageFile() y AudioManager.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializar dependencias estáticas
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  
  // Immersive fullscreen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. Crear e Inyectar los servicios
  final uiSoundService = UiSoundService();
  // Usamos el locale guardado o el de dispositivo.
  final locale = Locale(prefs.getString('locale') ?? 'en'); 
  final localizationService = LocalizationService(locale, prefs: prefs);
  
  final styleManager = StyleManager(
    prefs: prefs, 
    soundService: uiSoundService,
  );

  // 3. Llamar a las funciones de carga inicial (Asíncronas)
  final List<Future> loadingTasks = [
    localizationService.loadLocale(locale), 
    uiSoundService.loadVolume(prefs), 
    styleManager.load(),
    // Puedes añadir aquí otras tareas asíncronas
  ];

  runApp(
    MultiProvider(
      providers: [
        // 🔑 CORRECCIÓN: Inyectar SharedPreferences aquí
        // Esta es la línea que faltaba y causaba el error.
        Provider<SharedPreferences>.value(value: prefs), 
        
        ChangeNotifierProvider.value(value: localizationService),
        ChangeNotifierProvider.value(value: uiSoundService),
        ChangeNotifierProvider.value(value: styleManager),
      ],
      // Envuelve la aplicación en el inicializador que espera la carga
      child: AppInitializer(loadingFutures: loadingTasks),
    ),
  );
}

/// Widget que maneja el estado de carga y renderiza la aplicación principal
class AppInitializer extends StatelessWidget {
  final List<Future> loadingFutures;

  const AppInitializer({super.key, required this.loadingFutures});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(loadingFutures),
      builder: (context, snapshot) {
        // Obtenemos los servicios desde el contexto
        final styleManager = context.watch<StyleManager>();
        final localizationService = context.watch<LocalizationService>();
        
        // El tema se toma del StyleManager
        // 🔑 NOTA: Aquí asumimos que tienes un valor llamado 'pixelNeonRetro' en game_palettes.dart.
        final defaultTheme = themeFromPalette(pixelNeonRetro);
        final currentTheme = styleManager.themeData;
        
        if (snapshot.connectionState == ConnectionState.done) {
          // Una vez cargado, usamos el tema real cargado por StyleManager
          return MaterialApp(
            title: 'Aztec Eagles 201',
            debugShowCheckedModeBanner: false,
            theme: currentTheme, 
            locale: localizationService.locale, 
            home: const AuthenticationWrapper(), 
          );
        }

        // Pantalla de Carga: Usamos un tema por defecto mientras cargamos
        return MaterialApp(
          title: 'Aztec Eagles 201',
          debugShowCheckedModeBanner: false,
          theme: defaultTheme, 
          home: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper para decidir entre LanguageConfirmScreen y StartScreen
class AuthenticationWrapper extends StatelessWidget {
  // Mantenemos el constructor constante para la optimización
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta línea ahora funcionará gracias a la corrección en MultiProvider
    final prefs = context.read<SharedPreferences>(); 
    final locService = context.read<LocalizationService>();
    final savedLanguage = prefs.getString('selectedLanguage');

    // 1. Si no hay idioma guardado, mostramos la pantalla de confirmación.
    if (savedLanguage == null) {
      return LanguageConfirmScreen(
        onConfirm: () async {
          await prefs.setString('selectedLanguage', locService.locale.languageCode);
          // Al guardar 'selectedLanguage', AuthenticationWrapper se reconstruirá
          // y pasará al siguiente paso.
        },
        onChange: () {
          debugPrint("Navegar a la pantalla de selección de idioma.");
        },
      ); 
    }

    // 2. Si el idioma está confirmado, SIEMPRE muestra StartScreen.
    return const StartScreen();
  }
}