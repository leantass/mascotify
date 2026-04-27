import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/presentation/screens/auth_placeholder_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('auth screen renders login controls and demo access', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1365, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = await buildTestAuthController();

    await tester.pumpWidget(
      buildTestApp(const AuthPlaceholderScreen(), controller: controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Crear cuenta'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Demo familiar'), findsOneWidget);
    expect(find.text('Demo profesional'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
  });
}
