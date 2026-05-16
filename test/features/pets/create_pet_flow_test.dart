import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('user can create a pet from the UI', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mascotas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    await fillPetForm(tester, name: 'QA Mascota', age: '4');

    await tapSavePetForm(tester);

    expect(find.text('QA Mascota'), findsOneWidget);
    expect(find.textContaining('ya quedó guardado localmente'), findsOneWidget);
  });
}
