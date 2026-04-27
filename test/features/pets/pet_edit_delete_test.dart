import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  Future<void> openEmptyPetsScreen(WidgetTester tester, String email) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.register(
      ownerName: 'Mascotas QA',
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
  }

  Future<void> createPet(WidgetTester tester, String name) async {
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), name);
    await tester.enterText(fields.at(2), 'Criollo');
    await tester.enterText(fields.at(3), '3');
    await tester.enterText(fields.at(4), 'Buenos Aires');

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
  }

  testWidgets('user can edit an existing pet without duplicating it', (
    tester,
  ) async {
    await openEmptyPetsScreen(tester, 'edit-pet-qa@mascotify.local');
    await createPet(tester, 'Mascota Editable');

    await tester.tap(find.widgetWithText(OutlinedButton, 'Editar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar mascota'), findsOneWidget);
    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Mascota Editada');
    await tester.enterText(fields.at(3), '7abc');
    await tester.pump();
    expect(find.text('7'), findsOneWidget);
    expect(find.text('7abc'), findsNothing);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Mascota Editada'), findsOneWidget);
    expect(find.text('Mascota Editable'), findsNothing);
    expect(find.textContaining('1 perfiles activos'), findsOneWidget);
  });

  testWidgets('cancel delete keeps the pet visible', (tester) async {
    await openEmptyPetsScreen(tester, 'cancel-delete-pet-qa@mascotify.local');
    await createPet(tester, 'Mascota Cancelada');

    await tester.tap(find.widgetWithText(OutlinedButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar mascota'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Mascota Cancelada'), findsOneWidget);
    expect(find.textContaining('1 perfiles activos'), findsOneWidget);
  });

  testWidgets('confirm delete removes the only pet and shows empty state', (
    tester,
  ) async {
    await openEmptyPetsScreen(tester, 'confirm-delete-pet-qa@mascotify.local');
    await createPet(tester, 'Mascota Eliminable');

    await tester.tap(find.widgetWithText(OutlinedButton, 'Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Mascota Eliminable'), findsNothing);
    expect(find.textContaining('0 perfiles activos'), findsOneWidget);
    expect(find.textContaining('Todav'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
  });
}
