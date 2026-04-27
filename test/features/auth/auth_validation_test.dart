import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/presentation/screens/auth_placeholder_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('empty login stays on auth and shows feedback', (tester) async {
    setDesktopViewport(tester);
    final controller = await buildTestAuthController();

    await tester.pumpWidget(
      buildTestApp(const AuthPlaceholderScreen(), controller: controller),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Demo familiar'), findsOneWidget);
    expect(find.textContaining('No encontramos'), findsOneWidget);
    expect(controller.isAuthenticated, isFalse);
  });

  testWidgets('invalid register data stays on auth and shows feedback', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final controller = await buildTestAuthController();

    await tester.pumpWidget(
      buildTestApp(const AuthPlaceholderScreen(), controller: controller),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear cuenta').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Crear cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('Demo familiar'), findsOneWidget);
    expect(find.textContaining('Necesitamos tu nombre'), findsOneWidget);
    expect(controller.isAuthenticated, isFalse);
  });
}
