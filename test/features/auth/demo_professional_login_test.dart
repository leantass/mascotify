import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('demo professional login opens the professional experience', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo profesional'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsNothing);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Servicios'), findsWidgets);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Modo profesional'), findsWidgets);
  });
}
