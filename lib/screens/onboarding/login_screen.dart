import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ae201/screens/hangar/start_screen.dart';
class LoginScreen extends StatelessWidget {
  final String languageCode;
  final Map<String, dynamic> localizedStrings;

  const LoginScreen({
    super.key,
    required this.languageCode,
    required this.localizedStrings,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = localizedStrings['buttons']?['confirm'] ?? 'Sign in with Google';
    final welcomeText = localizedStrings['messages']?['welcome'] ?? 'Welcome, pilot!';

    return Scaffold(
      appBar: AppBar(title: Text(localizedStrings['menu']?['settings'] ?? 'Login')),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StartScreen(
                          languageCode: languageCode,
                          localizedStrings: localizedStrings,
                        ),
                      ),
                    );
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