import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('professional mode restores after app reconstruction', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final firstSession = await buildPersistentTestAppSession();

    await tester.pumpWidget(firstSession.buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Demo profesional'));
    await tester.pumpAndSettle();

    expect(find.text('Servicios'), findsWidgets);
    expect(find.text('Modo profesional'), findsWidgets);

    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await tester.pumpWidget(restoredSession.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Servicios'), findsWidgets);
    expect(find.text('Modo profesional'), findsWidgets);
  });
}
