import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aztec Eagles',
        style: TextStyle(
          color: Colors.amber, // Change this to your desired color
          fontWeight: FontWeight.bold, // Optional: cockpit-style emphasis
          fontSize: 20, // Optional: tweak size
  ),
),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Welcome, Pilot',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}