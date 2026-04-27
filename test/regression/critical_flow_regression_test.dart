import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('critical family flow navigates and logs out', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo familiar'));
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

    final logoutButton = find.widgetWithText(OutlinedButton, 'Cerrar sesión');
    for (
      var attempt = 0;
      attempt < 5 && logoutButton.evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(logoutButton);
    await tester.pumpAndSettle();
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Demo familiar'), findsOneWidget);
    expect(find.text('Mascotas'), findsNothing);
  });
}
