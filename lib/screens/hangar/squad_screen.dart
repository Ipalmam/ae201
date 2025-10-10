import 'package:flutter/material.dart';

class SquadScreen extends StatelessWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooperative Mode',
        style: TextStyle(
          color: Colors.green, // Change this to your desired color
          fontWeight: FontWeight.bold, // Optional: cockpit-style emphasis
          fontSize: 20, // Optional: tweak size
  ),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Cooperative Mode Screen',
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