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
  });

  testWidgets('Matching permite buscar y no expone datos privados', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const MatchingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Matching de mascotas'), findsOneWidget);
    expect(find.text('Buscar matches'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('matching-search-button')));
    await tester.pump();
    expect(find.text('Buscando matches...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.textContaining('%'), findsWidgets);
    expect(find.text('Zona cercana'), findsWidgets);
    expect(find.textContaining('@'), findsNothing);
    expect(find.textContaining('+54'), findsNothing);
    expect(find.textContaining('direccion'), findsNothing);
    expect(find.textContaining('telefono'), findsNothing);
  });
}
