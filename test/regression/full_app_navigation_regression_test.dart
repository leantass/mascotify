import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('demo family can navigate core sections and logout', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo familia'), findsWidgets);

    await tester.tap(find.text('Mascotas'));
    await tester.pumpAndSettle();
    expect(find.text('Centro de mascotas'), findsOneWidget);

    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();
    expect(find.text('Ecosistema social'), findsOneWidget);

    await tester.tap(find.text('Abrir bandeja social'));
    await tester.pumpAndSettle();
    expect(find.text('Bandeja social'), findsWidgets);

    await tester.tap(find.text('Abrir mensajería'));
    await tester.pumpAndSettle();
    expect(find.text('Conversaciones activas'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver actividad'));
    await tester.pumpAndSettle();
    expect(find.text('Actividad y notificaciones'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Cuenta base'), findsOneWidget);

    await session.controller.logout();
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Perfil'), findsNothing);
  });
}
