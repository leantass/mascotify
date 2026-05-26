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
    expect(ClipsMockData.demoCreators.length, greaterThanOrEqualTo(10));
    expect(ClipsMockData.demoCreators.length, lessThanOrEqualTo(15));
    expect(ClipsMockData.clips.length, greaterThanOrEqualTo(25));
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
      expect(creator.followersCount, inInclusiveRange(0, 500));
      expect(creator.clipsCount, inInclusiveRange(2, 4));
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
      expect(clip.sourceLabel, 'Contenido inicial', reason: clip.id);
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
    }
  });

  test('los clips por cuenta coinciden con la metadata demo', () {
    for (final creator in ClipsMockData.demoCreators) {
      expect(
        ClipsMockData.clipsForCreator(creator.id),
        hasLength(creator.clipsCount),
        reason: creator.id,
      );
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
      expect(clip.likes, inInclusiveRange(8, 420), reason: clip.id);
      expect(clip.comments, inInclusiveRange(0, 40), reason: clip.id);
      expect(clip.shares, inInclusiveRange(0, 25), reason: clip.id);
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

  test('todos los clips demo declaran contenido demo local', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.isDemoContent, isTrue, reason: clip.id);
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
    expect(animalTypes.contains('ave') || animalTypes.contains('pez'), isTrue);
    expect(
      animalTypes.contains('hamster') ||
          animalTypes.contains('cobayo') ||
          animalTypes.contains('varias especies'),
      isTrue,
    );
    expect(categories.length, greaterThanOrEqualTo(8));
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
      'cura',
      'si o si',
      'no hace falta veterinario',
    ];

    for (final clip in ClipsMockData.clips.where(
      (clip) => clip.category == 'Salud general',
    )) {
      final text = '${clip.title} ${clip.description}'.toLowerCase();
      for (final claim in forbiddenClaims) {
        expect(text, isNot(contains(claim)), reason: clip.id);
      }
      expect(text, contains('veterinario'), reason: clip.id);
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
    expect(find.text('Contenido inicial'), findsWidgets);
  });

  testWidgets('los filtros siguen funcionando con los datos separados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Profesionales'));
    await tester.pumpAndSettle();

    expect(
      find.text('Veterinaria responde: senales de alerta'),
      findsOneWidget,
    );
    expect(find.text('Bloopers de cachorros'), findsNothing);
  });
}
