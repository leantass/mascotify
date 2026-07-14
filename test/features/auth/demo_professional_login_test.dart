import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('professional demo opens beta preview without logging in', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Preview profesional beta'));
    await tester.pumpAndSettle();

    expect(session.controller.isAuthenticated, isFalse);
    expect(find.text('Profesionales pet beta'), findsWidgets);
    expect(find.text('Beta'), findsWidgets);
    expect(find.textContaining('Sin agenda real'), findsWidgets);
    await tester.scrollUntilVisible(find.textContaining('No se pueden'), 500);
    expect(find.textContaining('No se pueden cargar datos'), findsOneWidget);
    expect(find.text('Modo profesional'), findsNothing);
  });
}
