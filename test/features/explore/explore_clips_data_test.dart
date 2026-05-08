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

  test('todos los clips demo tienen titulo y descripcion no vacios', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.title.trim(), isNotEmpty, reason: clip.id);
      expect(clip.description.trim(), isNotEmpty, reason: clip.id);
      expect(clip.animalType.trim(), isNotEmpty, reason: clip.id);
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

  test('likes y comentarios de clips demo no son negativos', () {
    for (final clip in ClipsMockData.clips) {
      expect(clip.likes, greaterThanOrEqualTo(0), reason: clip.id);
      expect(clip.comments, greaterThanOrEqualTo(0), reason: clip.id);
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

  testWidgets('la pantalla de Clips sigue mostrando clips demo separados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    expect(find.text(ClipsMockData.clips.first.title), findsOneWidget);
    expect(find.text('Mascotify demo'), findsWidgets);
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
