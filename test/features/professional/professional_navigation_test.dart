import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets(
    'professional account request remains family-first and beta locked',
    (tester) async {
      setDesktopViewport(tester);
      final session = await buildPersistentTestAppSession();
      await session.controller.register(
        ownerName: 'Profesional futuro QA',
        email: 'professional-navigation-qa@mascotify.local',
        city: 'Buenos Aires',
        password: 'password123',
        experience: AccountExperience.professional,
      );
      await session.controller.completeOnboarding();

      await tester.pumpWidget(session.buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Modo familia'), findsWidgets);
      expect(find.text('Modo profesional'), findsNothing);
      expect(find.text('Servicios'), findsNothing);

      await _openTab(tester, 'Explorar');
      await tester.scrollUntilVisible(find.text('Ver preview beta'), 500);
      await tester.tap(find.text('Ver preview beta').first);
      await tester.pumpAndSettle();

      expect(find.text('Profesionales pet beta'), findsWidgets);
      expect(find.textContaining('Sin agenda real'), findsWidgets);
      expect(find.text('Activar presencia profesional'), findsNothing);
      expect(find.text('Publicar base profesional'), findsNothing);
    },
  );
}

Future<void> _openTab(WidgetTester tester, String label) async {
  final finder = find.text(label).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
