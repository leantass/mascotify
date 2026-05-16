import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('creating two pets keeps both visible and persistent', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _openEmptyPetsScreen(
      tester,
      'two-pets-regression@mascotify.local',
    );

    await _createPet(tester, 'Pet Alfa', breed: 'Criollo', age: '2');
    await _createPet(tester, 'Pet Beta', breed: 'Mestizo', age: '4');

    expect(find.text('Pet Alfa'), findsOneWidget);
    expect(find.text('Pet Beta'), findsOneWidget);
    expect(find.textContaining('2 perfiles activos'), findsOneWidget);
    expect(AppData.pets.length, 2);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(restoredSession.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    expect(find.text('Pet Alfa'), findsOneWidget);
    expect(find.text('Pet Beta'), findsOneWidget);
    expect(AppData.pets.length, 2);
    expect(session.controller.currentUser?.email, isNotNull);
  });

  testWidgets(
    'saving without a pet name keeps form open and does not add pet',
    (tester) async {
      setDesktopViewport(tester);
      await _openEmptyPetsScreen(tester, 'missing-name-pet@mascotify.local');

      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      final fields = find.byType(EditableText);
      await tester.enterText(fields.at(2), 'Criollo');
      await tester.enterText(fields.at(3), '5');
      await tester.enterText(fields.at(4), 'Buenos Aires');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Alta de mascota'), findsOneWidget);
      expect(find.textContaining('Completa al menos'), findsOneWidget);
      expect(find.textContaining('0 perfiles activos'), findsOneWidget);
      expect(AppData.pets, isEmpty);
    },
  );

  testWidgets('editing a pet keeps its id and deleting one keeps the other', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _openEmptyPetsScreen(tester, 'edit-id-delete-one@mascotify.local');
    await _createPet(tester, 'Pet Uno', breed: 'Criollo', age: '3');
    await _createPet(tester, 'Pet Dos', breed: 'Mestizo', age: '6');

    final originalId = AppData.pets
        .firstWhere((pet) => pet.name == 'Pet Uno')
        .id;

    await tester.tap(find.widgetWithText(OutlinedButton, 'Editar').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), 'Pet Uno Editado');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    final edited = AppData.pets.firstWhere(
      (pet) => pet.name == 'Pet Uno Editado',
    );
    expect(edited.id, originalId);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Eliminar').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Pet Uno Editado'), findsOneWidget);
    expect(find.text('Pet Dos'), findsNothing);
    expect(AppData.pets.length, 1);
  });

  testWidgets('Free plan allows one pet and blocks the second one', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _openEmptyPetsScreen(tester, 'free-limit-pets@mascotify.local');
    await AppData.setPlanName('Mascotify Free');

    await _createPet(tester, 'Free Pet', breed: 'Criollo', age: '2');
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Limite de mascotas del plan'), findsOneWidget);
    expect(
      find.textContaining('Mascotify Free permite hasta 1 mascota'),
      findsOneWidget,
    );
    expect(find.textContaining('US\$ 1,99 mensual'), findsOneWidget);
    expect(find.text('Alta de mascota'), findsNothing);
    expect(AppData.pets.length, 1);
  });

  testWidgets('Plus plan allows five pets and blocks the sixth one', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _openEmptyPetsScreen(tester, 'plus-limit-pets@mascotify.local');

    for (var index = 1; index <= 5; index += 1) {
      await _createPet(
        tester,
        'Plus Pet $index',
        breed: 'Mestizo',
        age: '$index',
      );
    }

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.text('Limite de mascotas del plan'), findsOneWidget);
    expect(
      find.textContaining('Mascotify Plus permite hasta 5 mascotas'),
      findsOneWidget,
    );
    expect(find.textContaining('US\$ 4,99 mensual'), findsOneWidget);
    expect(find.textContaining('mascotas ilimitadas'), findsOneWidget);
    expect(find.text('Alta de mascota'), findsNothing);
    expect(AppData.pets.length, 5);
  });

  testWidgets('Pro plan shows unlimited pets and does not block six pets', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _openEmptyPetsScreen(tester, 'pro-unlimited-pets@mascotify.local');
    await AppData.setPlanName('Mascotify Pro');

    for (var index = 1; index <= 6; index += 1) {
      await _createPet(
        tester,
        'Pro Pet $index',
        breed: 'Criollo',
        age: '$index',
      );
    }

    expect(find.textContaining('Mascotify Pro'), findsOneWidget);
    expect(find.textContaining('Mascotas ilimitadas'), findsOneWidget);
    expect(find.text('Limite de mascotas del plan'), findsNothing);
    expect(AppData.pets.length, 6);
  });
}

Future<TestAppSession> _openEmptyPetsScreen(
  WidgetTester tester,
  String email,
) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Pets Regression QA',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();

  await tester.pumpWidget(session.buildApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Mascotas'));
  await tester.pumpAndSettle();
  return session;
}

Future<void> _createPet(
  WidgetTester tester,
  String name, {
  required String breed,
  required String age,
}) async {
  await tester.tap(find.text('Agregar'));
  await tester.pumpAndSettle();

  final fields = find.byType(EditableText);
  await tester.enterText(fields.at(0), name);
  await tester.enterText(fields.at(2), breed);
  await tester.enterText(fields.at(3), age);
  await tester.enterText(fields.at(4), 'Buenos Aires');
  await tester.tap(find.text('Guardar'));
  await tester.pumpAndSettle();
}
