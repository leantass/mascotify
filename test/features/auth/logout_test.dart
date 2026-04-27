import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('logout returns the user to the auth screen', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
    await tester.pumpAndSettle();
    final logoutButton = find.widgetWithText(OutlinedButton, 'Cerrar sesión');
    await tester.ensureVisible(logoutButton);
    await tester.pumpAndSettle();

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Crear cuenta'), findsWidgets);
    expect(find.text('Mascotas'), findsNothing);
  });
}
