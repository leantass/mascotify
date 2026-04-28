import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('new family account shows a clear empty notifications state', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Notificaciones Vacias',
      email: 'empty-notifications-qa@mascotify.local',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nuevo y pendiente'), findsOneWidget);
    expect(find.text('No hay novedades sin leer.'), findsWidgets);
    expect(find.text('Historial reciente'), findsOneWidget);
    expect(find.text('Milo'), findsNothing);
    expect(find.text('Marcar visto'), findsNothing);
    expect(AppData.unreadNotificationsCount, 0);
  });

  testWidgets('local notification persists after app reconstruction', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Notificaciones Persistentes',
      email: 'notifications-persist-qa@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-persist',
      petName: 'Luna Notificacion',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Luna Notificacion se agregó a tu cuenta'),
      findsOneWidget,
    );

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

    expect(
      find.text('Luna Notificacion se agregó a tu cuenta'),
      findsOneWidget,
    );
  });

  testWidgets('notification read state persists after reconstruction', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Lectura Persistente',
      email: 'notifications-read-qa@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-read',
      petName: 'Nala Lectura',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Marcar visto'), findsOneWidget);
    expect(AppData.unreadNotificationsCount, 1);
    await _tapVisible(tester, 'Marcar visto');

    expect(find.text('Marcar visto'), findsNothing);
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

    expect(find.text('Nala Lectura se agregó a tu cuenta'), findsOneWidget);
    expect(find.text('Marcar visto'), findsNothing);
    expect(AppData.unreadNotificationsCount, 0);
  });

  testWidgets('mark all notifications as read clears unread state', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Todas Leidas',
      email: 'notifications-all-read-qa@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-all-a',
      petName: 'Tango Leido',
    );
    await _addPetForNotification(
      petId: 'pet-notification-all-b',
      petName: 'Olivia Leida',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Marcar visto'), findsNWidgets(2));
    expect(AppData.unreadNotificationsCount, 2);
    await _tapVisible(tester, 'Marcar todo como visto');

    expect(find.text('Marcar visto'), findsNothing);
    expect(find.textContaining('Todo al'), findsOneWidget);
    expect(AppData.unreadNotificationsCount, 0);
  });

  testWidgets('local notifications are isolated by account', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Notificacion Uno',
      email: 'notifications-account-one@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-account-one',
      petName: 'Uma Cuenta Uno',
    );

    await session.controller.register(
      ownerName: 'Familia Notificacion Dos',
      email: 'notifications-account-two@mascotify.local',
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

    expect(find.text('Uma Cuenta Uno se agregó a tu cuenta'), findsNothing);
    expect(find.text('No hay novedades sin leer.'), findsWidgets);
    expect(find.text('Marcar visto'), findsNothing);
    expect(AppData.unreadNotificationsCount, 0);
  });

  testWidgets('social interest creates an internal notification', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildNotificationsSession(
      ownerName: 'Familia Notificacion Social',
      email: 'notifications-social-qa@mascotify.local',
    );
    await _addPetForNotification(
      petId: 'pet-notification-social',
      petName: 'Mora Social',
    );
    await AppData.expressInterest(
      petId: 'pet-notification-social',
      interestType: 'Vinculo social',
      message: 'Queremos seguir esta afinidad.',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Intención social registrada para Mora Social'),
      findsOneWidget,
    );
    expect(find.text('Abrir mensajes'), findsOneWidget);
  });
}

Future<TestAppSession> _buildNotificationsSession({
  required String ownerName,
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
