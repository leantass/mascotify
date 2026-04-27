import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('professional navigation activates and opens public profile', (
    tester,
  ) async {
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

    expect(find.text('Modo profesional'), findsWidgets);
    expect(
      find.textContaining('Presencia profesional pendiente'),
      findsWidgets,
    );

    await tester.tap(find.text('Servicios').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Servicios y operaci'), findsOneWidget);
    expect(find.text('Servicios contemplados'), findsOneWidget);
    expect(find.text('Activar presencia profesional'), findsOneWidget);

    await tester.tap(find.text('Activar presencia profesional'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Abrir perfil'), findsOneWidget);

    await tester.tap(find.textContaining('Abrir perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Perfil profesional'), findsOneWidget);
    expect(find.textContaining('Perfil profesional persistido'), findsWidgets);
  });
}
