import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_clip_viewer_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';

import '../../test_helpers.dart';

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  testWidgets('desde Clips se puede abrir el visor de un clip', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await _openFirstClipFromExplore(tester);

    expect(find.text('Visor de clips'), findsOneWidget);
    expect(find.text('Volver a Clips'), findsOneWidget);
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
        'Milo espera su premio despues de mostrar la placa como todo un profesional.',
      ),
      findsOneWidget,
    );
    expect(find.text('Consejos'), findsWidgets);
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

  testWidgets('navegar al siguiente clip muestra otro clip', (tester) async {
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
    await tester.tap(find.text('Siguiente clip'));
    await tester.pumpAndSettle();

    expect(find.text('Perro aprende a usar su QR'), findsOneWidget);
    expect(find.text('1/6'), findsNothing);
    expect(find.text('2/6'), findsOneWidget);
  });

  testWidgets('volver desde el visor retorna a Explorar Clips', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await _openFirstClipFromExplore(tester);
    await tester.tap(find.text('Volver a Clips'));
    await tester.pumpAndSettle();

    expect(find.text('Clips demo locales'), findsOneWidget);
    expect(find.text('Visor de clips'), findsNothing);
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

    expect(find.text('Visor de clips'), findsOneWidget);
    expect(find.text('Siguiente clip'), findsOneWidget);
    expect(find.text('Clip demo local'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clip sin videoAssetPath muestra placeholder seguro', (
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

    expect(find.text('Demo'), findsOneWidget);
    expect(find.text('Clip demo local'), findsOneWidget);
    expect(find.byIcon(Icons.pets_rounded), findsOneWidget);
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
  await tester.drag(find.byType(ListView), const Offset(0, -520));
  await tester.pumpAndSettle();
  await tester.tap(find.text('El gato que se adueno del sillon'));
  await tester.pumpAndSettle();
}
