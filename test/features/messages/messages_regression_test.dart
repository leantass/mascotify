import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/messages_inbox_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('multiple sent messages stay in the same conversation', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildMessagesSession(
      email: 'messages-multiple@mascotify.local',
    );
    await _createConversation(
      petId: 'pet-messages-multiple',
      petName: 'Lola Chat',
      initialMessage: 'Mensaje inicial de Lola.',
    );

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _openVisibleChat(tester);

    await _sendMessage(tester, 'Primer mensaje extra');
    await _sendMessage(tester, 'Segundo mensaje extra');

    expect(find.text('Primer mensaje extra'), findsOneWidget);
    expect(find.text('Segundo mensaje extra'), findsOneWidget);
    expect(AppData.messageThreads.single.messages.length, 3);
  });

  testWidgets('two conversations keep their messages separated', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildMessagesSession(
      email: 'messages-separated@mascotify.local',
    );
    await _createConversation(
      petId: 'pet-chat-one',
      petName: 'Roma Chat',
      initialMessage: 'Mensaje exclusivo de Roma.',
    );
    await _createConversation(
      petId: 'pet-chat-two',
      petName: 'Simona Chat',
      initialMessage: 'Mensaje exclusivo de Simona.',
    );

    expect(AppData.messageThreads.length, 2);
    final romaThread = AppData.messageThreads.firstWhere(
      (thread) => thread.pet.name == 'Roma Chat',
    );
    final simonaThread = AppData.messageThreads.firstWhere(
      (thread) => thread.pet.name == 'Simona Chat',
    );

    expect(romaThread.messages.single.text, 'Mensaje exclusivo de Roma.');
    expect(simonaThread.messages.single.text, 'Mensaje exclusivo de Simona.');

    await AppData.sendMessage(romaThread.id, 'Solo Roma actualizado');
    expect(
      AppData.findMessageThreadById(romaThread.id)?.lastMessage,
      'Solo Roma actualizado',
    );
    expect(
      AppData.findMessageThreadById(simonaThread.id)?.lastMessage,
      'Mensaje exclusivo de Simona.',
    );

    await tester.pumpWidget(
      buildTestApp(const MessagesInboxScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Solo Roma actualizado'), findsOneWidget);
    expect(find.text('Mensaje exclusivo de Simona.'), findsOneWidget);
  });

  testWidgets('conversations persist after reconstruction with local order', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await _buildMessagesSession(email: 'messages-order@mascotify.local');
    await _createConversation(
      petId: 'pet-order-one',
      petName: 'Primera Orden',
      initialMessage: 'Mensaje uno persistente.',
    );
    await _createConversation(
      petId: 'pet-order-two',
      petName: 'Segunda Orden',
      initialMessage: 'Mensaje dos persistente.',
    );

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );

    expect(AppData.messageThreads.length, 2);
    expect(AppData.messageThreads.first.pet.name, 'Segunda Orden');
    expect(AppData.messageThreads.last.pet.name, 'Primera Orden');

    await tester.pumpWidget(
      buildTestApp(
        const MessagesInboxScreen(),
        controller: restoredSession.controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mensaje dos persistente.'), findsOneWidget);
    expect(find.text('Mensaje uno persistente.'), findsOneWidget);
  });
}

Future<TestAppSession> _buildMessagesSession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Messages Regression QA',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _createConversation({
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
  final openChatButton = find.text('Abrir chat').first;
  await tester.ensureVisible(openChatButton);
  await tester.pumpAndSettle();
  await tester.tap(openChatButton);
  await tester.pumpAndSettle();
}

Future<void> _sendMessage(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText).last, text);
  await tester.tap(find.text('Enviar'));
  await tester.pumpAndSettle();
}
