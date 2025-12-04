//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_gym/main.dart';

void main() {
  testWidgets('Gym App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GymApp());

    // Verify that the home screen loads
    expect(find.text('Gym App'), findsOneWidget);
    expect(find.text('Usuarios'), findsOneWidget);
    expect(find.text('Ejercicios'), findsOneWidget);
    expect(find.text('Entrenamientos'), findsOneWidget);
  });
}
