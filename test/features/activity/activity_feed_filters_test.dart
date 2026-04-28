import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('search finds an activity by title', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-title@mascotify.local',
    );
    final pet = _pet(id: 'pet-filter-title', name: 'Titulo Busqueda');
    await AppData.addPet(pet);
    await AppData.updatePet(pet.copyWith(name: 'Titulo Actualizado'));

    await _pumpFeed(tester, session);
    await _search(tester, 'Perfil actualizado');

    expect(find.text('Perfil actualizado'), findsWidgets);
    expect(find.text('Mascota creada'), findsNothing);
  });

  testWidgets('search finds an activity by description or pet name', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-description@mascotify.local',
    );
    await AppData.addPet(
      _pet(id: 'pet-filter-description', name: 'Olivia Rastreadora'),
    );

    await _pumpFeed(tester, session);
    await _search(tester, 'Olivia Rastreadora');

    expect(find.text('Mascota creada'), findsOneWidget);
    expect(find.textContaining('Olivia Rastreadora'), findsWidgets);
  });

  testWidgets('type filter shows only that activity type', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-type@mascotify.local',
    );
    final pet = _pet(id: 'pet-filter-type', name: 'Filtro Tipo');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Mensaje visible para filtrar.',
    );

    await _pumpFeed(tester, session);
    await _tapTypeFilter(tester, 'Mensajes');

    expect(
      find.text('Conversacion con Contacto por Filtro Tipo'),
      findsOneWidget,
    );
    expect(find.text('Mascota creada'), findsNothing);
  });

  testWidgets('search with no results shows filtered empty state', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-empty@mascotify.local',
    );
    await AppData.addPet(_pet(id: 'pet-filter-empty', name: 'Filtro Vacio'));

    await _pumpFeed(tester, session);
    await _search(tester, 'sin resultados para este feed');

    expect(find.text('No hay actividad para esos filtros'), findsOneWidget);
    expect(find.text('Mascota creada'), findsNothing);
  });

  testWidgets('clear restores search and type filters', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-clear@mascotify.local',
    );
    final pet = _pet(id: 'pet-filter-clear', name: 'Filtro Limpiar');
    await AppData.addPet(pet);
    await AppData.expressInterest(
      petId: pet.id,
      interestType: 'Vinculo social',
      message: 'Mensaje para limpiar filtros.',
    );

    await _pumpFeed(tester, session);
    await _tapTypeFilter(tester, 'Mensajes');
    await _search(tester, 'Mensaje para limpiar filtros.');

    expect(find.text('Mascota creada'), findsNothing);

    await _tapVisibleText(tester, 'Limpiar');

    expect(find.text('Mascota creada'), findsOneWidget);
    expect(
      find.text('Conversacion con Contacto por Filtro Limpiar'),
      findsOneWidget,
    );
  });

  testWidgets('recent-first order remains after filtering', (tester) async {
    setDesktopViewport(tester);
    final session = await _buildActivitySession(
      email: 'activity-filter-order@mascotify.local',
    );
    final pet = _pet(id: 'pet-filter-order', name: 'Filtro Orden');
    await AppData.addPet(pet);
    await AppData.updatePet(pet.copyWith(name: 'Filtro Orden Editado'));

    await _pumpFeed(tester, session);
    await _tapTypeFilter(tester, 'Mascotas');

    final updatedTop = tester.getTopLeft(find.text('Perfil actualizado')).dy;
    final createdTop = tester.getTopLeft(find.text('Mascota creada')).dy;

    expect(updatedTop, lessThan(createdTop));
  });
}

Future<TestAppSession> _buildActivitySession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Familia Feed Filtros',
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

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(
    find.byKey(const ValueKey('activity-search-field')),
    query,
  );
  await tester.pumpAndSettle();
}

Future<void> _tapTypeFilter(WidgetTester tester, String label) async {
  final keyName = switch (label) {
    'Mascotas' => 'pet',
    'QR' => 'qr',
    'Intereses sociales' => 'social',
    'Mensajes' => 'message',
    'Notificaciones' => 'notification',
    'Perfil profesional' => 'professional',
    _ => throw ArgumentError('Filtro desconocido: $label'),
  };
  final finder = find.byKey(ValueKey('activity-filter-$keyName'));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapVisibleText(WidgetTester tester, String label) async {
  final finder = label == 'Limpiar'
      ? find.byKey(const ValueKey('activity-filter-clear'))
      : find.text(label).last;
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
