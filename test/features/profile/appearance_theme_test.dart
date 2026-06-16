import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/theme/app_theme_controller.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/features/home/presentation/screens/home_screen.dart';
import 'package:mascotify/features/profile/presentation/screens/profile_screen.dart';
import 'package:mascotify/theme/app_colors.dart';
import 'package:mascotify/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';

void main() {
  test('dark theme keeps cards and secondary surfaces in dark slate tones', () {
    final theme = AppTheme.dark();
    final palette = theme.extension<MascotifyPalette>()!;

    expect(theme.cardTheme.color, isNot(AppColors.surface));
    expect(theme.cardTheme.color!.computeLuminance(), lessThan(0.08));
    expect(palette.surfaceAlt.computeLuminance(), lessThan(0.12));
    expect(palette.primarySoft.computeLuminance(), lessThan(0.08));
    expect(palette.accentSoft.computeLuminance(), lessThan(0.08));
    expect(palette.supportSoft.computeLuminance(), lessThan(0.08));
  });

  testWidgets('dark theme maps light accent surfaces to slate-friendly tones', (
    tester,
  ) async {
    late Color mappedWhite;
    late Color mappedPrimary;
    late Color mappedAccent;
    late Color mappedSupport;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Builder(
          builder: (context) {
            mappedWhite = mascotifyTone(context, Colors.white);
            mappedPrimary = mascotifyTone(context, AppColors.primarySoft);
            mappedAccent = mascotifyTone(context, AppColors.accentSoft);
            mappedSupport = mascotifyTone(context, AppColors.supportSoft);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(mappedWhite.computeLuminance(), lessThan(0.12));
    expect(mappedPrimary.computeLuminance(), lessThan(0.08));
    expect(mappedAccent.computeLuminance(), lessThan(0.08));
    expect(mappedSupport.computeLuminance(), lessThan(0.08));
  });

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

  testWidgets('Home renderiza chips y cards principales en modo oscuro', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );
    await session.themeController.setMode(MascotifyThemeMode.dark);

    await tester.pumpWidget(
      buildTestApp(
        const HomeScreen(),
        controller: session.controller,
        localeController: session.localeController,
        themeController: session.themeController,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Modo familia'), findsOneWidget);
    expect(find.textContaining('focos activos'), findsOneWidget);
    expect(find.text('Mascotas activas'), findsOneWidget);
    expect(find.textContaining('Puntos de atenci'), findsOneWidget);
    expect(find.textContaining('requiere atenci'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Explorar renderiza tabs, hero y cards sociales en modo oscuro', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );
    await session.themeController.setMode(MascotifyThemeMode.dark);

    await tester.pumpWidget(
      buildTestApp(
        const ExploreScreen(),
        controller: session.controller,
        localeController: session.localeController,
        themeController: session.themeController,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema'), findsOneWidget);
    expect(find.text('Clips'), findsOneWidget);
    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(find.text('Matching futuro'), findsOneWidget);
    expect(find.text('Perfiles visibles'), findsOneWidget);
    expect(find.text('Conexiones seguras'), findsOneWidget);
    expect(find.text('Voces expertas'), findsOneWidget);
    expect(find.text('Bandeja social'), findsOneWidget);
    expect(find.text('Profesionales pet'), findsOneWidget);
    expect(find.text('Recibidos'), findsOneWidget);
    expect(find.text('Enviados'), findsOneWidget);
    expect(find.text('Profesionales'), findsOneWidget);
    expect(find.text('Contenidos'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
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
