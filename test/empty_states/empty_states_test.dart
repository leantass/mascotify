import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('new family account shows a clear empty pets state', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.register(
      ownerName: 'Familia Empty QA',
      email: 'empty-pets-qa@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mascotas'));
    await tester.pumpAndSettle();

    expect(find.textContaining('0 perfiles activos'), findsOneWidget);
    expect(find.textContaining('Todav'), findsOneWidget);
    expect(find.text('Agregar'), findsOneWidget);
    expect(find.text('Duna'), findsNothing);
    expect(find.text('Milo'), findsNothing);
  });
}
