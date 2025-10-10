// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ae201/screens/hangar/start_screen.dart';
void main() {
  testWidgets('StartScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StartScreen(
          languageCode: 'en',
          localizedStrings: {
            'menu': {
              'home': 'Home',
              'versus': 'Versus',
              'soloOps': 'Solo Ops',
              'squad': 'Squad',
              'settings': 'Settings',
            },
            'buttons': {},
            'messages': {},
          },
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
  });
}
