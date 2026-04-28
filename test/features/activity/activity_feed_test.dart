import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('new account shows an empty activity feed state', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-empty@mascotify.local',
    );

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Feed general'), findsOneWidget);
    expect(find.textContaining('Todavia no hay actividad'), findsOneWidget);
    expect(AppData.ecosystemActivityFeed, isEmpty);
  });

  testWidgets('created pet appears in the activity feed', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-pet-created@mascotify.local',
    );
    await AppData.addPet(_pet(id: 'pet-feed-created', name: 'Feed Creado'));

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mascota creada'), findsOneWidget);
    expect(find.textContaining('Feed Creado'), findsWidgets);
  });

  testWidgets('updated pet appears in the activity feed', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-pet-updated@mascotify.local',
    );
    final pet = _pet(id: 'pet-feed-updated', name: 'Feed Editable');
    await AppData.addPet(pet);
    await AppData.updatePet(pet.copyWith(name: 'Feed Editado'));

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Perfil actualizado'), findsOneWidget);
    expect(find.textContaining('Feed Editado'), findsWidgets);
  });

  testWidgets('messages and conversations appear in the activity feed', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-message@mascotify.local',
    );
    final pet = _pet(id: 'pet-feed-message', name: 'Feed Mensaje');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Mensaje inicial para el feed.',
    );
    final thread = AppData.findMessageThreadForPet(pet)!;
    await AppData.sendMessage(thread.id, 'Mensaje final del feed.');

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mensaje enviado'), findsOneWidget);
    expect(
      find.text('Conversacion con Contacto por Feed Mensaje'),
      findsOneWidget,
    );
    expect(find.text('Mensaje final del feed.'), findsWidgets);
  });

  testWidgets('internal notification appears in the activity feed', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-notification@mascotify.local',
    );
    await AppData.addPet(
      _pet(id: 'pet-feed-notification', name: 'Feed Notificacion'),
    );
    final notificationTitle = AppData.notifications.first.title;

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text(notificationTitle), findsOneWidget);
    expect(find.text('Notificacion'), findsWidgets);
  });

  testWidgets('activity feed persists after reconstruction', (tester) async {
    setDesktopViewport(tester);
    await _buildActivitySession(email: 'activity-persist@mascotify.local');
    await AppData.addPet(
      _pet(id: 'pet-feed-persist', name: 'Feed Persistente'),
    );

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(
      buildTestApp(
        const ActivityFeedScreen(),
        controller: restoredSession.controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mascota creada'), findsOneWidget);
    expect(find.textContaining('Feed Persistente'), findsWidgets);
  });

  testWidgets('activity feed is isolated by account', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      ownerName: 'Cuenta Feed Uno',
      email: 'activity-account-one@mascotify.local',
    );
    await AppData.addPet(_pet(id: 'pet-feed-account-one', name: 'Feed Ajeno'));

    await session.controller.register(
      ownerName: 'Cuenta Feed Dos',
      email: 'activity-account-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Feed Ajeno'), findsNothing);
    expect(find.textContaining('Todavia no hay actividad'), findsOneWidget);
  });

  testWidgets('pet activity opens pet detail from the feed', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-open-pet@mascotify.local',
    );
    await AppData.addPet(_pet(id: 'pet-feed-open', name: 'Feed Navegable'));

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Mascota creada');

    expect(find.text('Detalle de mascota'), findsOneWidget);
    expect(find.text('Feed Navegable'), findsWidgets);
  });

  testWidgets('message activity opens conversation from the feed', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-open-message@mascotify.local',
    );
    final pet = _pet(id: 'pet-feed-open-message', name: 'Feed Chat');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Conversacion abierta desde feed.',
    );

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    await _tapVisible(tester, 'Conversacion con Contacto por Feed Chat');

    expect(find.textContaining('Convers'), findsWidgets);
    expect(find.text('Contacto por Feed Chat'), findsWidgets);
    expect(find.text('Conversacion abierta desde feed.'), findsOneWidget);
  });
}

Future<TestAppSession> _buildActivitySession({
  String ownerName = 'Familia Feed',
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

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}

Future<void> _tapVisible(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
