import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_clip_viewer_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';
import 'package:mascotify/shared/models/social_models.dart';

import '../../test_helpers.dart';

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  testWidgets('desde Clips se puede abrir el visor de un clip', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await _openFirstClipFromExplore(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Volver'), findsOneWidget);
  });

  testWidgets('el visor muestra datos del clip seleccionado', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: 'clip-02',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Perro aprende a usar su QR'), findsOneWidget);
    expect(
      find.text(
        'Le cargue el QR en el collar para que, si se pierde, puedan avisarme sin ver mis datos privados.',
      ),
      findsOneWidget,
    );
    expect(find.text('QR'), findsWidgets);
    expect(find.text('Perro'), findsWidgets);
  });

  testWidgets('like y unlike cambia el estado visual en el visor', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: 'clip-01',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('128 likes'), findsOneWidget);
    await tester.tap(find.text('128 likes'));
    await tester.pumpAndSettle();
    expect(find.text('129 likes'), findsOneWidget);

    await tester.tap(find.text('129 likes'));
    await tester.pumpAndSettle();
    expect(find.text('128 likes'), findsOneWidget);
  });

  testWidgets('scroll vertical al siguiente clip muestra otro clip', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: 'clip-01',
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(0, -700));
    await tester.pumpAndSettle();

    final nextClipPosition =
        ClipsMockData.clips.indexWhere((clip) => clip.id == 'clip-02') + 1;
    expect(find.text('Perro aprende a usar su QR'), findsOneWidget);
    expect(find.text('1/${ClipsMockData.clips.length}'), findsNothing);
    expect(
      find.text('$nextClipPosition/${ClipsMockData.clips.length}'),
      findsOneWidget,
    );
  });

  testWidgets('el visor usa PageView vertical y no muestra flechas', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: 'clip-02',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextButton, 'Volver'), findsOneWidget);
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.scrollDirection, Axis.vertical);
    expect(find.text('Clip anterior'), findsNothing);
    expect(find.text('Siguiente clip'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Volver a Clips'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Clip anterior'), findsNothing);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
  });

  testWidgets('desktop usa frame vertical tipo telefono y no cuadrado', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: ClipsMockData.clips.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final frameSize = tester.getSize(
      find.byKey(const ValueKey('clips-vertical-frame')),
    );
    final pageViewSize = tester.getSize(
      find.byKey(const ValueKey('clips-vertical-page-view')),
    );

    expect(frameSize.width, lessThan(520));
    expect(frameSize.height, greaterThan(frameSize.width * 1.65));
    expect(frameSize.width / frameSize.height, closeTo(480 / 854, 0.03));
    expect(pageViewSize.width, closeTo(frameSize.width, 3));
    expect(pageViewSize.height, closeTo(frameSize.height, 3));
  });

  testWidgets('mobile mantiene visor de alto completo', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: ClipsMockData.clips.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final frameSize = tester.getSize(
      find.byKey(const ValueKey('clips-vertical-frame')),
    );

    expect(frameSize.width, 390);
    expect(frameSize.height, 844);
  });

  testWidgets('volver desde el visor retorna a Explorar Clips', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await _openFirstClipFromExplore(tester);
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('viewport mobile no crashea y muestra controles principales', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await _openFirstClipFromExplore(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Clip anterior'), findsNothing);
    expect(find.text('Siguiente clip'), findsNothing);
    expect(find.text('Mascotify'), findsWidgets);
    expect(find.text('Contenido oficial'), findsWidgets);
    expect(find.text('Video local'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clip oficial con asset muestra Mascotify oficial', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: ClipsMockData.clips.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mascotify'), findsWidgets);
    expect(find.text('Contenido oficial'), findsWidgets);
    expect(find.text('Mascotify oficial'), findsWidgets);
    expect(find.text('Video local'), findsNothing);
    expect(find.text('Clip demo local'), findsNothing);
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('clip sin videoAssetPath muestra fallback seguro', (
    tester,
  ) async {
    setDesktopViewport(tester);

    const fallbackClip = ExploreClip(
      id: 'fallback-clip',
      title: 'Clip demo sin archivo',
      description: 'Fallback visual seguro para un clip demo local.',
      category: 'Consejos',
      animalType: 'Perro',
      likes: 4,
      comments: 0,
      videoSourceType: 'placeholder',
    );

    await tester.pumpWidget(
      buildTestApp(
        const ExploreClipViewerScreen(
          clips: <ExploreClip>[fallbackClip],
          initialClipId: 'fallback-clip',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Demo'), findsOneWidget);
    expect(find.text('Clip demo local'), findsOneWidget);
    expect(find.text('Fallback demo animado'), findsOneWidget);
  });

  testWidgets('clip inexistente muestra estado seguro', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(
        ExploreClipViewerScreen(
          clips: ClipsMockData.clips,
          initialClipId: 'clip-inexistente',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clip no disponible'), findsOneWidget);
    expect(find.text('Volver a Clips'), findsOneWidget);
  });
}

Future<void> _openFirstClipFromExplore(WidgetTester tester) async {
  await tester.tap(find.text('Clips'));
  await tester.pumpAndSettle();
}
