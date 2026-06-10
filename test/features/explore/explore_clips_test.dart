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

  testWidgets('Explorar muestra acceso a Clips', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));

    expect(find.text('Ecosistema'), findsOneWidget);
    expect(find.text('Clips'), findsOneWidget);
    expect(find.text('Ecosistema social'), findsOneWidget);
  });

  testWidgets('al entrar a Clips se abre el visor vertical directo', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _openClipsViewer(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
    expect(find.text('Video local'), findsOneWidget);
  });

  testWidgets('scroll vertical cambia al siguiente clip', (tester) async {
    setDesktopViewport(tester);

    await _openClipsViewer(tester);
    await tester.drag(find.byType(PageView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('Perro aprende a usar su QR'), findsOneWidget);
    expect(find.text('2/${ClipsMockData.clips.length}'), findsOneWidget);
  });

  testWidgets('like y unlike cambian el estado visual en el visor', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _openClipsViewer(tester);

    expect(find.text('128 likes'), findsOneWidget);
    await tester.tap(find.text('128 likes'));
    await tester.pumpAndSettle();
    expect(find.text('129 likes'), findsOneWidget);

    await tester.tap(find.text('129 likes'));
    await tester.pumpAndSettle();
    expect(find.text('128 likes'), findsOneWidget);
  });

  testWidgets('la vista Clips funciona en viewport mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openClipsViewer(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('volver desde Clips retorna a Ecosistema', (tester) async {
    setDesktopViewport(tester);

    await _openClipsViewer(tester);
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
  });
}

Future<void> _openClipsViewer(WidgetTester tester) async {
  await tester.pumpWidget(buildTestApp(const ExploreScreen()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Clips'));
  await tester.pumpAndSettle();
}
