import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/auth/presentation/screens/auth_placeholder_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('demo family login remains authenticated after reconstruction', (
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

    expect(find.text('Modo familia'), findsWidgets);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(restoredSession.buildApp());
    await tester.pumpAndSettle();

    expect(restoredSession.controller.isAuthenticated, isTrue);
    expect(find.text('Modo familia'), findsWidgets);
    expect(find.text('Iniciar sesión'), findsNothing);
  });

  testWidgets(
    'demo professional login remains authenticated after reconstruction',
    (tester) async {
      setDesktopViewport(tester);
      final session = await buildPersistentTestAppSession();
      await session.controller.login(
        email: LocalAuthSeedData.professionalEmail,
        password: LocalAuthSeedData.demoPassword,
      );

      await tester.pumpWidget(session.buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Modo profesional'), findsWidgets);

      final restoredSession = await buildPersistentTestAppSession(
        resetPreferences: false,
      );
      await tester.pumpWidget(restoredSession.buildApp());
      await tester.pumpAndSettle();

      expect(restoredSession.controller.isAuthenticated, isTrue);
      expect(find.text('Modo profesional'), findsWidgets);
      expect(find.text('Iniciar sesión'), findsNothing);
    },
  );

  testWidgets('logout hides private family navigation', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Mascotas'), findsOneWidget);
    await session.controller.logout();
    await tester.pumpAndSettle();

    expect(session.controller.isAuthenticated, isFalse);
    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Mascotas'), findsNothing);
  });

  testWidgets('switching login and register keeps auth screen usable', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final controller = await buildTestAuthController();

    await tester.pumpWidget(
      buildTestApp(const AuthPlaceholderScreen(), controller: controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ingresar'), findsOneWidget);
    await tester.tap(find.text('Crear cuenta').first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Crear cuenta'), findsOneWidget);

    await tester.tap(find.text('Iniciar sesión').first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Ingresar'), findsOneWidget);
    expect(find.text('Demo familiar'), findsOneWidget);
    expect(controller.isAuthenticated, isFalse);
  });

  testWidgets('invalid registration does not create a local session', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(
      buildTestApp(
        const AuthPlaceholderScreen(),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear cuenta').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Crear cuenta'));
    await tester.pumpAndSettle();

    expect(session.controller.isAuthenticated, isFalse);
    expect(find.textContaining('Necesitamos tu nombre'), findsOneWidget);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    expect(restoredSession.controller.isAuthenticated, isFalse);
  });
}
