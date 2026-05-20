import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/home/presentation/screens/notifications_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_health_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/data/pet_vaccine_knowledge_catalog.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';
import 'package:mascotify/shared/models/pet_vaccine.dart';
import 'package:mascotify/shared/models/pet_vaccine_guidance.dart';
import 'package:mascotify/shared/models/pet_vaccine_reminder.dart';
import 'package:mascotify/shared/services/pet_health_reminder_engine.dart';
import 'package:mascotify/shared/services/pet_vaccine_guidance_engine.dart';

import '../../test_helpers.dart';

void main() {
  final now = DateTime(2026, 5, 20);

  test('perro cachorro muestra base orientativa sin vacunas cruzadas', () {
    final pet = _pet(
      id: 'dog-puppy',
      name: 'Milo',
      species: 'Perro',
      ageLabel: '0',
      country: 'Argentina',
    );
    final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      pet,
      const <PetVaccine>[],
      now: now,
    );

    expect(guidance.ageStageLabel, 'Cachorro');
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      contains('Antirrábica'),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      contains('Múltiple canina / quíntuple / séxtuple'),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      isNot(contains('Triple felina')),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      isNot(contains('Encefalomielitis equina Este/Oeste')),
    );
  });

  test(
    'perro adulto sin historial no se marca al día y genera recordatorio',
    () {
      final pet = _pet(
        id: 'dog-adult',
        name: 'Tango',
        species: 'Perro',
        ageLabel: '4',
        country: 'Argentina',
      );
      final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
        pet,
        const <PetVaccine>[],
        now: now,
      );
      final reminders = PetHealthReminderEngine.buildPetHealthReminders(
        pet,
        const <PetVaccine>[],
        guidance,
        now: now,
      );

      expect(guidance.ageStageLabel, 'Adulto');
      expect(guidance.incompleteHistory, isNotEmpty);
      expect(
        guidance.reviewNow.map((item) => item.status),
        contains(PetVaccineGuidanceStatus.historialIncompleto),
      );
      expect(
        reminders.map((item) => item.status),
        contains(PetVaccineReminderStatus.historialIncompleto),
      );
    },
  );

  test('perro con antirrábica vencida genera aviso de revisión', () {
    final pet = _pet(
      id: 'dog-rabies-overdue',
      name: 'Roco',
      species: 'Perro',
      ageLabel: '5',
      country: 'Argentina',
    );
    final vaccines = [
      _vaccine(pet.id, 'Antirrábica', applicationDate: DateTime(2024, 5, 1)),
    ];
    final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      pet,
      vaccines,
      now: now,
    );
    final reminders = PetHealthReminderEngine.buildPetHealthReminders(
      pet,
      vaccines,
      guidance,
      now: now,
    );

    expect(
      guidance.overdue.map((item) => item.rule.displayName),
      contains('Antirrábica'),
    );
    expect(
      reminders.map((item) => item.status),
      contains(PetVaccineReminderStatus.vencida),
    );
  });

  test(
    'perro senior muestra advertencia sin reiniciar esquema de cachorro',
    () {
      final pet = _pet(
        id: 'dog-senior',
        name: 'Lola',
        species: 'Perro',
        ageLabel: '10',
        country: 'Argentina',
      );
      final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
        pet,
        const <PetVaccine>[],
        now: now,
      );

      expect(guidance.ageStageLabel, 'Senior');
      expect(guidance.seniorWarnings, isNotEmpty);
      expect(guidance.seniorWarnings.single, contains('senior'));
    },
  );

  test('gato cachorro muestra triple y antirrábica sin múltiple canina', () {
    final pet = _pet(
      id: 'cat-kitten',
      name: 'Mora',
      species: 'Gato',
      ageLabel: '0',
      country: 'Argentina',
    );
    final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      pet,
      const <PetVaccine>[],
      now: now,
    );

    expect(guidance.ageStageLabel, 'Gatito');
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      contains('Triple felina'),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      contains('Antirrábica'),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      isNot(contains('Múltiple canina / quíntuple / séxtuple')),
    );
  });

  test('gato adulto deja leucemia felina como según riesgo', () {
    final pet = _pet(
      id: 'cat-adult',
      name: 'Nina',
      species: 'Gato',
      ageLabel: '3',
      country: 'Argentina',
    );
    final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      pet,
      const <PetVaccine>[],
      now: now,
    );

    expect(
      guidance.riskRules.map((rule) => rule.displayName),
      contains('Leucemia felina'),
    );
    expect(
      guidance.baseRules.map((rule) => rule.displayName),
      isNot(contains('Leucemia felina')),
    );
  });

  test('caballo y conejo no heredan vacunas de perro o gato', () {
    final horseGuidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      _pet(id: 'horse', name: 'Noble', species: 'Caballo', ageLabel: '7'),
      const <PetVaccine>[],
      now: now,
    );
    final rabbitGuidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
      _pet(id: 'rabbit', name: 'Boni', species: 'Conejo', ageLabel: '2'),
      const <PetVaccine>[],
      now: now,
    );

    expect(
      horseGuidance.baseRules.map((rule) => rule.displayName),
      contains('Tétanos'),
    );
    expect(
      horseGuidance.baseRules.map((rule) => rule.displayName),
      isNot(contains('Triple felina')),
    );
    expect(
      rabbitGuidance.riskRules.map((rule) => rule.displayName),
      contains('Mixomatosis'),
    );
    expect(
      rabbitGuidance.riskRules.map((rule) => rule.displayName),
      isNot(contains('Múltiple canina / quíntuple / séxtuple')),
    );
  });

  test('ave reptil pez y roedor no muestran calendario universal', () {
    for (final species in ['Ave', 'Reptil doméstico', 'Pez', 'Hámster']) {
      final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(
        _pet(
          id: 'pet-$species',
          name: species,
          species: species,
          ageLabel: '2',
        ),
        const <PetVaccine>[],
        now: now,
      );
      expect(guidance.hasUniversalCalendar, isFalse);
      expect(guidance.noGeneralCalendarMessage, isNotNull);
      expect(guidance.baseRules, isEmpty);
    }
  });

  test('recordatorios próximos respetan 30 días y 7 días', () {
    final pet = _pet(
      id: 'dog-next-dose',
      name: 'Chispa',
      species: 'Perro',
      ageLabel: '3',
      country: 'Argentina',
    );
    final vaccine = _vaccine(
      pet.id,
      'Antirrábica',
      applicationDate: DateTime(2025, 6, 1),
      nextDoseDate: DateTime(2026, 5, 26),
    );
    final guidance = PetVaccineGuidanceEngine.buildVaccineGuidanceForPet(pet, [
      vaccine,
    ], now: now);
    final reminders = PetHealthReminderEngine.buildPetHealthReminders(
      pet,
      [vaccine],
      guidance,
      now: now,
    );

    final reminder = reminders.firstWhere(
      (item) => item.status == PetVaccineReminderStatus.proxima,
    );
    expect(reminder.daysUntilDue, 6);
    expect(reminder.severity, PetVaccineReminderSeverity.important);
  });

  test('base versionada expone versión y revisión pendiente', () {
    expect(PetVaccineKnowledgeCatalog.version.version, contains('local-demo'));
    expect(PetVaccineKnowledgeCatalog.version.isLocalDemo, isTrue);
    expect(
      PetVaccineKnowledgeCatalog.version.reviewedBy,
      contains('Pendiente de revisión veterinaria'),
    );
  });

  testWidgets('UI muestra calendario, avisos e información sanitaria', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final pet = await _seedPet(
      email: 'health-ui-reminders@mascotify.local',
      petId: 'pet-health-ui-reminders',
      petName: 'Salud UI',
      species: 'Perro',
      ageLabel: '4',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();

    await _scrollToText(tester, 'Calendario orientativo');
    expect(find.text('Calendario orientativo'), findsOneWidget);
    expect(find.text('Versión catálogo'), findsOneWidget);
    await _scrollToText(tester, 'Para revisar ahora');
    expect(find.text('Para revisar ahora'), findsOneWidget);
    expect(find.textContaining('Historial sanitario incompleto'), findsWidgets);
    await _scrollToText(tester, 'Próximos avisos');
    expect(find.text('Próximos avisos'), findsOneWidget);
    await _scrollToText(tester, 'Según riesgo');
    expect(find.text('Según riesgo'), findsOneWidget);
    await _scrollToText(tester, 'Información sanitaria');
    expect(find.text('Información sanitaria'), findsOneWidget);
  });

  testWidgets('notificación interna de salud navega a Salud y vacunas', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final pet = await _seedPet(
      email: LocalAuthSeedData.familyEmail,
      petId: 'pet-health-notification',
      petName: 'Aviso Salud',
      species: 'Perro',
      ageLabel: '4',
      useDemoLogin: true,
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    expect(
      AppData.notifications.map((item) => item.title),
      contains('Falta cargar el historial sanitario de Aviso Salud'),
    );

    await tester.pumpWidget(buildTestApp(const NotificationsScreen()));
    await tester.pumpAndSettle();
    await _scrollToText(tester, 'Abrir salud');
    await tester.tap(find.text('Abrir salud').first);
    await tester.pumpAndSettle();

    expect(find.text('Salud y vacunas'), findsWidgets);
    await _scrollToText(tester, 'Calendario orientativo');
    expect(find.text('Calendario orientativo'), findsOneWidget);
  });

  testWidgets('advertencia cruzada exige confirmar indicación veterinaria', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final pet = await _seedPet(
      email: 'health-cross-confirm@mascotify.local',
      petId: 'pet-health-cross-confirm',
      petName: 'Cruzada',
      species: 'Caballo',
      ageLabel: '6',
    );

    await tester.pumpWidget(buildTestApp(PetHealthScreen(pet: pet)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-vaccine-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('vaccine-name-field')),
      'Múltiple canina / quíntuple / séxtuple',
    );
    await tester.enterText(
      find.byKey(const ValueKey('vaccine-application-date-field')),
      '20/05/2026',
    );
    await tester.tap(find.byKey(const ValueKey('save-vaccine-button')));
    await tester.pumpAndSettle();

    expect(find.text('Confirmar vacuna manual'), findsOneWidget);
    expect(find.text('Lo indicó un veterinario'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(AppData.petVaccinesForPet(pet.id), isEmpty);

    await tester.tap(find.byKey(const ValueKey('save-vaccine-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lo indicó un veterinario'));
    await tester.pumpAndSettle();

    expect(AppData.petVaccinesForPet(pet.id), hasLength(1));
  });
}

Future<Pet> _seedPet({
  required String email,
  required String petId,
  required String petName,
  required String species,
  required String ageLabel,
  bool useDemoLogin = false,
}) async {
  final session = await buildPersistentTestAppSession();
  if (useDemoLogin) {
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );
  } else {
    await session.controller.register(
      ownerName: 'Familia Salud',
      email: email,
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );
    await session.controller.completeOnboarding();
  }
  await AppData.syncCurrentUserState();
  final pet = _pet(
    id: petId,
    name: petName,
    species: species,
    ageLabel: ageLabel,
    country: 'Argentina',
  );
  await AppData.addPet(pet);
  return pet;
}

Pet _pet({
  required String id,
  required String name,
  required String species,
  required String ageLabel,
  String country = '',
}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    species: species,
    ageLabel: ageLabel,
    country: country,
    region: '',
    city: '',
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}

PetVaccine _vaccine(
  String petId,
  String name, {
  DateTime? applicationDate,
  DateTime? nextDoseDate,
}) {
  final now = DateTime(2026, 5, 20);
  return PetVaccine(
    id: 'vaccine-$petId-${name.hashCode}',
    petId: petId,
    name: name,
    status: PetVaccineStatus.applied,
    applicationDate: applicationDate,
    nextDoseDate: nextDoseDate,
    createdAt: now,
    updatedAt: now,
  );
}

Future<void> _scrollToText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  if (finder.evaluate().isNotEmpty) {
    await tester.ensureVisible(finder.first);
    await tester.pumpAndSettle();
    return;
  }
  await tester.scrollUntilVisible(
    finder,
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}
