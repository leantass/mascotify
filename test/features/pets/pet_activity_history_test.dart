import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('creating a pet shows a history event in detail', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-created@mascotify.local',
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    await _createPetFromUi(tester, 'Historial Creado');
    await _openPetDetail(tester, 'Historial Creado');
    await _scrollToHistory(tester);

    expect(find.text('Historial de actividad'), findsOneWidget);
    expect(find.text('Mascota creada - Ahora'), findsOneWidget);
    expect(find.textContaining('Se creo la ficha local'), findsOneWidget);
  });

  testWidgets('editing a pet generates an update history event', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-updated@mascotify.local',
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    await _createPetFromUi(tester, 'Historial Editable');
    await tester.tap(find.widgetWithText(OutlinedButton, 'Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).at(0),
      'Historial Editado',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    await _openPetDetail(tester, 'Historial Editado');
    await _scrollToHistory(tester);

    expect(find.text('Perfil actualizado - Ahora'), findsOneWidget);
    expect(find.text('Mascota creada - Ahora'), findsOneWidget);
  });

  testWidgets('pet history persists after app reconstruction', (tester) async {
    setDesktopViewport(tester);
    final firstSession = await _buildActivitySession(
      email: 'activity-persisted@mascotify.local',
    );
    final pet = _pet(id: 'pet-activity-persisted', name: 'Persistente');
    await AppData.addPet(pet);
    await AppData.updatePet(pet.copyWith(name: 'Persistente Editada'));

    await tester.pumpWidget(firstSession.buildApp());
    await tester.pumpAndSettle();

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(restoredSession.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    await _openPetDetail(tester, 'Persistente Editada');
    await _scrollToHistory(tester);

    expect(find.text('Perfil actualizado - Ahora'), findsOneWidget);
    expect(find.text('Mascota creada - Ahora'), findsOneWidget);
  });

  testWidgets('pet history is isolated between pets', (tester) async {
    await _buildActivitySession(email: 'activity-pets@mascotify.local');
    final firstPet = _pet(id: 'pet-history-one', name: 'Historia Uno');
    final secondPet = _pet(id: 'pet-history-two', name: 'Historia Dos');

    await AppData.addPet(firstPet);
    await AppData.addPet(secondPet);
    await AppData.updatePet(firstPet.copyWith(name: 'Historia Uno Editada'));

    final firstEvents = AppData.petActivityEventsForPet(firstPet.id);
    final secondEvents = AppData.petActivityEventsForPet(secondPet.id);

    expect(
      firstEvents.map((event) => event.title),
      contains('Perfil actualizado'),
    );
    expect(
      secondEvents.map((event) => event.title),
      isNot(contains('Perfil actualizado')),
    );
  });

  testWidgets('pet history is isolated between accounts', (tester) async {
    final session = await _buildActivitySession(
      ownerName: 'Cuenta Historial Uno',
      email: 'activity-account-one@mascotify.local',
    );
    final firstPet = _pet(id: 'pet-account-history-one', name: 'Cuenta Uno');
    await AppData.addPet(firstPet);

    await session.controller.register(
      ownerName: 'Cuenta Historial Dos',
      email: 'activity-account-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    expect(AppData.pets, isEmpty);
    expect(AppData.petActivityEventsForPet(firstPet.id), isEmpty);
  });

  testWidgets(
    'pet detail shows an empty history state when there is no activity',
    (tester) async {
      setDesktopViewport(tester);
      await buildPersistentTestAppSession();

      await tester.pumpWidget(
        buildTestApp(PetDetailScreen(pet: MockData.pets.first)),
      );
      await tester.pumpAndSettle();
      await _scrollToHistory(tester);

      expect(find.text('Historial de actividad'), findsOneWidget);
      expect(
        find.text('Todavia no hay actividad registrada para esta mascota.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('social interest and messages add pet history events', (
    tester,
  ) async {
    await _buildActivitySession(email: 'activity-social@mascotify.local');
    final pet = _pet(id: 'pet-activity-social', name: 'Social Historial');

    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Queremos iniciar una conversacion.',
    );
    final thread = AppData.findMessageThreadForPet(pet);
    expect(thread, isNotNull);

    await AppData.sendMessage(thread!.id, 'Mensaje asociado al historial.');

    final titles = AppData.petActivityEventsForPet(
      pet.id,
    ).map((event) => event.title);
    expect(titles, contains('Interes social registrado'));
    expect(titles, contains('Mensaje enviado'));
  });
}

Future<TestAppSession> _buildActivitySession({
  String ownerName = 'Familia Historial',
  required String email,
}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: ownerName,
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _createPetFromUi(WidgetTester tester, String name) async {
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

Future<void> _openPetDetail(WidgetTester tester, String name) async {
  await tester.ensureVisible(find.text(name).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(name).first);
  await tester.pumpAndSettle();
}

Future<void> _scrollToHistory(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Historial de actividad'),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}
