import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/matching/data/pet_matching_models.dart';
import 'package:mascotify/features/matching/presentation/screens/matching_screen.dart';
import 'package:mascotify/shared/data/mock_data.dart';

import '../../test_helpers.dart';

void main() {
  test('matching local calcula candidatos y motivos', () {
    const service = PetMatchingService();
    final matches = service.findMatches(
      pet: MockData.pets.first,
      criteria: const PetMatchingCriteria(
        zone: 'Palermo',
        goal: PetMatchingGoal.play,
      ),
    );

    expect(matches, isNotEmpty);
    expect(matches.first.percent, greaterThanOrEqualTo(70));
    expect(matches.first.reasons, isNotEmpty);
    expect(matches.any((match) => match.candidate.isMutualMatchDemo), isTrue);
  });

  testWidgets('Matching muestra deck swipe y no expone datos privados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Matching de mascotas'), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-swipe-deck')), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-active-card')), findsOneWidget);
    expect(find.textContaining('%'), findsWidgets);
    expect(find.text('Buscar matches'), findsNothing);
    expect(find.textContaining('@'), findsNothing);
    expect(find.textContaining('+54'), findsNothing);
    expect(find.textContaining('direccion'), findsNothing);
    expect(find.textContaining('telefono'), findsNothing);
  });

  testWidgets('Matching mobile muestra card y acciones sin scroll inicial', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('matching-above-fold-layout')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('matching-compact-controls')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('matching-active-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-pass-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-like-button')), findsOneWidget);

    final screenHeight = tester.view.physicalSize.height;
    final cardRect = tester.getRect(
      find.byKey(const ValueKey('matching-active-card')),
    );
    final passRect = tester.getRect(
      find.byKey(const ValueKey('matching-pass-button')),
    );
    final likeRect = tester.getRect(
      find.byKey(const ValueKey('matching-like-button')),
    );

    expect(cardRect.top, greaterThanOrEqualTo(0));
    expect(cardRect.bottom, lessThanOrEqualTo(screenHeight));
    expect(passRect.bottom, lessThanOrEqualTo(screenHeight));
    expect(likeRect.bottom, lessThanOrEqualTo(screenHeight));
    expect(tester.takeException(), isNull);
  });

  testWidgets('swipe y botones avanzan entre cards', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    final firstCard = find.byKey(const ValueKey('matching-active-card'));
    expect(firstCard, findsOneWidget);

    await tester.drag(firstCard, const Offset(-220, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('matching-active-card')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('matching-pass-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('matching-active-card')), findsOneWidget);
  });

  testWidgets('like sobre match mutuo demo muestra modal seguro', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('matching-like-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.text('Hicieron match!'), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-mutual-sheet')), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-heart-pop')), findsOneWidget);
    expect(find.byKey(const ValueKey('matching-floating-heart')), findsWidgets);
    expect(find.text('Contacto seguro proximamente'), findsOneWidget);
    expect(find.textContaining('mediado por Mascotify'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
    expect(find.textContaining('+54'), findsNothing);
  });

  testWidgets('deck muestra estado vacio al terminar matches', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('matching-pass-button')));
      await tester.pumpAndSettle();
    }

    expect(find.byKey(const ValueKey('matching-empty-deck')), findsOneWidget);
    expect(find.text('No hay mas matches por ahora'), findsOneWidget);
    expect(find.text('Volver a buscar'), findsOneWidget);
  });

  testWidgets('cambiar objetivo reconstruye el deck con loader real', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(PetMatchingGoal.play.label));
    await tester.pump();
    expect(find.text('Buscando matches...'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('matching-swipe-deck')), findsOneWidget);
  });

  testWidgets('ayuda contextual de Matching abre el tema correcto', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('contextual-help-matching')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('contextual-help-matching')));
    await tester.pumpAndSettle();

    expect(find.text('Tema abierto: Matching.'), findsOneWidget);
    expect(find.textContaining('Elige tu mascota y objetivo'), findsOneWidget);
    expect(find.textContaining('contacto real sera mediado'), findsOneWidget);
  });
}
