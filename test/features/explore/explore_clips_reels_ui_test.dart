import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_clip_viewer_screen.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';
import 'package:mascotify/shared/models/social_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('el visor muestra acciones laterales visibles', (tester) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.text('128 likes'), findsOneWidget);
    expect(find.byIcon(Icons.mode_comment_outlined), findsOneWidget);
    expect(find.text('18 comentarios'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);
    expect(find.text('Compartir'), findsOneWidget);
  });

  testWidgets('no hay botones de accion vacios en el visor', (tester) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    final tooltipMessages = tester
        .widgetList<Tooltip>(find.byType(Tooltip))
        .map((tooltip) => tooltip.message)
        .toList();

    expect(tooltipMessages, isNotEmpty);
    expect(tooltipMessages, everyElement(isNot(isEmpty)));
    expect(
      tooltipMessages,
      containsAll(<String>[
        '128 likes',
        '18 comentarios',
        'Guardar',
        'Compartir',
      ]),
    );
  });

  testWidgets('like y unlike cambia estado visual estilo Reels', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    await tester.tap(find.text('128 likes'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.text('129 likes'), findsOneWidget);

    await tester.tap(find.text('129 likes'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.text('128 likes'), findsOneWidget);
  });

  testWidgets('guardar y desguardar cambia estado visual', (tester) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.text('Guardado'), findsOneWidget);

    await tester.tap(find.text('Guardado'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });

  testWidgets('compartir muestra feedback seguro', (tester) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    await tester.tap(find.text('Compartir'));
    await tester.pumpAndSettle();

    expect(find.text('1 compartidos'), findsOneWidget);
    expect(find.text('Clip listo para compartir'), findsOneWidget);
  });

  testWidgets('comentarios preparados no crashean y muestran feedback', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    await tester.tap(find.text('18 comentarios'));
    await tester.pumpAndSettle();

    expect(
      find.text('Comentarios disponibles en la proxima etapa'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('seguir creador cambia a siguiendo cuando hay autor', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final remoteClip = _remoteClip();

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: <ExploreClip>[remoteClip],
          initialClipId: remoteClip.id,
          onToggleFollow: (clip) async =>
              clip.copyWith(isFollowingAuthor: !clip.isFollowingAuthor),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seguir'), findsOneWidget);
    await tester.tap(find.text('Seguir'));
    await tester.pumpAndSettle();
    expect(find.text('Siguiendo'), findsOneWidget);
  });

  testWidgets('viewport mobile mantiene acciones principales visibles', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    expect(find.text('128 likes'), findsOneWidget);
    expect(find.text('18 comentarios'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
    expect(find.text('Compartir'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clip demo local muestra placeholder y acciones visibles', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _pumpViewer(tester, ClipsMockData.clips.first);

    expect(find.text('Clip demo local'), findsOneWidget);
    expect(find.byIcon(Icons.pets_rounded), findsOneWidget);
    expect(find.text('128 likes'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });

  testWidgets('clip remoto conserva acciones visibles sin etiqueta demo', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final remoteClip = _remoteClip();

    await _pumpViewer(tester, remoteClip);

    expect(find.text('Video remoto'), findsOneWidget);
    expect(find.text('Clip demo local'), findsNothing);
    expect(find.text('Backend social'), findsWidgets);
    expect(find.text('44 likes'), findsOneWidget);
    expect(find.text('Seguir'), findsOneWidget);
  });
}

Future<void> _pumpViewer(WidgetTester tester, ExploreClip clip) async {
  await tester.pumpWidget(
    buildTestApp(
      ExploreClipViewerScreen(
        clips: <ExploreClip>[clip],
        initialClipId: clip.id,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

ExploreClip _remoteClip() {
  return const ExploreClip(
    id: 'remote-reel-01',
    title: 'Rescate remoto con final feliz',
    description: 'Un clip remoto preparado para el feed social.',
    category: 'Rescates',
    animalType: 'Perro',
    authorId: 'author-01',
    likes: 44,
    comments: 8,
    shares: 2,
    sourceLabel: 'Backend social',
    isDemoContent: false,
  );
}
