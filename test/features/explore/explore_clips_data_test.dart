import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';

import '../../test_helpers.dart';

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  test('todos los clips demo tienen id unico', () {
    final ids = ClipsMockData.clips.map((clip) => clip.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
  });

  test('existen cuentas demo y clips iniciales suficientes', () {
    expect(ClipsMockData.demoCreators.length, greaterThanOrEqualTo(12));
    expect(ClipsMockData.demoCreators.length, lessThanOrEqualTo(15));
    expect(ClipsMockData.clips.length, greaterThanOrEqualTo(30));
  });

  test('cada cuenta demo esta marcada y tiene metadata navegable', () {
    for (final creator in ClipsMockData.demoCreators) {
      expect(creator.id.trim(), isNotEmpty);
      expect(creator.displayName.trim(), isNotEmpty);
      expect(creator.username.trim(), isNotEmpty);
      expect(creator.bio.trim(), isNotEmpty);
      expect(creator.location.trim(), isNotEmpty);
      expect(creator.profileType.trim(), isNotEmpty);
      expect(creator.isDemoAccount, isTrue, reason: creator.id);
      expect(creator.isVerifiedDemo, isFalse, reason: creator.id);
      expect(creator.source, 'seeded_demo', reason: creator.id);
      expect(creator.seededAt, ClipsMockData.seededAt, reason: creator.id);
      expect(creator.followersCount, inInclusiveRange(12, 850));
      expect(creator.followingCount, inInclusiveRange(5, 120));
      expect(creator.clipsCount, inInclusiveRange(2, 4));
      expect(creator.likesTotal, greaterThanOrEqualTo(creator.clipsCount * 4));
    }
  });

  test('cada cuenta demo tiene al menos una mascota asociada', () {
    for (final creator in ClipsMockData.demoCreators) {
      expect(
        ClipsMockData.petsForCreator(creator.id),
        isNotEmpty,
        reason: creator.id,
      );
    }
  });

  test('cada mascota demo tiene datos utiles y seguros', () {
    final creatorIds = ClipsMockData.demoCreators
        .map((creator) => creator.id)
        .toSet();

    for (final pet in ClipsMockData.demoPets) {
      expect(pet.petId.trim(), isNotEmpty);
      expect(creatorIds, contains(pet.ownerDemoAccountId), reason: pet.petId);
      expect(pet.name.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.species.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.breedOrType.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.ageUnit.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.personality.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.routine.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.careNotes.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.healthNotesGeneral.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.locationGeneral.trim(), isNotEmpty, reason: pet.petId);
      expect(pet.tags, isNotEmpty, reason: pet.petId);
      expect(pet.source, 'seeded_demo', reason: pet.petId);
    }
  });

  test('todos los clips demo tienen titulo y descripcion no vacios', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.title.trim(), isNotEmpty, reason: clip.id);
      expect(clip.description.trim(), isNotEmpty, reason: clip.id);
      expect(clip.animalType.trim(), isNotEmpty, reason: clip.id);
      expect(clip.petName?.trim(), isNotEmpty, reason: clip.id);
      expect(clip.tags, isNotEmpty, reason: clip.id);
      expect(clip.demoVideoKey, clip.id, reason: clip.id);
      expect(clip.sourceLabel, 'Comunidad inicial', reason: clip.id);
      expect(clip.source, 'seeded_demo', reason: clip.id);
      expect(clip.seededAt, ClipsMockData.seededAt, reason: clip.id);
      expect(clip.isStarterContent, isTrue, reason: clip.id);
      expect(clip.availableForAllUsers, isTrue, reason: clip.id);
    }
  });

  test('cada clip demo tiene autor demo valido', () {
    final creatorIds = ClipsMockData.demoCreators
        .map((creator) => creator.id)
        .toSet();

    for (final clip in ClipsMockData.clips) {
      expect(clip.authorId, isNotNull, reason: clip.id);
      expect(creatorIds, contains(clip.authorId), reason: clip.id);
      expect(clip.authorDisplayName?.trim(), isNotEmpty, reason: clip.id);
      expect(clip.authorUsername?.trim(), isNotEmpty, reason: clip.id);
      expect(clip.description.length, greaterThan(35), reason: clip.id);
    }
  });

  test('los clips por cuenta coinciden con la metadata demo', () {
    for (final creator in ClipsMockData.demoCreators) {
      expect(
        ClipsMockData.clipsForCreator(creator.id),
        hasLength(creator.clipsCount),
        reason: creator.id,
      );
      final likesTotal = ClipsMockData.clipsForCreator(
        creator.id,
      ).fold<int>(0, (total, clip) => total + clip.likes);
      expect(creator.likesTotal, likesTotal, reason: creator.id);
    }
  });

  test('todos los clips demo tienen categoria valida', () {
    final validCategories = ClipsMockData.categories
        .where((category) => category != 'Todos')
        .toSet();

    for (final clip in ClipsMockData.clips) {
      expect(validCategories, contains(clip.category), reason: clip.id);
    }
  });

  test('metricas de clips demo son razonables', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.likes, inInclusiveRange(4, 350), reason: clip.id);
      expect(clip.comments, inInclusiveRange(0, 35), reason: clip.id);
      expect(clip.shares, inInclusiveRange(0, 20), reason: clip.id);
    }
  });

  test('paths de assets de clips demo tienen formato razonable', () {
    for (final clip in ClipsMockData.clips) {
      final thumbnailPath = clip.thumbnailAssetPath;
      final videoPath = clip.videoAssetPath;

      if (thumbnailPath != null) {
        expect(
          thumbnailPath,
          startsWith('assets/images/clips/'),
          reason: clip.id,
        );
        expect(thumbnailPath, isNot(contains('://')), reason: clip.id);
      }

      if (videoPath != null) {
        expect(videoPath, startsWith('assets/videos/clips/'), reason: clip.id);
        expect(videoPath, isNot(contains('://')), reason: clip.id);
      }
    }
  });

  test('todos los clips demo tienen video asset reproducible declarado', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.hasPlayableVideo, isTrue, reason: clip.id);
      expect(clip.videoSourceType, 'asset', reason: clip.id);
      expect(clip.videoAssetPath, isNotNull, reason: clip.id);
      expect(clip.durationSeconds, inInclusiveRange(4, 8), reason: clip.id);
    }
  });

  test('todos los videoAssetPath demo existen y son livianos', () {
    final videoPaths = ClipsMockData.clips
        .map((clip) => clip.videoAssetPath)
        .whereType<String>()
        .toSet();

    expect(videoPaths.length, inInclusiveRange(8, 12));

    for (final videoPath in videoPaths) {
      final file = File(videoPath);
      expect(file.existsSync(), isTrue, reason: videoPath);
      expect(file.path, endsWith('.mp4'), reason: videoPath);
      expect(file.lengthSync(), greaterThan(0), reason: videoPath);
      expect(file.lengthSync(), lessThan(1024 * 1024), reason: videoPath);
    }
  });

  test('todos los clips demo declaran contenido demo local', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.isDemoContent, isTrue, reason: clip.id);
      expect(clip.isStarterContent, isTrue, reason: clip.id);
      expect(clip.availableForAllUsers, isTrue, reason: clip.id);
    }
  });

  test('hay variedad inicial de especies y categorias', () {
    final animalTypes = ClipsMockData.clips
        .map((clip) => clip.animalType.toLowerCase())
        .join(' ');
    final categories = ClipsMockData.clips.map((clip) => clip.category).toSet();

    expect(animalTypes, contains('perro'));
    expect(animalTypes, contains('gato'));
    expect(animalTypes, contains('conejo'));
    expect(animalTypes, contains('ave'));
    expect(animalTypes, contains('pez'));
    expect(animalTypes, contains('hamster'));
    expect(animalTypes, contains('cobayo'));
    expect(
      animalTypes.contains('tortuga') || animalTypes.contains('reptil'),
      isTrue,
    );
    expect(
      categories,
      containsAll(<String>[
        'Juegos',
        'Paseo',
        'Salud general',
        'QR',
        'Adopcion',
        'Higiene',
        'Entrenamiento',
        'Enriquecimiento',
      ]),
    );
    expect(categories.length, greaterThanOrEqualTo(12));
  });

  test('el feed inicial mezcla autores', () {
    String? previousAuthorId;
    for (final clip in ClipsMockData.clips) {
      expect(clip.authorId, isNot(previousAuthorId), reason: clip.id);
      previousAuthorId = clip.authorId;
    }
  });

  test('clips de salud no incluyen claims medicos peligrosos', () {
    final forbiddenClaims = <String>[
      'diagnostica',
      'tratamiento',
      'tratamiento obligatorio',
      'cura',
      'si o si',
      'vacuna si o si',
      'medica',
      'no hace falta veterinario',
    ];

    for (final clip in ClipsMockData.clips.where(
      (clip) => clip.category == 'Salud general' || clip.category == 'Vacunas',
    )) {
      final text = '${clip.title} ${clip.description}'.toLowerCase();
      for (final claim in forbiddenClaims) {
        expect(text, isNot(contains(claim)), reason: clip.id);
      }
      expect(text, contains('veterinario'), reason: clip.id);
    }
  });

  test('perfiles demo no usan datos personales reales ni claims falsos', () {
    final emailPattern = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b');
    final phonePattern = RegExp(r'\b\d{2,4}[- ]?\d{3,4}[- ]?\d{3,4}\b');
    final forbidden = <String>[
      'matricula',
      'verificado real',
      'veterinario real',
      'telefono:',
      'email:',
      'direccion:',
    ];

    for (final creator in ClipsMockData.demoCreators) {
      final text =
          '${creator.displayName} ${creator.username} ${creator.bio} ${creator.location}'
              .toLowerCase();
      expect(text, isNot(matches(emailPattern)), reason: creator.id);
      expect(text, isNot(matches(phonePattern)), reason: creator.id);
      for (final item in forbidden) {
        expect(text, isNot(contains(item)), reason: creator.id);
      }
    }
  });

  testWidgets('la pantalla de Clips sigue mostrando clips demo separados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    expect(find.text(ClipsMockData.clips.first.title), findsOneWidget);
    expect(find.text('Comunidad inicial'), findsWidgets);
  });

  testWidgets('el visor permite avanzar por clips demo separados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text(ClipsMockData.clips[1].title), findsOneWidget);
    expect(find.text(ClipsMockData.clips.first.title), findsNothing);
  });
}
