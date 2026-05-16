import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';

import '../../test_helpers.dart';

void main() {
  Future<void> openAddPetDialog(WidgetTester tester) async {
    setDesktopViewport(tester);
    await tester.pumpWidget(buildTestApp(const PetsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();
  }

  testWidgets('add pet form renders its main fields', (tester) async {
    await openAddPetDialog(tester);

    expect(find.text('Alta de mascota'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Tipo de animal'), findsOneWidget);
    expect(find.text('Perro'), findsWidgets);
    expect(find.text('Raza / tipo'), findsOneWidget);
    expect(find.text('Edad'), findsOneWidget);
    expect(find.text('País'), findsOneWidget);
    expect(find.text('Provincia / Estado / Región'), findsOneWidget);
    expect(find.text('Ciudad / localidad'), findsOneWidget);
    expect(find.text('Sexo'), findsOneWidget);
    expect(find.text('Descripción breve'), findsOneWidget);
  });

  testWidgets('age field filters non numeric input', (tester) async {
    await openAddPetDialog(tester);

    await tester.enterText(
      find.byKey(const ValueKey('pet-age-field')),
      'abc123',
    );
    await tester.pump();

    expect(find.text('123'), findsOneWidget);
    expect(find.text('abc123'), findsNothing);
  });

  testWidgets('age 21 blocks saving and age 20 is accepted', (tester) async {
    await openAddPetDialog(tester);

    await fillPetForm(tester, name: 'Edad QA', age: '21');
    await tapSavePetForm(tester);

    expect(find.text('La edad máxima permitida es 20 años.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('pet-age-field')), '20');
    await tapSavePetForm(tester);

    expect(find.text('La edad máxima permitida es 20 años.'), findsNothing);
  });

  testWidgets(
    'animal selection updates breed options and supports other breed',
    (tester) async {
      await openAddPetDialog(tester);

      await tester.tap(find.byKey(const ValueKey('pet-species-dropdown')));
      await tester.pumpAndSettle();

      expect(find.text('Gato').last, findsOneWidget);
      expect(find.text('Conejo').last, findsOneWidget);
      expect(find.text('Hurón').last, findsOneWidget);

      await tester.tap(find.text('Gato').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('pet-breed-dropdown')));
      await tester.pumpAndSettle();

      expect(find.text('Siamés').last, findsOneWidget);
      expect(find.text('Mestizo / Sin raza definida').last, findsOneWidget);

      await tester.tap(find.text('Otra').last);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('pet-other-breed-field')),
        findsOneWidget,
      );
      await tester.enterText(
        find.byKey(const ValueKey('pet-other-breed-field')),
        'Raza QA manual',
      );
      expect(find.text('Raza QA manual'), findsOneWidget);
    },
  );

  testWidgets('location supports Argentina hierarchy and manual locality', (
    tester,
  ) async {
    await openAddPetDialog(tester);

    await tester.tap(find.byKey(const ValueKey('pet-region-dropdown')));
    await tester.pumpAndSettle();

    expect(find.text('Buenos Aires').last, findsOneWidget);

    await tester.tap(find.text('Buenos Aires').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pet-city-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Otra localidad').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('pet-other-city-field')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('pet-other-city-field')),
      'Localidad QA',
    );
    expect(find.text('Localidad QA'), findsOneWidget);
  });
}
