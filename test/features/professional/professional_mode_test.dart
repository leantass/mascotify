import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets(
    'professional beta preview does not authenticate or activate mode',
    (tester) async {
      setDesktopViewport(tester);
      final session = await buildPersistentTestAppSession();

      await tester.pumpWidget(session.buildApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview profesional beta'));
      await tester.pumpAndSettle();

      expect(session.controller.isAuthenticated, isFalse);
      expect(find.text('Profesionales pet beta'), findsWidgets);
      expect(find.text('Modo profesional'), findsNothing);
      expect(find.text('Activar presencia profesional'), findsNothing);
    },
  );
}
