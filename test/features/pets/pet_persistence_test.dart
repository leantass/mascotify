import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('created pet remains visible after app reconstruction', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final firstSession = await buildPersistentTestAppSession();
    await firstSession.controller.register(
      ownerName: 'Persistencia QA',
      email: 'persistencia-qa@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await firstSession.controller.completeOnboarding();

    await tester.pumpWidget(firstSession.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    await fillPetForm(
      tester,
      name: 'Persistente QA',
      breed: 'Criollo',
      age: '5',
      manualCity: 'Córdoba',
    );
    await tapSavePetForm(tester);

    expect(find.text('Persistente QA'), findsOneWidget);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(restoredSession.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mascotas').first);
    await tester.pumpAndSettle();

    expect(find.text('Persistente QA'), findsOneWidget);
  });
}
