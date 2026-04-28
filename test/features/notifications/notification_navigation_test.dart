import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('pet notification opens pet detail', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      email: 'notification-pet-navigation@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-navigation',
      petName: 'Noti Navegable',
    );
    final notificationTitle = AppData.notifications.first.title;

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, notificationTitle);

    expect(find.text('Detalle de mascota'), findsOneWidget);
    expect(find.text('Noti Navegable'), findsWidgets);
  });

  testWidgets('opening a notification marks it read and persists it', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      email: 'notification-read-navigation@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-read-navigation',
      petName: 'Lectura Navegable',
    );
    final notificationTitle = AppData.notifications.first.title;

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(AppData.unreadNotificationsCount, 1);
    await _tapVisible(tester, notificationTitle);
    expect(AppData.unreadNotificationsCount, 0);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(
      buildTestApp(
        const NotificationsScreen(),
        controller: restoredSession.controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(AppData.unreadNotificationsCount, 0);
    expect(find.text('Marcar visto'), findsNothing);
  });

  testWidgets('conversation notification opens the related conversation', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      email: 'notification-conversation@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-conversation',
      petName: 'Chat Navegable',
    );
    await AppData.expressInterest(
      petId: 'pet-notification-conversation',
      interestType: 'Vinculo social',
      message: 'Queremos abrir esta conversacion desde notificaciones.',
    );
    final notificationTitle = AppData.notifications.first.title;

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, notificationTitle);

    expect(find.textContaining('Convers'), findsWidgets);
    expect(find.text('Contacto por Chat Navegable'), findsWidgets);
    expect(
      find.text('Queremos abrir esta conversacion desde notificaciones.'),
      findsOneWidget,
    );
  });

  testWidgets('notification without destination does not crash', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      email: 'notification-no-destination@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-deleted',
      petName: 'Destino Eliminado',
    );
    await AppData.deletePet('pet-notification-deleted');
    final notificationTitle = AppData.notifications.first.title;

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, notificationTitle);

    expect(find.text('Actividad y notificaciones'), findsOneWidget);
    expect(
      find.text('No hay un destino disponible para esta notificacion.'),
      findsOneWidget,
    );
    expect(AppData.unreadNotificationsCount, 0);
  });

  testWidgets('navigable notifications are isolated by account', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Cuenta Navegable Uno',
      email: 'notification-account-one@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-account-one',
      petName: 'Noti Cuenta Uno',
    );

    await session.controller.register(
      ownerName: 'Cuenta Navegable Dos',
      email: 'notification-account-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Noti Cuenta Uno'), findsNothing);
    expect(find.text('No hay novedades sin leer.'), findsWidgets);
    expect(AppData.unreadNotificationsCount, 0);
  });
}

Future<TestAppSession> _buildNotificationsSession({
  String ownerName = 'Familia Notificaciones Navegables',
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

Future<void> _addPetForNotification({
  required String petId,
  required String petName,
}) async {
  await AppData.addPet(
    MockData.pets.first.copyWith(
      id: petId,
      name: petName,
      profileId: 'MSC-$petId',
      qrCodeLabel: 'MSC-$petId',
    ),
  );
}

Future<void> _tapVisible(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
