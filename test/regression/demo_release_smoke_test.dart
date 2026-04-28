import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('demo family route supports the main presentation flow', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Demo familiar');
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo familia'), findsWidgets);

    await _openTab(tester, 'Mascotas');
    expect(find.text('Centro de mascotas'), findsOneWidget);
    expect(find.text('Mascotas'), findsWidgets);

    await _openTab(tester, 'Actividad');
    expect(find.text('Feed general'), findsOneWidget);

    await _openTab(tester, 'Inicio');
    await _tapVisibleText(tester, 'Ver actividad');
    expect(find.text('Actividad y notificaciones'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Abrir mensajes');
    expect(find.text('Conversaciones activas'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _openTab(tester, 'Perfil');
    expect(find.text('Cuenta base'), findsOneWidget);
    await _logoutFromProfile(tester);

    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Perfil'), findsNothing);
  });

  testWidgets(
    'demo professional route supports dashboard workspace and profile',
    (tester) async {
      setDesktopViewport(tester);
      final session = await buildPersistentTestAppSession();

      await tester.pumpWidget(session.buildApp());
      await tester.pumpAndSettle();

      await _tapVisibleText(tester, 'Demo profesional');
      expect(find.text('Modo profesional'), findsWidgets);

      await _openTab(tester, 'Servicios');
      expect(find.text('Servicios contemplados'), findsOneWidget);
      if (find.text('Activar presencia profesional').evaluate().isNotEmpty) {
        await _tapVisibleText(tester, 'Activar presencia profesional');
      }
      await _tapVisibleText(tester, 'perfil');
      expect(find.text('Perfil profesional'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await _openTab(tester, 'Actividad');
      expect(find.text('Feed general'), findsOneWidget);

      await _openTab(tester, 'Perfil');
      expect(find.text('Cuenta base'), findsOneWidget);
      await _logoutFromProfile(tester);

      expect(find.text('Iniciar sesión'), findsWidgets);
      expect(find.text('Servicios'), findsNothing);
    },
  );

  testWidgets(
    'main demo screens do not expose basic technical placeholder text',
    (tester) async {
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
    },
  );

  testWidgets('central route smoke leaves every main section with content', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await _tapVisibleText(tester, 'Demo familiar');

    final checks = <String, String>{
      'Inicio': 'Mascotify',
      'Mascotas': 'Centro de mascotas',
      'Explorar': 'Ecosistema social',
      'Actividad': 'Feed general',
      'Perfil': 'Cuenta base',
    };

    for (final entry in checks.entries) {
      await _openTab(tester, entry.key);
      expect(find.textContaining(entry.value), findsWidgets);
      expect(find.byType(Scaffold), findsWidgets);
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

Future<void> _logoutFromProfile(WidgetTester tester) async {
  final logoutButton = find.widgetWithText(OutlinedButton, 'Cerrar sesión');
  for (
    var attempt = 0;
    attempt < 6 && logoutButton.evaluate().isEmpty;
    attempt++
  ) {
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(logoutButton);
  await tester.pumpAndSettle();
  await tester.tap(logoutButton);
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

  for (final forbidden in ['lorem', 'placeholder', 'debug', 'fake']) {
    expect(
      visibleText.contains(forbidden),
      isFalse,
      reason: 'No debe aparecer "$forbidden" en la UI visible de demo.',
    );
  }
  expect(
    RegExp(r'\bTODO\b').hasMatch(originalText),
    isFalse,
    reason: 'No debe aparecer "TODO" en la UI visible de demo.',
  );
}
