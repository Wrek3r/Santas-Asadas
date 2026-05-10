import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santas_asadas/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.text('DATOS DE ENVÍO'), findsOneWidget);
    expect(find.text('COMENZAR A PEDIR'), findsOneWidget);
  });
}
