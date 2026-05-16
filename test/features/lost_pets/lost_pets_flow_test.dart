import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/theme/app_colors.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('Mascotas contiene Mis mascotas y Mascotas perdidas', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis mascotas'), findsOneWidget);
    expect(find.text('Mascotas perdidas'), findsOneWidget);
    await _tapText(tester, 'Mascotas perdidas');
    expect(
      find.text('Todavía no hay mascotas perdidas reportadas'),
      findsOneWidget,
    );
    _expectNoLayoutException(tester);
  });

  testWidgets('navegación principal no muestra Mascotas perdidas', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await _familySession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Mascotas'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Actividad'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Mascotas perdidas'), findsNothing);
  });

  testWidgets('estado vacío y validación obligatoria funcionan', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');

    expect(
      find.text('Todavía no hay mascotas perdidas reportadas'),
      findsOneWidget,
    );
    await _tapByKey(tester, const ValueKey('lost-pet-add-button'));
    expect(find.text('Agregar mascota perdida'), findsWidgets);

    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));
    expect(find.textContaining('Completá nombre'), findsOneWidget);
    _expectNoLayoutException(tester);
  });

  testWidgets('permite crear, listar, abrir detalle y marcar encontrada', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');

    await _tapByKey(tester, const ValueKey('lost-pet-add-button'));
    await _fillLostPetForm(tester, name: 'Luna perdida');
    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));

    expect(AppData.lostPets, hasLength(1));
    expect(find.text('Luna perdida'), findsOneWidget);
    await _tapText(tester, 'Luna perdida');
    expect(find.text('Detalle de mascota perdida'), findsOneWidget);
    expect(find.text('Perdida'), findsOneWidget);
    expect(find.textContaining('Buenos Aires'), findsWidgets);
    expect(find.textContaining('Argentina'), findsWidgets);

    await _tapByKey(tester, const ValueKey('lost-pet-found-button'));
    expect(find.text('Encontrada'), findsOneWidget);
    expect(AppData.lostPets.single.isFound, isTrue);
    _expectNoLayoutException(tester);
  });

  testWidgets('raza Otra y localidad manual se guardan en reporte válido', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');

    await _tapByKey(tester, const ValueKey('lost-pet-add-button'));
    await _fillLostPetForm(
      tester,
      name: 'Sol manual',
      breed: 'Cruza barrial',
      manualCity: 'Villa Mascotify',
    );
    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));

    final lostPet = AppData.lostPets.single;
    expect(lostPet.breed, 'Cruza barrial');
    expect(lostPet.locationFreeText, 'Villa Mascotify');
    expect(lostPet.location, contains('Villa Mascotify'));
  });

  testWidgets('edad 21 no permite guardar mascota perdida', (tester) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');

    await _tapByKey(tester, const ValueKey('lost-pet-add-button'));
    await _fillLostPetForm(tester, name: 'Edad inválida', age: '21');
    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));

    expect(find.text('La edad máxima permitida es 20 años.'), findsOneWidget);
    expect(AppData.lostPets, isEmpty);
  });

  testWidgets('Mis mascotas sigue permitiendo crear mascota normal', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis mascotas'), findsOneWidget);
    await _tapText(tester, 'Agregar');
    await fillPetForm(tester, name: 'Mascota Normal QA', age: '3');
    await tapSavePetForm(tester);

    expect(find.text('Mascota Normal QA'), findsOneWidget);
    expect(AppData.pets.any((pet) => pet.name == 'Mascota Normal QA'), isTrue);
    _expectNoLayoutException(tester);
  });

  testWidgets('Clips muestra Videos cortos con color oscuro', (tester) async {
    _setMobileViewport(tester, const Size(390, 844));
    await buildPersistentTestAppSession();

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Clips');

    final textWidget = tester.widget<Text>(
      find.text(
        'Videos cortos de animales para descubrir, aprender y sonreir.',
      ),
    );
    expect(textWidget.style?.color, AppColors.textPrimary);
    _expectNoLayoutException(tester);
  });
}

Future<TestAppSession> _familySession() async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: 'Familia Perdidas QA',
    email: 'lost-pets-${DateTime.now().microsecondsSinceEpoch}@mascotify.local',
    city: 'Buenos Aires',
    password: 'password123',
    experience: AccountExperience.family,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Future<void> _fillLostPetForm(
  WidgetTester tester, {
  required String name,
  String breed = 'Mestizo / Sin raza definida',
  String age = '4',
  String? manualCity,
}) async {
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-name-field')),
    name,
  );

  if (breed != 'Mestizo / Sin raza definida') {
    await _tapByKey(tester, const ValueKey('lost-pet-breed-dropdown'));
    await tester.tap(find.text('Otra').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('lost-pet-other-breed-field')),
      breed,
    );
  }

  await tester.enterText(find.byKey(const ValueKey('lost-pet-age-field')), age);

  if (manualCity != null) {
    await _tapByKey(tester, const ValueKey('lost-pet-city-dropdown'));
    await tester.tap(find.text('Otra localidad').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('lost-pet-other-city-field')),
      manualCity,
    );
  }

  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-zone-field')),
    'Plaza principal',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-signs-field')),
    'Collar rojo y mancha blanca',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-description-field')),
    'Se perdió durante una caminata familiar.',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-contact-field')),
    '+54 9 11 1234-5678',
  );
}

Future<void> _tapByKey(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first, warnIfMissed: false);
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
