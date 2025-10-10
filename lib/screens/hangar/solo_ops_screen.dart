import 'package:flutter/material.dart';

class SoloOpsScreen extends StatelessWidget {
  const SoloOpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Game',
        style: TextStyle(
          color: Colors.blue, // Change this to your desired color
          fontWeight: FontWeight.bold, // Optional: cockpit-style emphasis
          fontSize: 20, // Optional: tweak size
  ),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Local Game Mode',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}