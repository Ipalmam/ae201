import 'package:flutter/material.dart';

class VersusScreen extends StatelessWidget {
  const VersusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versus Mode',
        style: TextStyle(
          color: Colors.red, // Change this to your desired color
          fontWeight: FontWeight.bold, // Optional: cockpit-style emphasis
          fontSize: 20, // Optional: tweak size
  ),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Versus Mode Screen',
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