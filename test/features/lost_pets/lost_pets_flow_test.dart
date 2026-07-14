import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pets_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('Mascotas perdidas está dentro de Mascotas y no en sidebar', (
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
    expect(find.text('Catálogo solidario'), findsOneWidget);
    expect(
      find.text('Todavía no hay mascotas perdidas reportadas en esta zona.'),
      findsOneWidget,
    );
    _expectNoLayoutException(tester);

    setDesktopViewport(tester);
    final navSession = await _familySession();
    await tester.pumpWidget(navSession.buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Mascotas'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Actividad'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Mascotas perdidas'), findsNothing);
  });

  testWidgets(
    'estado vacío muestra CTA y formulario solidario sin recompensa',
    (tester) async {
      _setMobileViewport(tester, const Size(390, 844));
      final session = await _familySession();

      await tester.pumpWidget(
        buildTestApp(const PetsScreen(), controller: session.controller),
      );
      await tester.pumpAndSettle();
      await _tapText(tester, 'Mascotas perdidas');

      expect(find.text('Reportar mascota perdida'), findsOneWidget);
      await _tapByKey(tester, const ValueKey('lost-pet-empty-add-button'));
      expect(find.text('Crear aviso solidario'), findsOneWidget);
      expect(find.textContaining('Este aviso es gratuito'), findsOneWidget);
      expect(find.textContaining('recompensa'), findsNothing);

      await _tapByKey(tester, const ValueKey('lost-pet-save-button'));
      expect(find.textContaining('Completá nombre'), findsOneWidget);
      _expectNoLayoutException(tester);
    },
  );

  testWidgets('validación anti-cobro bloquea textos de rescate', (
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
      name: 'Luna segura',
      description: 'Pido rescate y transferencia para devolverla.',
    );
    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));

    expect(
      find.textContaining('Mascotify no permite pedir dinero'),
      findsOneWidget,
    );
    expect(AppData.lostPets, isEmpty);
  });

  testWidgets('permite guardar aviso válido como card de catálogo', (
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
    await _fillLostPetForm(tester, name: 'Luna catálogo');
    await _tapByKey(tester, const ValueKey('lost-pet-save-button'));

    expect(AppData.lostPets, hasLength(1));
    expect(find.text('Luna catálogo'), findsOneWidget);
    expect(find.text('Perdida'), findsOneWidget);
    expect(find.text('Ayuda gratuita'), findsOneWidget);
    expect(find.text('No pagar rescates'), findsOneWidget);
    expect(find.textContaining('Palermo'), findsWidgets);
    expect(find.textContaining('15/05/2026'), findsOneWidget);
    expect(find.textContaining('precio'), findsNothing);
    expect(find.textContaining('comprar'), findsNothing);
    expect(find.textContaining('recompensa'), findsNothing);
    expect(
      AppData.lostPets.single.privateVerificationNote,
      'Tiene una mancha en forma de luna',
    );
    expect(find.text('Tiene una mancha en forma de luna'), findsNothing);
    _expectNoLayoutException(tester);
  });

  testWidgets('filtros y buscador funcionan en el catálogo', (tester) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');
    await _createLostPet(tester, name: 'Luna filtro', city: null);
    await _createLostPet(
      tester,
      name: 'Milo encontrado',
      species: 'Gato',
      city: 'Villa Mascotify',
      markFound: true,
    );

    await tester.enterText(
      find.byKey(const ValueKey('lost-pets-search-field')),
      'Villa Mascotify',
    );
    await tester.pumpAndSettle();
    expect(find.text('Milo encontrado'), findsOneWidget);
    expect(find.text('Luna filtro'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('lost-pets-search-field')),
      '',
    );
    await tester.pumpAndSettle();
    await _tapByKey(tester, const ValueKey('lost-pets-status-filter'));
    await tester.tap(find.text('Encontrada').last);
    await tester.pumpAndSettle();
    expect(find.text('Milo encontrado'), findsOneWidget);
    expect(find.text('Luna filtro'), findsNothing);
  });

  testWidgets(
    'detalle muestra ficha completa, acciones seguras y no dato privado',
    (tester) async {
      _setMobileViewport(tester, const Size(390, 844));
      final session = await _familySession();

      await tester.pumpWidget(
        buildTestApp(const PetsScreen(), controller: session.controller),
      );
      await tester.pumpAndSettle();
      await _tapText(tester, 'Mascotas perdidas');
      await _createLostPet(tester, name: 'Luna detalle');

      await _tapByKey(
        tester,
        ValueKey('lost-pet-detail-${AppData.lostPets.single.id}'),
      );
      expect(find.text('Ficha de mascota perdida'), findsOneWidget);
      expect(find.text('Tipo'), findsOneWidget);
      expect(find.text('Raza / tipo'), findsOneWidget);
      expect(find.text('Ubicación'), findsOneWidget);
      expect(find.text('Zona aproximada'), findsOneWidget);
      expect(find.text('Creo haberla visto'), findsOneWidget);
      expect(find.text('Contacto seguro'), findsWidgets);
      expect(find.text('Reportar'), findsOneWidget);
      expect(find.text('Tiene una mancha en forma de luna'), findsNothing);

      await _tapByKey(tester, const ValueKey('lost-pet-safe-contact-button'));
      expect(
        find.text('No pagues rescates ni transferencias.'),
        findsOneWidget,
      );
      await _tapByKey(tester, const ValueKey('show-safe-contact-button'));
      expect(find.text('+54 9 11 1234-5678'), findsOneWidget);
    },
  );

  testWidgets('Creo haberla visto y Reportar muestran confirmaciones', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');
    await _createLostPet(tester, name: 'Luna acciones');
    await _tapByKey(
      tester,
      ValueKey('lost-pet-detail-${AppData.lostPets.single.id}'),
    );

    await _tapByKey(tester, const ValueKey('lost-pet-seen-button'));
    await tester.enterText(
      find.byKey(const ValueKey('seen-where-field')),
      'Cerca de Plaza Italia',
    );
    await tester.enterText(
      find.byKey(const ValueKey('seen-when-field')),
      'Hoy a la mañana',
    );
    await _tapByKey(tester, const ValueKey('seen-submit-button'));
    expect(
      find.text('Gracias. Avisamos a la familia con la información cargada.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();

    await _tapByKey(tester, const ValueKey('lost-pet-report-button'));
    expect(find.text('Me pidió dinero'), findsOneWidget);
    await _tapByKey(tester, const ValueKey('report-submit-button'));
    expect(find.text('Gracias. Revisaremos este reporte.'), findsOneWidget);
  });

  testWidgets('reportar mascota perdida no requiere Plus ni Pro', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    final session = await _familySession();
    await AppData.setPlanName('Mascotify Free');

    await tester.pumpWidget(
      buildTestApp(const PetsScreen(), controller: session.controller),
    );
    await tester.pumpAndSettle();
    await _tapText(tester, 'Mascotas perdidas');
    await _createLostPet(tester, name: 'Luna free');

    await _tapByKey(
      tester,
      ValueKey('lost-pet-report-${AppData.lostPets.single.id}'),
    );
    expect(find.text('Reportar aviso de Luna free'), findsOneWidget);
    expect(find.textContaining('Mascotify Plus'), findsNothing);
    expect(find.textContaining('Mascotify Pro'), findsNothing);
    expect(find.textContaining('publicidad'), findsNothing);
    expect(find.textContaining('anuncio'), findsNothing);
    await _tapByKey(tester, const ValueKey('report-submit-button'));
    expect(find.text('Gracias. Revisaremos este reporte.'), findsOneWidget);
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

  testWidgets('Clips abre visor vertical sin pantalla intermedia', (
    tester,
  ) async {
    _setMobileViewport(tester, const Size(390, 844));
    await buildPersistentTestAppSession();

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.pumpAndSettle();
    await _tapText(tester, 'Clips');

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('QR seguro para tu mascota'), findsOneWidget);
    expect(find.text('Mascotify oficial'), findsWidgets);
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

Future<void> _createLostPet(
  WidgetTester tester, {
  required String name,
  String species = 'Perro',
  String? city,
  bool markFound = false,
}) async {
  await _tapByKey(tester, const ValueKey('lost-pet-add-button'));
  await _fillLostPetForm(
    tester,
    name: name,
    species: species,
    manualCity: city,
  );
  await _tapByKey(tester, const ValueKey('lost-pet-save-button'));
  if (markFound) {
    await AppData.markLostPetFound(AppData.lostPets.first.id);
    await tester.pumpAndSettle();
  }
}

Future<void> _fillLostPetForm(
  WidgetTester tester, {
  required String name,
  String species = 'Perro',
  String breed = 'Mestizo / Sin raza definida',
  String age = '4',
  String? manualCity,
  String description = 'Se perdió durante una caminata familiar.',
}) async {
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-name-field')),
    name,
  );

  if (species != 'Perro') {
    await _tapByKey(tester, const ValueKey('lost-pet-species-dropdown'));
    await tester.tap(find.text(species).last);
    await tester.pumpAndSettle();
  }

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
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-color-field')),
    'marrón con blanco',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-signs-field')),
    'Collar rojo y mancha blanca',
  );

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
    'Palermo',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-date-field')),
    '15/05/2026',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-description-field')),
    description,
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-contact-field')),
    '+54 9 11 1234-5678',
  );
  await tester.enterText(
    find.byKey(const ValueKey('lost-pet-private-verification-field')),
    'Tiene una mancha en forma de luna',
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
