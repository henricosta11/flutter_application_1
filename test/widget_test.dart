import 'package:flutter/material.dart'; // ✅ necessário para TextField, ElevatedButton
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App loads LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica se o título "Login" aparece
    expect(find.text('Login'), findsOneWidget);

    // Verifica se existem dois TextFields (username e password)
    expect(find.byType(TextField), findsNWidgets(2));

    // Verifica se existe um ElevatedButton
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
