import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app_environment.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/qr_scan_event_detail_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/qr_traceability_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/secure_qr_scan_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/lost_pet.dart';
import 'package:mascotify/shared/models/pet.dart';
import 'package:mascotify/shared/models/report_models.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('pet QR code persists after reconstruction', (tester) async {
    await _buildQrSession(email: 'qr-persist@mascotify.local');
    await AppData.addPet(_pet(id: 'pet-qr-persist', name: 'QR Persistente'));
    final qrCode = AppData.pets.single.qrCodeLabel;

    await buildPersistentTestAppSession(resetPreferences: false);

    expect(AppData.pets.single.qrCodeLabel, qrCode);
  });

  testWidgets('editing a pet does not change its QR code', (tester) async {
    await _buildQrSession(email: 'qr-edit@mascotify.local');
    final pet = _pet(id: 'pet-qr-edit', name: 'QR Editable');
    await AppData.addPet(pet);
    final qrCode = AppData.pets.single.qrCodeLabel;

    await AppData.updatePet(AppData.pets.single.copyWith(name: 'QR Editada'));

    expect(AppData.pets.single.qrCodeLabel, qrCode);
  });

  testWidgets('two pets keep distinct QR codes', (tester) async {
    await _buildQrSession(email: 'qr-distinct@mascotify.local');
    await AppData.addPet(_pet(id: 'pet-qr-one', name: 'QR Uno'));
    await AppData.addPet(_pet(id: 'pet-qr-two', name: 'QR Dos'));

    final codes = AppData.pets.map((pet) => pet.qrCodeLabel).toSet();

    expect(codes.length, 2);
  });

  testWidgets('QR generates configurable public URL fallback', (tester) async {
    await _buildQrSession(email: 'qr-public-url@mascotify.local');
    final pet = _pet(id: 'pet-qr-public-url', name: 'QR Link Publico');
    await AppData.addPet(pet);

    expect(
      AppEnvironment.publicQrUrlFor(pet.qrCodeLabel),
      '/pet/qr/${pet.qrCodeLabel}',
    );
  });

  testWidgets('QR URL helper supports public and LAN base URLs', (
    tester,
  ) async {
    expect(
      AppEnvironment.publicQrUrlFor(
        'MSC-123',
        overrideBaseUrl: 'https://mascotify.example',
      ),
      'https://mascotify.example/q/MSC-123',
    );
    expect(
      AppEnvironment.qrPublicLinkMode(
        overrideBaseUrl: 'https://mascotify.example',
      ),
      QrPublicLinkMode.publicReady,
    );
    expect(
      AppEnvironment.qrPublicLinkMode(
        overrideBaseUrl: 'http://192.168.1.20:53177',
      ),
      QrPublicLinkMode.lanTesting,
    );
    expect(
      AppEnvironment.qrPublicLinkMode(
        overrideBaseUrl: 'http://127.0.0.1:53177',
      ),
      QrPublicLinkMode.localDemo,
    );
  });

  testWidgets('pet QR screen encodes visible local demo URL', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildQrSession(email: 'qr-screen@mascotify.local');
    final pet = _pet(id: 'pet-qr-screen', name: 'QR Pantalla');
    await AppData.addPet(pet);

    await tester.pumpWidget(
      buildTestApp(PetDetailScreen(pet: pet), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('QR Mascotify'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final encodedUrl = '/pet/qr/${pet.qrCodeLabel}';
    expect(find.text('QR local/demo'), findsOneWidget);
    expect(find.text(encodedUrl), findsWidgets);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.byKey(const ValueKey('public-qr-image')), findsOneWidget);
    expect(
      find.textContaining('necesita una URL pública configurada'),
      findsOneWidget,
    );
    _expectNoLayoutException(tester);
  });

  testWidgets('public /q route opens secure scan without private data', (
    tester,
  ) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(
      ownerName: 'Dueña Ruta Privada',
      email: 'duenia-ruta@mascotify.local',
    );
    final pet = _pet(id: 'pet-qr-route', name: 'QR Ruta');
    await AppData.addPet(pet);

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/q/${pet.qrCodeLabel}');
    await tester.pumpAndSettle();

    expect(find.text('QR Ruta'), findsOneWidget);
    expect(find.text('Dueña Ruta Privada'), findsNothing);
    expect(find.text('duenia-ruta@mascotify.local'), findsNothing);
    expect(find.text('Cargar ubicación manual'), findsOneWidget);
    _expectNoLayoutException(tester);
  });

  testWidgets('opening traceability registers pet history event', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildQrSession(email: 'qr-history@mascotify.local');
    final pet = _pet(id: 'pet-qr-history', name: 'QR Historial');
    await AppData.addPet(pet);

    await tester.pumpWidget(
      buildTestApp(
        QrTraceabilityScreen(pet: pet),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();

    final events = AppData.petActivityEventsForPet(pet.id);
    expect(
      events.map((event) => event.title),
      contains('Historial QR revisado'),
    );
    expect(find.text('Historial QR'), findsOneWidget);
  });

  testWidgets('QR review appears in the general activity feed', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildQrSession(email: 'qr-feed@mascotify.local');
    final pet = _pet(id: 'pet-qr-feed', name: 'QR Feed');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);

    await tester.pumpWidget(
      buildTestApp(const ActivityFeedScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Historial QR revisado'), findsOneWidget);
    expect(find.text('QR'), findsWidgets);
  });

  testWidgets('local sighting report generates QR event and notification', (
    tester,
  ) async {
    await _buildQrSession(email: 'qr-report@mascotify.local');
    final pet = _pet(id: 'pet-qr-report', name: 'QR Reporte');
    await AppData.addPet(pet);

    await AppData.submitSightingReport(
      const SightingReportDraft(
        petId: 'pet-qr-report',
        locationLabel: 'Plaza local',
        notes: 'Se la vio tranquila.',
        condition: 'Parece estar bien',
        allowContact: true,
      ),
    );

    expect(
      AppData.petActivityEventsForPet(pet.id).map((event) => event.title),
      contains('Reporte QR registrado'),
    );
    expect(
      AppData.notifications.map((notification) => notification.title),
      contains('Avistamiento QR registrado para QR Reporte'),
    );
  });

  testWidgets('secure public QR screen hides owner private data', (
    tester,
  ) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(
      ownerName: 'Dueña Privada',
      email: 'duenia-privada@mascotify.local',
    );
    final pet = _pet(id: 'pet-qr-public-safe', name: 'QR Seguro');
    await AppData.addPet(pet);

    await tester.pumpWidget(
      buildTestApp(
        SecureQrScanScreen(qrId: pet.qrCodeLabel),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('QR Seguro'), findsOneWidget);
    expect(find.text('Avisar que encontré o vi esta mascota'), findsOneWidget);
    expect(find.text('Compartir ubicación actual'), findsOneWidget);
    expect(find.text('Cargar ubicación manual'), findsOneWidget);
    expect(find.text('Dueña Privada'), findsNothing);
    expect(find.text('duenia-privada@mascotify.local'), findsNothing);
    expect(find.textContaining('dirección privada'), findsOneWidget);
    _expectNoLayoutException(tester);
  });

  testWidgets('manual QR location creates event notification and detail', (
    tester,
  ) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(email: 'qr-manual@mascotify.local');
    final pet = _pet(id: 'pet-qr-manual', name: 'QR Manual');
    await AppData.addPet(pet);

    await tester.pumpWidget(
      buildTestApp(
        SecureQrScanScreen(qrId: pet.qrCodeLabel),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();
    await _enterByKey(
      tester,
      const ValueKey('qr-region-field'),
      'Buenos Aires',
    );
    await _enterByKey(tester, const ValueKey('qr-city-field'), 'CABA');
    await _enterByKey(
      tester,
      const ValueKey('qr-area-field'),
      'Parque Chacabuco',
    );
    await _enterByKey(
      tester,
      const ValueKey('qr-message-field'),
      'La vi cerca del canil.',
    );
    await _tapByKey(tester, const ValueKey('submit-secure-qr-scan-button'));

    expect(AppData.qrScanEventsForPet(pet.id), hasLength(1));
    expect(
      AppData.notifications.map((notification) => notification.title),
      contains('Alguien escaneó el QR de QR Manual.'),
    );
    expect(
      AppData.petActivityEventsForPet(pet.id).map((event) => event.title),
      contains('QR escaneado con ubicación'),
    );
    expect(
      find.text('Gracias. Avisamos a la familia con la información cargada.'),
      findsOneWidget,
    );

    await _tapByKey(tester, const ValueKey('open-qr-event-detail-button'));
    expect(find.text('Detalle del evento QR'), findsOneWidget);
    expect(find.textContaining('Parque Chacabuco'), findsWidgets);
    expect(find.text('No pagues rescates ni transferencias.'), findsOneWidget);
  });

  testWidgets('QR event detail shows Google Maps action for coordinates', (
    tester,
  ) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(email: 'qr-maps@mascotify.local');
    final pet = _pet(id: 'pet-qr-maps', name: 'QR Maps');
    final event = QrScanEvent(
      id: 'scan-with-coordinates',
      petId: pet.id,
      qrId: pet.qrCodeLabel,
      ownerUserId: AppData.currentUser.id,
      scannedAt: DateTime(2026, 5, 19, 12),
      locationSource: QrScanLocationSource.deviceGeolocation,
      latitude: -34.6037,
      longitude: -58.3816,
      accuracyMeters: 15,
      city: 'CABA',
      area: 'Microcentro',
    );

    expect(
      event.mapUrl,
      'https://www.google.com/maps/search/?api=1&query=-34.6037,-58.3816',
    );

    await tester.pumpWidget(
      buildTestApp(
        QrScanEventDetailScreen(event: event, pet: pet),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Abrir en Google Maps'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('open-google-maps-button')),
      findsOneWidget,
    );
    expect(find.textContaining('-34.6037'), findsWidgets);
    _expectNoLayoutException(tester);
  });

  testWidgets('secure QR scan blocks payment intent', (tester) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(email: 'qr-payment@mascotify.local');
    final pet = _pet(id: 'pet-qr-payment', name: 'QR Cobro');
    await AppData.addPet(pet);

    await tester.pumpWidget(
      buildTestApp(
        SecureQrScanScreen(qrId: pet.qrCodeLabel),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();
    await _enterByKey(tester, const ValueKey('qr-city-field'), 'CABA');
    await _enterByKey(tester, const ValueKey('qr-area-field'), 'Caballito');
    await _enterByKey(
      tester,
      const ValueKey('qr-message-field'),
      'Pido rescate y transferencia.',
    );
    await _tapByKey(tester, const ValueKey('submit-secure-qr-scan-button'));

    expect(
      find.textContaining('Mascotify no permite pedir dinero'),
      findsOneWidget,
    );
    expect(AppData.qrScanEventsForPet(pet.id), isEmpty);
  });

  testWidgets('lost pet QR scan is marked as possible sighting', (
    tester,
  ) async {
    _setMobileViewport(tester);
    final session = await _buildQrSession(email: 'qr-lost@mascotify.local');
    final pet = _pet(id: 'pet-qr-lost', name: 'Luna Perdida');
    await AppData.addPet(pet);
    await AppData.addLostPet(_lostPetForPet(pet, id: 'lost-${pet.id}'));

    await tester.pumpWidget(
      buildTestApp(
        SecureQrScanScreen(qrId: pet.qrCodeLabel),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();
    await _enterByKey(tester, const ValueKey('qr-city-field'), 'CABA');
    await _enterByKey(tester, const ValueKey('qr-area-field'), 'Plaza Irlanda');
    await _tapByKey(tester, const ValueKey('submit-secure-qr-scan-button'));

    final event = AppData.qrScanEventsForPet(pet.id).single;
    expect(event.possibleLostPetSighting, isTrue);
    expect(
      AppData.notifications.map((notification) => notification.description),
      contains(contains('Posible avistaje de mascota perdida')),
    );

    await tester.pumpWidget(
      buildTestApp(
        QrTraceabilityScreen(pet: pet),
        controller: session.controller,
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Posible avistaje de mascota perdida'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Posible avistaje de mascota perdida'), findsWidgets);
    _expectNoLayoutException(tester);
  });

  testWidgets('QR history is isolated between accounts', (tester) async {
    final session = await _buildQrSession(
      ownerName: 'Cuenta QR Uno',
      email: 'qr-account-one@mascotify.local',
    );
    final pet = _pet(id: 'pet-qr-account-one', name: 'QR Cuenta Uno');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);

    await session.controller.register(
      ownerName: 'Cuenta QR Dos',
      email: 'qr-account-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    expect(AppData.pets, isEmpty);
    expect(AppData.petActivityEventsForPet(pet.id), isEmpty);
    expect(AppData.ecosystemActivityFeed, isEmpty);
  });
}

Future<TestAppSession> _buildQrSession({
  String ownerName = 'Familia QR',
  required String email,
}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: ownerName,
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}

LostPet _lostPetForPet(Pet pet, {required String id}) {
  return LostPet(
    id: id,
    name: pet.name,
    species: pet.species,
    breed: pet.breed,
    ageLabel: pet.ageLabel,
    sex: pet.sex,
    colorHex: pet.colorHex,
    country: 'Argentina',
    region: 'Buenos Aires',
    city: 'CABA',
    locationFreeText: '',
    location: 'CABA, Buenos Aires, Argentina',
    lostZone: 'Plaza Irlanda',
    lostDateLabel: 'Hoy',
    description: 'Aviso de prueba',
    contact: 'Contacto protegido',
    distinctiveSigns: 'Collar rojo',
    isFound: false,
    createdAt: DateTime.now(),
  );
}

Future<void> _tapByKey(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.scrollUntilVisible(
    finder,
    260,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> _enterByKey(WidgetTester tester, Key key, String value) async {
  final finder = find.byKey(key);
  await tester.scrollUntilVisible(
    finder,
    260,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.enterText(finder, value);
  await tester.pumpAndSettle();
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
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
