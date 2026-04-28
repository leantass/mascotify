import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('pet create edit and delete generate activity notifications', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildFamilySession(
      email: 'notifications-pet-events@mascotify.local',
    );
    await _addPet(petId: 'pet-notif-events', petName: 'Kiara Eventos');
    final pet = AppData.pets.single;
    await AppData.updatePet(pet.copyWith(name: 'Kiara Editada'));
    await AppData.deletePet(pet.id);

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kiara Eventos se agregó a tu cuenta'), findsNothing);
    expect(find.text('Kiara Editada se actualizó'), findsNothing);
    expect(find.text('Kiara Editada se eliminó de la cuenta'), findsOneWidget);
    expect(AppData.notifications.length, 1);
  });

  testWidgets('professional profile activation creates a notification', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.register(
      ownerName: 'Profesional Notificaciones QA',
      email: 'professional-notification@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.professional,
    );
    await session.controller.completeOnboarding();
    await AppData.activateCurrentProfessionalProfile();

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Presencia profesional activada'), findsOneWidget);
    expect(find.text('Ver profesionales'), findsOneWidget);
    expect(AppData.unreadNotificationsCount, 1);
  });

  testWidgets('marking one notification read leaves the other unread', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildFamilySession(
      email: 'notifications-one-read@mascotify.local',
    );
    await _addPet(petId: 'pet-one-read-a', petName: 'Asha Noti');
    await _addPet(petId: 'pet-one-read-b', petName: 'Bimba Noti');

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(AppData.unreadNotificationsCount, 2);
    final markRead = find.text('Marcar visto').first;
    await tester.ensureVisible(markRead);
    await tester.pumpAndSettle();
    await tester.tap(markRead);
    await tester.pumpAndSettle();

    expect(AppData.unreadNotificationsCount, 1);
    expect(find.text('Marcar visto'), findsOneWidget);
  });

  testWidgets('newest notification is shown first in pending section', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildFamilySession(
      email: 'notifications-order@mascotify.local',
    );
    await _addPet(petId: 'pet-noti-first', petName: 'Primera Noti');
    await _addPet(petId: 'pet-noti-second', petName: 'Segunda Noti');

    expect(
      AppData.notifications.first.title,
      'Segunda Noti se agregó a tu cuenta',
    );

    await tester.pumpWidget(
      buildTestApp(const NotificationsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Segunda Noti se agregó a tu cuenta'), findsOneWidget);
    expect(find.text('Primera Noti se agregó a tu cuenta'), findsOneWidget);
  });
}

Future<TestAppSession> _buildFamilySession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Notifications Regression QA',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _addPet({required String petId, required String petName}) async {
  await AppData.addPet(
    MockData.pets.first.copyWith(
      id: petId,
      name: petName,
      profileId: 'MSC-$petId',
      qrCodeLabel: 'MSC-$petId',
    ),
  );
}
