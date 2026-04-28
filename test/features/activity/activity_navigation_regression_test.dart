import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('QR activity opens the traceability screen from the feed', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-nav-qr@mascotify.local',
    );
    final pet = _pet(id: 'pet-activity-nav-qr', name: 'QR Navegable');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);

    await _pumpFeed(tester, session);
    await _tapVisibleText(tester, 'Historial QR revisado');

    expect(find.text('Historial QR'), findsOneWidget);
    expect(find.textContaining('QR Navegable'), findsWidgets);
  });

  testWidgets('message activity keeps opening the related conversation', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-nav-message@mascotify.local',
    );
    final pet = _pet(id: 'pet-activity-nav-message', name: 'Chat Navegable');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Mensaje navegable desde consolidacion.',
    );

    await _pumpFeed(tester, session);
    await _tapVisibleText(
      tester,
      'Conversacion con Contacto por Chat Navegable',
    );

    expect(find.text('Contacto por Chat Navegable'), findsWidgets);
    expect(find.text('Mensaje navegable desde consolidacion.'), findsOneWidget);
  });

  testWidgets('activity without a valid destination stays usable', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-nav-missing@mascotify.local',
    );
    final pet = _pet(id: 'pet-activity-nav-missing', name: 'Destino Seguro');
    await AppData.addPet(pet);
    await AppData.deletePet(pet.id);

    await _pumpFeed(tester, session);
    await _tapVisibleText(tester, 'Destino Seguro se elimin');

    expect(find.text('Actividad'), findsOneWidget);
    expect(
      find.text('No hay un destino disponible para esta actividad.'),
      findsOneWidget,
    );
  });

  testWidgets('QR events keep working with feed search and filters', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-nav-filter-qr@mascotify.local',
    );
    final pet = _pet(id: 'pet-activity-nav-filter-qr', name: 'Filtro QR');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);

    await _pumpFeed(tester, session);
    await _tapFilter(tester, 'qr');
    await tester.enterText(
      find.byKey(const ValueKey('activity-search-field')),
      'Historial QR revisado',
    );
    await tester.pumpAndSettle();

    expect(find.text('Historial QR revisado'), findsWidgets);
    expect(find.text('Mascota creada'), findsNothing);
  });
}

Future<TestAppSession> _buildActivitySession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Familia Navegacion',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _pumpFeed(WidgetTester tester, TestAppSession session) async {
  await tester.pumpWidget(
    buildTestApp(const ActivityFeedScreen(), controller: session.controller),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapFilter(WidgetTester tester, String typeName) async {
  final finder = find.byKey(ValueKey('activity-filter-$typeName'));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  final finder = find.textContaining(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}
