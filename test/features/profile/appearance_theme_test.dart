import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/theme/app_theme_controller.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/profile/presentation/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';

void main() {
  test('theme controller persists the selected mode locally', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final controller = AppThemeController(preferences: preferences);

    expect(controller.mode, MascotifyThemeMode.system);
    expect(controller.materialThemeMode, ThemeMode.system);

    await controller.setMode(MascotifyThemeMode.dark);
    expect(controller.mode, MascotifyThemeMode.dark);
    expect(controller.materialThemeMode, ThemeMode.dark);

    final restored = AppThemeController(preferences: preferences);
    expect(restored.mode, MascotifyThemeMode.dark);
    expect(restored.materialThemeMode, ThemeMode.dark);
  });

  testWidgets('Configuracion permite cambiar entre modo oscuro y claro', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await _pumpProfileScreen(tester, session);
    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();

    final dropdown = find.byKey(const ValueKey('appearance-theme-dropdown'));
    await Scrollable.ensureVisible(
      tester.element(dropdown),
      alignment: 0.55,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();

    expect(find.text('Apariencia'), findsOneWidget);
    expect(find.text('Usar sistema'), findsWidgets);

    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modo oscuro').last);
    await tester.pumpAndSettle();

    expect(session.themeController.mode, MascotifyThemeMode.dark);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modo claro').last);
    await tester.pumpAndSettle();

    expect(session.themeController.mode, MascotifyThemeMode.light);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });
}

Future<void> _pumpProfileScreen(
  WidgetTester tester,
  TestAppSession session,
) async {
  await tester.pumpWidget(
    buildTestApp(
      const ProfileScreen(),
      controller: session.controller,
      localeController: session.localeController,
      themeController: session.themeController,
    ),
  );
  await tester.pumpAndSettle();
  await tester.drag(
    find.byType(Scrollable).first,
    const Offset(0, -900),
    warnIfMissed: false,
  );
  await tester.pumpAndSettle();
  expect(find.text('Preferencias y plan'), findsOneWidget);
}
