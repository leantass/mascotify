import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/messages_inbox_screen.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('complete family flow keeps core local navigation usable', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Demo familiar');
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo familia'), findsWidgets);

    await _openMainTab(tester, 'Mascotas');
    expect(find.text('Centro de mascotas'), findsOneWidget);
    await _createPetFromUi(tester, 'Hardening Familia');
    expect(find.text('Hardening Familia'), findsOneWidget);

    await _tapVisibleText(tester, 'Hardening Familia');
    expect(find.text('Detalle de mascota'), findsOneWidget);
    await _tapVisibleText(tester, 'Ver historial QR');
    expect(find.text('Historial QR'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Detalle de mascota'), findsOneWidget);
    expect(find.text('Historial de actividad'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _openMainTab(tester, 'Actividad');
    expect(find.text('Feed general'), findsOneWidget);
    expect(
      AppData.ecosystemActivityFeed.map((item) => item.title),
      contains('Mascota creada'),
    );

    await _openMainTab(tester, 'Inicio');
    await _tapVisibleText(tester, 'Ver actividad');
    expect(find.text('Actividad y notificaciones'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Abrir mensajes');
    expect(find.text('Conversaciones activas'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _openMainTab(tester, 'Perfil');
    expect(find.text('Cuenta base'), findsOneWidget);
    await _logoutFromProfile(tester);

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Mascotas'), findsNothing);
  });

  testWidgets('complete professional flow keeps workspace and profile usable', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Demo profesional');
    expect(find.text('Modo profesional'), findsWidgets);

    await _openMainTab(tester, 'Servicios');
    expect(find.text('Servicios contemplados'), findsOneWidget);
    if (find.text('Activar presencia profesional').evaluate().isNotEmpty) {
      await _tapVisibleText(tester, 'Activar presencia profesional');
    }
    expect(find.textContaining('perfil'), findsWidgets);
    await _tapVisibleText(tester, 'perfil');
    expect(find.text('Perfil profesional'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _openMainTab(tester, 'Actividad');
    expect(find.text('Feed general'), findsOneWidget);
    await _openMainTab(tester, 'Perfil');
    expect(find.text('Cuenta base'), findsOneWidget);
    await _logoutFromProfile(tester);

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Servicios'), findsNothing);
  });

  testWidgets('family data does not leak into another local account', (
    tester,
  ) async {
    final session = await _registerAccount(
      ownerName: 'Familia Hardening',
      email: 'hardening-family@mascotify.local',
      experience: AccountExperience.family,
    );
    final pet = _pet(id: 'pet-hardening-isolated', name: 'Dato Aislado');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Mensaje que no debe filtrarse.',
    );
    await AppData.registerQrTraceabilityReview(pet.id);

    await session.controller.logout();
    await session.controller.register(
      ownerName: 'Profesional Aislado',
      email: 'hardening-professional@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.professional,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    expect(AppData.pets, isEmpty);
    expect(AppData.messageThreads, isEmpty);
    expect(
      AppData.ecosystemActivityFeed.any(
        (item) =>
            item.title.contains('Dato Aislado') ||
            item.description.contains('Dato Aislado'),
      ),
      isFalse,
    );
    expect(
      AppData.notifications.any(
        (notification) => notification.title.contains('Dato Aislado'),
      ),
      isFalse,
    );
  });

  testWidgets('reconstruction preserves local ecosystem and preferences', (
    tester,
  ) async {
    await _registerAccount(
      ownerName: 'Familia Persistente',
      email: 'hardening-persist@mascotify.local',
      experience: AccountExperience.family,
    );
    final pet = _pet(id: 'pet-hardening-persist', name: 'Persistencia Local');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);
    await AppData.setPlanName('Mascotify Plus');
    await AppData.setMessagesNotificationsEnabled(false);
    final qrCode = AppData.pets.single.qrCodeLabel;

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await AppData.syncCurrentUserState();

    expect(
      restoredSession.controller.currentAccount?.email,
      'hardening-persist@mascotify.local',
    );
    expect(AppData.pets.single.name, 'Persistencia Local');
    expect(AppData.pets.single.qrCodeLabel, qrCode);
    expect(AppData.currentUser.planName, 'Mascotify Plus');
    expect(AppData.currentUser.messagesNotificationsEnabled, isFalse);
    expect(
      AppData.ecosystemActivityFeed.map((item) => item.title),
      contains('Historial QR revisado'),
    );
    expect(AppData.notifications, isNotEmpty);
  });

  testWidgets('new local account shows empty core states without ghost data', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _registerAccount(
      ownerName: 'Familia Sin Datos',
      email: 'hardening-empty@mascotify.local',
      experience: AccountExperience.family,
    );

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Todav'), findsWidgets);

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Todav'), findsOneWidget);

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Todav'), findsOneWidget);

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    expect(find.text('No hay novedades sin leer.'), findsWidgets);

    expect(AppData.pets, isEmpty);
    expect(AppData.messageThreads, isEmpty);
    expect(AppData.notifications, isEmpty);
    expect(AppData.ecosystemActivityFeed, isEmpty);
  });

  testWidgets(
    'contextual feed navigation remains safe for valid and stale items',
    (tester) async {
      setDesktopViewport(tester);
      final session = await _registerAccount(
        ownerName: 'Familia Contextual',
        email: 'hardening-contextual@mascotify.local',
        experience: AccountExperience.family,
      );
      final pet = _pet(
        id: 'pet-hardening-contextual',
        name: 'Destino Contextual',
      );
      await AppData.addPet(pet);
      await AppData.registerQrTraceabilityReview(pet.id);

      await tester.pumpWidget(
        buildTestApp(
          const ActivityFeedScreen(),
          controller: session.controller,
        ),
      );
      await tester.pumpAndSettle();
      await _tapVisibleText(tester, 'Historial QR revisado');
      expect(find.text('Historial QR'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await AppData.deletePet(pet.id);
      await tester.pumpWidget(
        buildTestApp(
          const ActivityFeedScreen(),
          controller: session.controller,
        ),
      );
      await tester.pumpAndSettle();
      await _tapVisibleText(tester, 'Destino Contextual se elimin');

      expect(find.text('Actividad'), findsOneWidget);
      expect(
        find.text('No hay un destino disponible para esta actividad.'),
        findsOneWidget,
      );
    },
  );
}

Future<TestAppSession> _registerAccount({
  required String ownerName,
  required String email,
  required AccountExperience experience,
}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: ownerName,
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: experience,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _openMainTab(WidgetTester tester, String label) async {
  final finder = find.text(label).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _createPetFromUi(WidgetTester tester, String name) async {
  await _tapVisibleText(tester, 'Agregar');
  await fillPetForm(tester, name: name, age: '4');
  await _tapVisibleText(tester, 'Guardar');
}

Future<void> _logoutFromProfile(WidgetTester tester) async {
  final logoutButton = find.widgetWithText(OutlinedButton, 'Cerrar sesión');
  for (
    var attempt = 0;
    attempt < 6 && logoutButton.evaluate().isEmpty;
    attempt++
  ) {
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(logoutButton);
  await tester.pumpAndSettle();
  await tester.tap(logoutButton);
  await tester.pumpAndSettle();
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  var finder = find.textContaining(text);
  for (var attempt = 0; attempt < 8 && finder.evaluate().isEmpty; attempt++) {
    final scrollables = find.byType(Scrollable);
    if (scrollables.evaluate().isEmpty) break;
    await tester.drag(scrollables.last, const Offset(0, -650));
    await tester.pumpAndSettle();
    finder = find.textContaining(text);
  }
  final visibleFinder = finder.first;
  await tester.ensureVisible(visibleFinder);
  await tester.pumpAndSettle();
  await tester.tap(visibleFinder);
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
