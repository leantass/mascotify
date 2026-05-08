import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/models/social_models.dart';

import '../../test_helpers.dart';

class _ClipsOnlyDataSource extends MockMascotifyDataSource {
  const _ClipsOnlyDataSource(this.clips);

  final List<ExploreClip> clips;

  @override
  List<ExploreClip> getExploreClips() {
    return List.unmodifiable(clips);
  }
}

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

  testWidgets('al entrar a Clips se muestran clips demo', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    expect(find.text('Clips demo locales'), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
    expect(find.text('Perro aprende a usar su QR'), findsOneWidget);
    expect(find.text('Clip demo local'), findsWidgets);
  });

  testWidgets('filtro Bloopers muestra clips de esa categoria', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Bloopers'));
    await tester.pumpAndSettle();

    expect(find.text('Bloopers de cachorros'), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsNothing);
  });

  testWidgets('filtro sin resultados muestra empty state y permite volver', (
    tester,
  ) async {
    setDesktopViewport(tester);
    AppData.source = const _ClipsOnlyDataSource([
      ExploreClip(
        id: 'only-bloopers',
        title: 'Bloopers mini',
        description: 'Un clip demo para probar filtros vacios.',
        category: 'Bloopers',
        animalType: 'Perro',
        likes: 7,
        comments: 1,
      ),
    ]);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rescates'));
    await tester.pumpAndSettle();

    expect(find.text('No hay clips en esta categoria'), findsOneWidget);

    await tester.tap(find.text('Volver a Todos'));
    await tester.pumpAndSettle();

    expect(find.text('Bloopers mini'), findsOneWidget);
  });

  testWidgets('like y unlike cambian el estado visual', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -520));
    await tester.pumpAndSettle();
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

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    expect(find.text('Clips demo locales'), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('volver a Ecosistema mantiene Explorar usable', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ecosistema'));
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(find.text('Bandeja social'), findsOneWidget);
  });
}
