import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/presentation/screens/auth_placeholder_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/messages_inbox_screen.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/qr_traceability_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('mobile auth and onboarding remain usable at 390x844', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(
      buildTestApp(
        const AuthPlaceholderScreen(),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();
    _expectNoLayoutException(tester);

    await _ensureVisibleText(tester, 'Demo familiar');

    await _tapVisibleText(tester, 'Crear cuenta');
    expect(find.text('Crear cuenta'), findsWidgets);
    _expectNoLayoutException(tester);

    await session.controller.register(
      ownerName: 'Familia Mobile QA',
      email: 'mobile-onboarding-family@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Onboarding inicial'), findsWidgets);
    await _tapVisibleText(tester, 'Continuar como familia');
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Modo familia'), findsWidgets);
    _expectNoLayoutException(tester);
  });

  testWidgets('mobile family flow covers pets QR feed messages and profile', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(360, 800));
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await _tapVisibleText(tester, 'Demo familiar');
    expect(find.text('Inicio'), findsOneWidget);

    await _openMainTab(tester, 'Mascotas');
    expect(find.text('Centro de mascotas'), findsOneWidget);
    await _tapVisibleText(tester, 'Agregar');
    expect(find.byType(EditableText), findsWidgets);
    _expectNoLayoutException(tester);

    await _fillPetForm(tester, 'Mobile QA Pet');
    expect(find.text('Mobile QA Pet'), findsOneWidget);

    await _tapVisibleText(tester, 'Mobile QA Pet');
    expect(find.text('Detalle de mascota'), findsOneWidget);

    await _pumpScreen(
      tester,
      session,
      QrTraceabilityScreen(
        pet: AppData.pets.firstWhere((pet) => pet.name == 'Mobile QA Pet'),
      ),
    );
    expect(find.text('Historial QR'), findsOneWidget);
    _expectNoLayoutException(tester);
    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await _openMainTab(tester, 'Actividad');
    await _ensureVisibleText(tester, 'Feed general');
    await _enterLastEditableText(tester, 'Mobile QA Pet');
    expect(find.textContaining('Mascota creada'), findsWidgets);
    await _enterLastEditableText(tester, 'sin resultados mobile');
    expect(find.text('No hay actividad para esos filtros'), findsOneWidget);
    _expectNoLayoutException(tester);

    await _openMainTab(tester, 'Inicio');
    await _tapVisibleText(tester, 'Abrir mensajes');
    await _ensureVisibleText(tester, 'Conversaciones activas');
    _expectNoLayoutException(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Ver actividad');
    expect(find.text('Actividad'), findsWidgets);
    _expectNoLayoutException(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await _openMainTab(tester, 'Perfil');
    expect(find.text('Cuenta base'), findsOneWidget);
    _expectNoLayoutException(tester);
    await _tapVisibleText(tester, 'Notificaciones');
    expect(find.textContaining('estrat'), findsWidgets);
    _expectNoLayoutException(tester);
    await _tapVisibleText(tester, 'Configuraci');
    expect(find.text('Privacidad'), findsOneWidget);
    _expectNoLayoutException(tester);
  });

  testWidgets('mobile professional onboarding reaches workspace at 412x915', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(412, 915));
    final session = await buildPersistentTestAppSession();

    await session.controller.register(
      ownerName: 'Profesional Mobile QA',
      email: 'mobile-onboarding-professional@mascotify.local',
      city: 'Cordoba',
      password: 'password123',
      experience: AccountExperience.professional,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Onboarding inicial'), findsWidgets);
    await _tapVisibleText(tester, 'Continuar como profesional');
    expect(find.text('Modo profesional'), findsWidgets);
    expect(find.text('Servicios'), findsWidgets);

    await _openMainTab(tester, 'Actividad');
    expect(find.text('Feed general'), findsOneWidget);
    await _openMainTab(tester, 'Perfil');
    expect(find.text('Cuenta base'), findsOneWidget);
    _expectNoLayoutException(tester);
  });

  testWidgets(
    'mobile direct screens keep empty and populated states readable',
    (tester) async {
      _setMobileViewport(tester, const Size(390, 844));
      final session = await _registerFamilySession(
        email: 'mobile-direct-screens@mascotify.local',
      );
      final pet = _pet(id: 'pet-mobile-direct', name: 'Direct Mobile');
      await AppData.addPet(pet);
      await AppData.expressInterest(
        petId: pet.id,
        interestType: 'Vinculo social',
        message: 'Consulta mobile desde QA.',
      );
      await AppData.registerQrTraceabilityReview(pet.id);

      await _pumpScreen(tester, session, const PetsScreen());
      expect(find.text('Direct Mobile'), findsOneWidget);
      _expectNoLayoutException(tester);

      await _pumpScreen(tester, session, const ActivityFeedScreen());
      await _ensureVisibleText(tester, 'Feed general');
      await _ensureVisibleText(tester, 'Historial QR revisado');
      _expectNoLayoutException(tester);

      await _pumpScreen(tester, session, const MessagesInboxScreen());
      await _ensureVisibleText(tester, 'Conversaciones activas');
      await _tapVisibleText(tester, 'Abrir chat');
      await _ensureVisibleText(tester, 'Consulta mobile desde QA.');
      await _enterLastEditableText(tester, 'Respuesta mobile');
      await _tapVisibleText(tester, 'Enviar');
      expect(find.text('Respuesta mobile'), findsOneWidget);
      _expectNoLayoutException(tester);

      await _pumpScreen(tester, session, const NotificationsScreen());
      expect(AppData.notifications, isNotEmpty);
      expect(find.byType(Scaffold), findsWidgets);
      _expectNoLayoutException(tester);
    },
  );
}

Future<TestAppSession> _registerFamilySession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Familia Mobile Directa',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _pumpScreen(
  WidgetTester tester,
  TestAppSession session,
  Widget screen,
) async {
  await tester.pumpWidget(buildTestApp(screen, controller: session.controller));
  await tester.pumpAndSettle();
}

Future<void> _openMainTab(WidgetTester tester, String label) async {
  final destination = find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  if (destination.evaluate().isNotEmpty) {
    await tester.tap(destination);
    await tester.pumpAndSettle();
    return;
  }

  await _tapVisibleText(tester, label);
}

Future<void> _fillPetForm(WidgetTester tester, String name) async {
  final fields = find.byType(EditableText);
  await tester.enterText(fields.at(0), name);
  await tester.enterText(fields.at(2), 'Mestizo');
  await tester.enterText(fields.at(3), '3');
  await tester.enterText(fields.at(4), 'Buenos Aires');
  await _tapVisibleText(tester, 'Guardar');
}

Future<void> _enterLastEditableText(WidgetTester tester, String text) async {
  final field = find.byType(EditableText).last;
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, text);
  await tester.pumpAndSettle();
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  await _ensureVisibleText(tester, text);
  final visibleFinder = find.textContaining(text).first;
  await tester.tap(visibleFinder);
  await tester.pumpAndSettle();
}

Future<void> _ensureVisibleText(WidgetTester tester, String text) async {
  var finder = find.textContaining(text);
  for (var attempt = 0; attempt < 10 && finder.evaluate().isEmpty; attempt++) {
    final scrollables = find.byType(Scrollable);
    if (scrollables.evaluate().isEmpty) break;
    await tester.drag(scrollables.first, const Offset(0, -550));
    await tester.pumpAndSettle();
    finder = find.textContaining(text);
  }

  expect(finder, findsWidgets);

  final visibleFinder = finder.first;
  await tester.ensureVisible(visibleFinder);
  await tester.pumpAndSettle();
}

void _setMobileViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _expectNoLayoutException(WidgetTester tester) {
  final exception = tester.takeException();
  final details = exception is FlutterError
      ? exception.diagnostics.map((node) => node.toStringDeep()).join('\n')
      : exception.toString();
  expect(exception, isNull, reason: details);
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}
