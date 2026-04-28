import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/qr_traceability_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';
import 'package:mascotify/shared/models/report_models.dart';

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
