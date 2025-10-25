// lib/screens/onboarding/login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// Ya no necesitamos StartScreen aquí si volvemos al wrapper
// import 'package:ae201/screens/hangar/start_screen.dart'; 
import '../../services/localization_service.dart'; // Nueva Importación para el servicio

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 1. OBTENER TRADUCCIONES VÍA PROVIDER
    final loc = context.watch<LocalizationService>();
    
    // Los textos se obtienen directamente del servicio de localización
    final buttonText = loc.t('buttons.googleSignIn', fallback: 'Sign in with Google'); 
    final welcomeText = loc.t('messages.welcome', fallback: 'Welcome, pilot!');
    final titleText = loc.t('menu.login', fallback: 'Log In');

    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(welcomeText),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final googleUser = await GoogleSignIn().signIn();
                final googleAuth = await googleUser?.authentication;

                if (googleAuth != null) {
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  if (context.mounted) {
                    // 2. CORREGIR LA NAVEGACIÓN POST-AUTENTICACIÓN
                    // Al completar el login, simplemente cerramos esta pantalla.
                    // El AuthenticationWrapper se reconstruirá automáticamente 
                    // (ya que user != null) y mostrará StartScreen.
                    Navigator.of(context).pop(); 
                  }
                }
              },
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}