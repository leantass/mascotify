import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/messages_inbox_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('new family account shows a clear empty messages inbox', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildMessagesSession(
      ownerName: 'Familia Mensajes Vacios',
      email: 'empty-messages-qa@mascotify.local',
    );

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conversaciones activas'), findsOneWidget);
    expect(find.textContaining('Todav'), findsOneWidget);
    expect(find.text('Abrir chat'), findsNothing);
    expect(find.text('Milo'), findsNothing);
  });

  testWidgets('sent message remains visible after app reconstruction', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final firstSession = await _buildMessagesSession(
      ownerName: 'Familia Mensajes Persistentes',
      email: 'messages-persist-qa@mascotify.local',
    );
    await _createLocalConversation(
      petId: 'pet-messages-persist',
      petName: 'Luna Mensajes',
      initialMessage: 'Hola, queremos abrir este hilo local.',
    );

    await tester.pumpWidget(
      buildTestApp(
        const MessagesInboxScreen(),
        controller: firstSession.controller,
      ),
    );
    await tester.pumpAndSettle();

    await _openVisibleChat(tester);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).last,
      'Mensaje persistente QA',
    );
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(find.text('Mensaje persistente QA'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(
      buildTestApp(
        const MessagesInboxScreen(),
        controller: restoredSession.controller,
      ),
    );
    await tester.pumpAndSettle();

    await _openVisibleChat(tester);
    await tester.pumpAndSettle();

    expect(find.text('Mensaje persistente QA'), findsOneWidget);
  });

  testWidgets('inbox updates the last message after returning from chat', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildMessagesSession(
      ownerName: 'Familia Ultimo Mensaje',
      email: 'messages-last-qa@mascotify.local',
    );
    await _createLocalConversation(
      petId: 'pet-last-message',
      petName: 'Nala Ultimo',
      initialMessage: 'Mensaje inicial del hilo.',
    );

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ultimo mensaje QA'), findsNothing);

    await _openVisibleChat(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, 'Ultimo mensaje QA');
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Ultimo mensaje QA'), findsOneWidget);
  });

  testWidgets('local conversations are isolated by account', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildMessagesSession(
      ownerName: 'Familia Cuenta Uno',
      email: 'messages-account-one@mascotify.local',
    );
    await _createLocalConversation(
      petId: 'pet-account-one',
      petName: 'Tango Cuenta Uno',
      initialMessage: 'Mensaje de la cuenta uno.',
    );

    await session.controller.register(
      ownerName: 'Familia Cuenta Dos',
      email: 'messages-account-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tango Cuenta Uno'), findsNothing);
    expect(find.text('Mensaje de la cuenta uno.'), findsNothing);
    expect(find.text('Abrir chat'), findsNothing);
    expect(find.textContaining('Todav'), findsOneWidget);
  });
}

Future<TestAppSession> _buildMessagesSession({
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

Future<void> _createLocalConversation({
  required String petId,
  required String petName,
  required String initialMessage,
}) async {
  await AppData.addPet(
    MockData.pets.first.copyWith(
      id: petId,
      name: petName,
      profileId: 'MSC-$petId',
      qrCodeLabel: 'MSC-$petId',
    ),
  );
  await AppData.expressInterest(
    petId: petId,
    interestType: 'Vinculo social',
    message: initialMessage,
  );
}

Future<void> _openVisibleChat(WidgetTester tester) async {
  final openChatButton = find.text('Abrir chat');
  await tester.ensureVisible(openChatButton);
  await tester.pumpAndSettle();
  await tester.tap(openChatButton);
  await tester.pumpAndSettle();
}
