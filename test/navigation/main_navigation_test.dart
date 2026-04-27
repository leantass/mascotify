import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('family navigation opens the main sections', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);

    await tester.tap(find.text('Mascotas'));
    await tester.pumpAndSettle();
    expect(find.text('Centro de mascotas'), findsOneWidget);

    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();
    expect(find.text('Ecosistema social'), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Cuenta base'), findsOneWidget);
    expect(find.text('Perfil activo'), findsOneWidget);
  });
}
