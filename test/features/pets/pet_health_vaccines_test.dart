import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_health_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';
import 'package:mascotify/shared/models/pet_vaccine.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('el detalle muestra la card Salud con resumen de vacunas', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final pet = await _seedPet(
      email: 'health-summary@mascotify.local',
      petId: 'pet-health-summary',
      petName: 'Salud Resumen',
    );

    await tester.pumpWidget(buildTestApp(PetDetailScreen(pet: pet)));
    await tester.pumpAndSettle();
    await _scrollToHealthCard(tester);

    expect(find.text('Salud'), findsOneWidget);
    expect(
      find.text('Resumen inicial para controles y seguimiento.'),
      findsNothing,
    );
    expect(
      find.text('Controles recientes registrados y seguimiento estable.'),
      findsNothing,
    );
    expect(find.text('Seguimiento'), findsNothing);
    expect(
      find.text('Vacunas, controles y seguimiento sanitario.'),
      findsOneWidget,
    );
    expect(find.text('Sin vacunas cargadas'), findsOneWidget);
    expect(find.text('Aplicadas'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Próxima dosis'), findsOneWidget);
    expect(find.text('Ver salud y vacunas'), findsOneWidget);
  });

  testWidgets('el flujo real desde Mascotas abre Salud y vacunas', (
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

    await tester.tap(find.text('Mascotas'));
    await tester.pumpAndSettle();
    expect(find.text('Centro de mascotas'), findsOneWidget);

    await tester.tap(find.text('Milo').first);
    await tester.pumpAndSettle();
    expect(find.text('Detalle de mascota'), findsOneWidget);

    await _scrollToHealthCard(tester);
    expect(
      find.text('Resumen inicial para controles y seguimiento.'),
      findsNothing,
    );
    expect(
      find.text('Controles recientes registrados y seguimiento estable.'),
      findsNothing,
    );
    expect(
      find.text('Vacunas, controles y seguimiento sanitario.'),
      findsOneWidget,
    );
    expect(find.text('Aplicadas'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Próxima dosis'), findsOneWidget);
    expect(find.text('Ver salud y vacunas'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('open-pet-health-button')));
    await tester.pumpAndSettle();
    expect(find.text('Salud y vacunas'), findsWidgets);
  });

  testWidgets('Ver salud y vacunas abre la libreta sanitaria vacía', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final pet = await _seedPet(
      email: 'health-empty@mascotify.local',
      petId: 'pet-health-empty',
      petName: 'Salud Vacía',
    );

    await tester.pumpWidget(buildTestApp(PetDetailScreen(pet: pet)));
    await tester.pumpAndSettle();
    await _openHealthFromDetail(tester);

    expect(find.text('Salud y vacunas'), findsWidgets);
    expect(find.text('Salud Vacía'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Todavía no cargaste vacunas'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Todavía no cargaste vacunas'), findsOneWidget);
    expect(
      find.textContaining('no reemplaza la indicación de un veterinario'),
      findsOneWidget,
    );
  });

  testWidgets('no permite guardar vacuna sin nombre ni aplicada sin fecha', (
    tester,
  ) async {
    final pet = await _seedPet(
      email: 'health-validation@mascotify.local',
      petId: 'pet-health-validation',
      petName: 'Salud Validación',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-vaccine-button')));
    await tester.pumpAndSettle();

    await _tapSaveVaccine(tester);
    await tester.pumpAndSettle();
    expect(find.text('Ingresá el nombre de la vacuna.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('vaccine-name-field')),
      'Antirrábica',
    );
    await _tapSaveVaccine(tester);
    await tester.pumpAndSettle();
    expect(find.text('Ingresá la fecha de aplicación.'), findsOneWidget);
  });

  testWidgets('se puede agregar vacuna aplicada y actualizar resumen', (
    tester,
  ) async {
    final pet = await _seedPet(
      email: 'health-applied@mascotify.local',
      petId: 'pet-health-applied',
      petName: 'Salud Aplicada',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    await _addAppliedVaccine(tester, name: 'Antirrábica');

    await _scrollToText(tester, 'Estado: Aplicada');
    expect(find.text('Antirrábica'), findsOneWidget);
    expect(find.text('Estado: Aplicada'), findsOneWidget);
    expect(
      AppData.petVaccinesForPet(pet.id).where((item) => item.isApplied).length,
      1,
    );
  });

  testWidgets('se puede agregar pendiente y marcarla como aplicada', (
    tester,
  ) async {
    final pet = await _seedPet(
      email: 'health-pending@mascotify.local',
      petId: 'pet-health-pending',
      petName: 'Salud Pendiente',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    await _addPendingVaccine(tester, name: 'Triple felina');

    await _scrollToText(tester, 'Estado: Pendiente');
    expect(find.text('Vacunas pendientes'), findsWidgets);
    expect(find.text('Estado: Pendiente'), findsOneWidget);

    await tester.tap(find.text('Marcar como aplicada'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('mark-applied-date-field')),
      '12/08/2026',
    );
    await tester.tap(find.byKey(const ValueKey('confirm-mark-applied-button')));
    await tester.pumpAndSettle();

    expect(find.text('Estado: Aplicada'), findsOneWidget);
    expect(find.text('Sin vacunas pendientes registradas.'), findsOneWidget);
    expect(
      AppData.petVaccinesForPet(pet.id).where((item) => item.isPending),
      isEmpty,
    );
  });

  testWidgets('se puede editar y eliminar una vacuna con confirmación', (
    tester,
  ) async {
    final pet = await _seedPet(
      email: 'health-edit-delete@mascotify.local',
      petId: 'pet-health-edit-delete',
      petName: 'Salud Edición',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    await _addAppliedVaccine(tester, name: 'Antirrábica');

    await _scrollToText(tester, 'Editar');
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('vaccine-name-field')),
      'Antirrábica anual',
    );
    await _tapSaveVaccine(tester);
    await tester.pumpAndSettle();

    await _scrollToText(tester, 'Antirrábica anual');
    expect(find.text('Antirrábica anual'), findsOneWidget);

    await _scrollToText(tester, 'Eliminar');
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(
      find.text('¿Querés eliminar esta vacuna del registro de la mascota?'),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('confirm-delete-vaccine-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Todavía no cargaste vacunas'), findsOneWidget);
    expect(AppData.petVaccinesForPet(pet.id), isEmpty);
  });

  testWidgets('las vacunas quedan aisladas por mascota y por cuenta', (
    tester,
  ) async {
    final session = await _buildHealthSession(
      email: 'health-isolation-one@mascotify.local',
    );
    final firstPet = _pet(id: 'pet-health-one', name: 'Mascota Uno');
    final secondPet = _pet(id: 'pet-health-two', name: 'Mascota Dos');
    await AppData.addPet(firstPet);
    await AppData.addPet(secondPet);
    await AppData.upsertPetVaccine(_vaccine(firstPet.id, 'Antirrábica'));

    expect(AppData.petVaccinesForPet(firstPet.id), hasLength(1));
    expect(AppData.petVaccinesForPet(secondPet.id), isEmpty);

    await session.controller.register(
      ownerName: 'Cuenta Salud Dos',
      email: 'health-isolation-two@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    expect(AppData.petVaccinesForPet(firstPet.id), isEmpty);
  });

  testWidgets('la vista principal de salud no desborda en mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pet = await _seedPet(
      email: 'health-mobile@mascotify.local',
      petId: 'pet-health-mobile',
      petName: 'Salud Mobile',
    );
    await AppData.upsertPetVaccine(_vaccine(pet.id, 'Antirrábica'));

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();

    expect(find.text('Salud y vacunas'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

Future<Pet> _seedPet({
  required String email,
  required String petId,
  required String petName,
}) async {
  await _buildHealthSession(email: email);
  final pet = _pet(id: petId, name: petName);
  await AppData.addPet(pet);
  return pet;
}

Future<TestAppSession> _buildHealthSession({required String email}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Familia Salud',
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _scrollToHealthCard(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Ver salud y vacunas'),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _openHealthFromDetail(WidgetTester tester) async {
  await _scrollToHealthCard(tester);
  await tester.tap(find.byKey(const ValueKey('open-pet-health-button')));
  await tester.pumpAndSettle();
}

Future<void> _scrollToText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text),
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _addAppliedVaccine(
  WidgetTester tester, {
  required String name,
}) async {
  await tester.tap(find.byKey(const ValueKey('add-vaccine-button')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const ValueKey('vaccine-name-field')),
    name,
  );
  await tester.enterText(
    find.byKey(const ValueKey('vaccine-application-date-field')),
    '10/08/2026',
  );
  await tester.enterText(
    find.byKey(const ValueKey('vaccine-next-dose-field')),
    '12/08/2026',
  );
  await _tapSaveVaccine(tester);
  await tester.pumpAndSettle();
}

Future<void> _addPendingVaccine(
  WidgetTester tester, {
  required String name,
}) async {
  await tester.tap(find.byKey(const ValueKey('add-vaccine-button')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const ValueKey('vaccine-name-field')),
    name,
  );
  await tester.tap(find.byKey(const ValueKey('vaccine-status-field')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Pendiente').last);
  await tester.pumpAndSettle();
  await _tapSaveVaccine(tester);
  await tester.pumpAndSettle();
}

Future<void> _tapSaveVaccine(WidgetTester tester) async {
  final saveButton = find.byKey(const ValueKey('save-vaccine-button'));
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  tester.widget<FilledButton>(saveButton).onPressed?.call();
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    species: 'Perro',
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}

PetVaccine _vaccine(String petId, String name) {
  final now = DateTime.now();
  return PetVaccine(
    id: 'vaccine-$petId-${now.microsecondsSinceEpoch}',
    petId: petId,
    name: name,
    status: PetVaccineStatus.applied,
    createdAt: now,
    updatedAt: now,
    applicationDate: DateTime(2026, 8, 10),
  );
}
