import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/profile/presentation/screens/support_contacts_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('Configuración muestra Contactos y abre la sección', (
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

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();

    expect(find.text('Contactos'), findsOneWidget);

    final contactsAction = find.byKey(
      const ValueKey('settings-contacts-action'),
    );
    await Scrollable.ensureVisible(
      tester.element(contactsAction),
      alignment: 0.8,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    await tester.tap(contactsAction);
    await tester.pumpAndSettle();

    expect(find.text('Contactos'), findsWidgets);
    expect(find.text('Soporte al cliente'), findsOneWidget);
    expect(find.text('Reportar un problema'), findsOneWidget);
    expect(find.text('Ayuda / Preguntas frecuentes'), findsOneWidget);
  });

  testWidgets('Soporte al cliente muestra acciones de ayuda', (tester) async {
    await tester.pumpWidget(buildTestApp(const CustomerSupportScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Soporte al cliente'), findsWidgets);
    expect(find.text('Enviar email a soporte'), findsOneWidget);
    expect(find.text('Contactar por WhatsApp'), findsOneWidget);
    expect(find.text('Reportar un problema'), findsOneWidget);
    expect(find.text('Ver preguntas frecuentes'), findsOneWidget);
    expect(find.textContaining('No compartas contraseñas'), findsOneWidget);
  });

  testWidgets('Reportar un problema abre formulario y valida descripción', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const SupportContactsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('contacts-report-problem-action')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reportar un problema'), findsWidgets);
    expect(
      find.byKey(const ValueKey('support-report-type-field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('support-report-description-field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('support-report-contact-field')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('support-report-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('La descripción es requerida.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('support-report-description-field')),
      'El QR no abre el perfil público desde mi teléfono.',
    );
    await tester.tap(
      find.byKey(const ValueKey('support-report-submit-button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Gracias. Registramos tu reporte para revisión.'),
      findsOneWidget,
    );
  });

  testWidgets('Contactos no desborda en mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp(const SupportContactsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Contactos'), findsWidgets);
    expect(find.byType(SupportContactsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
