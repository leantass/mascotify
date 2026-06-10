import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/widgets/paw_loading_indicator.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('PawLoadingIndicator renderiza huella y texto', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(
          body: PawLoadingIndicator(message: 'Buscando videos nuevos...'),
        ),
      ),
    );

    expect(find.byIcon(Icons.pets_rounded), findsOneWidget);
    expect(find.text('Buscando videos nuevos...'), findsOneWidget);
  });

  testWidgets('PawLoadingIndicator usa RotationTransition', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const Scaffold(body: PawLoadingIndicator(message: 'Cargando clips...')),
      ),
    );

    expect(find.byType(RotationTransition), findsWidgets);
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });
}
