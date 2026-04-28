import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('profile visibility preference persists by account', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _buildProfileSession(
      ownerName: 'Perfil Uno',
      email: 'profile-visibility-one@mascotify.local',
    );

    expect(AppData.currentUser.publicProfileEnabled, isTrue);
    await AppData.setPublicProfileEnabled(false);
    expect(AppData.currentUser.publicProfileEnabled, isFalse);

    await _buildProfileSession(
      ownerName: 'Perfil Dos',
      email: 'profile-visibility-two@mascotify.local',
      resetPreferences: false,
    );

    expect(AppData.currentUser.publicProfileEnabled, isTrue);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await restoredSession.controller.login(
      email: 'profile-visibility-one@mascotify.local',
      password: 'password123',
    );
    await AppData.syncCurrentUserState();

    expect(AppData.currentUser.publicProfileEnabled, isFalse);
  });

  testWidgets('message notification preference survives logout and login', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildProfileSession(
      ownerName: 'Mensajes Perfil',
      email: 'profile-messages-login@mascotify.local',
    );

    await AppData.setMessagesNotificationsEnabled(false);
    expect(AppData.currentUser.messagesNotificationsEnabled, isFalse);

    await session.controller.logout();
    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsWidgets);

    await session.controller.login(
      email: 'profile-messages-login@mascotify.local',
      password: 'password123',
    );
    await AppData.syncCurrentUserState();

    expect(AppData.currentUser.messagesNotificationsEnabled, isFalse);
  });

  testWidgets('local plan selection is isolated between accounts', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _buildProfileSession(
      ownerName: 'Plan Uno',
      email: 'profile-plan-one@mascotify.local',
    );
    await AppData.setPlanName('Mascotify Pro');
    expect(AppData.currentUser.planName, 'Mascotify Pro');

    await _buildProfileSession(
      ownerName: 'Plan Dos',
      email: 'profile-plan-two@mascotify.local',
      resetPreferences: false,
    );

    expect(AppData.currentUser.planName, 'Mascotify Plus');
  });
}

Future<TestAppSession> _buildProfileSession({
  required String ownerName,
  required String email,
  bool resetPreferences = true,
}) async {
  final session = await buildPersistentTestAppSession(
    resetPreferences: resetPreferences,
  );
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
