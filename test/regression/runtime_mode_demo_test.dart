import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app_environment.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../test_helpers.dart';

void main() {
  test('app runtime starts in demo/local mode by default', () {
    expect(AppEnvironment.runtimeMode, AppRuntimeMode.demoLocal);
    expect(AppEnvironment.isDemoLocal, isTrue);
    expect(AppEnvironment.isProduction, isFalse);
    expect(AppEnvironment.runtimeLabel, 'Demo local');
  });

  testWidgets('auth screen shows the demo/local runtime signal', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Acceso demo'), findsOneWidget);
    expect(find.text('Demo local'), findsOneWidget);
  });

  testWidgets('demo family login keeps working in demo/local mode', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await _tapVisibleText(tester, 'Demo familiar');

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo familia'), findsWidgets);
    expect(AppEnvironment.isDemoLocal, isTrue);
  });

  testWidgets('demo professional login keeps working in demo/local mode', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await _tapVisibleText(tester, 'Demo profesional');

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo profesional'), findsWidgets);
    expect(AppEnvironment.isDemoLocal, isTrue);
  });

  testWidgets('profile explains local data storage for the runtime mode', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await _tapVisibleText(tester, 'Demo familiar');
    await _openTab(tester, 'Perfil');

    expect(find.text('Demo local'), findsWidgets);
    expect(
      find.textContaining('Los datos se guardan localmente en este entorno.'),
      findsOneWidget,
    );
    expect(find.textContaining('Integracion real disponible'), findsOneWidget);
  });

  test('demo/local mode keeps local persistence available', () async {
    final firstSession = await buildPersistentTestAppSession();
    await firstSession.controller.register(
      ownerName: 'Runtime Local',
      email: 'runtime-local@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await firstSession.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    final pet = MockData.pets.first.copyWith(
      id: 'pet-runtime-local',
      name: 'Runtime Persistente',
      profileId: 'profile-runtime-local',
    );
    await AppData.addPet(pet);

    await buildPersistentTestAppSession(resetPreferences: false);

    expect(AppEnvironment.isDemoLocal, isTrue);
    expect(AppData.findPetById(pet.id)?.name, 'Runtime Persistente');
  });

  testWidgets('main visible screens do not expose technical placeholder copy', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    _expectNoTechnicalText(tester);

    await _tapVisibleText(tester, 'Demo familiar');
    _expectNoTechnicalText(tester);

    for (final tab in ['Mascotas', 'Actividad', 'Explorar', 'Perfil']) {
      await _openTab(tester, tab);
      _expectNoTechnicalText(tester);
    }
  });
}

Future<void> _openTab(WidgetTester tester, String label) async {
  final finder = find.text(label).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  var finder = find.textContaining(text);
  for (var attempt = 0; attempt < 8 && finder.evaluate().isEmpty; attempt++) {
    final scrollables = find.byType(Scrollable);
    if (scrollables.evaluate().isEmpty) break;
    await tester.drag(scrollables.last, const Offset(0, -650));
    await tester.pumpAndSettle();
    finder = find.textContaining(text);
  }
  final visibleFinder = finder.first;
  await tester.ensureVisible(visibleFinder);
  await tester.pumpAndSettle();
  await tester.tap(visibleFinder);
  await tester.pumpAndSettle();
}

void _expectNoTechnicalText(WidgetTester tester) {
  final originalText = tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
      .join(' ');
  final visibleText = originalText.toLowerCase();

  for (final forbidden in ['fake', 'lorem', 'placeholder']) {
    expect(
      visibleText.contains(forbidden),
      isFalse,
      reason: 'No debe aparecer "$forbidden" en la UI visible.',
    );
  }
  expect(
    RegExp(r'\bTODO\b').hasMatch(originalText),
    isFalse,
    reason: 'No debe aparecer "TODO" en la UI visible.',
  );
}
