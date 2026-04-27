import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';

import '../../test_helpers.dart';

void main() {
  Future<void> openAddPetDialog(WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const PetsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
  }

  testWidgets('add pet form renders its main fields', (tester) async {
    await openAddPetDialog(tester);

    expect(find.text('Alta de mascota'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Especie'), findsOneWidget);
    expect(find.text('Mascota'), findsOneWidget);
    expect(find.text('Raza'), findsOneWidget);
    expect(find.text('Edad'), findsOneWidget);
    expect(find.text('Ubicación'), findsOneWidget);
    expect(find.text('Sexo'), findsOneWidget);
    expect(find.text('Descripción breve'), findsOneWidget);
  });

  testWidgets('age field filters non numeric input', (tester) async {
    await openAddPetDialog(tester);

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(3), 'abc123');
    await tester.pump();

    expect(find.text('123'), findsOneWidget);
    expect(find.text('abc123'), findsNothing);
  });
}
