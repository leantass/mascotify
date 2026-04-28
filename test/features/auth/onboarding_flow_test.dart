import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('family onboarding completes into family dashboard', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.register(
      ownerName: 'Familia Onboarding QA',
      email: 'family-onboarding-flow@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Onboarding inicial para familias'), findsOneWidget);
    expect(find.text('Crear la cuenta base'), findsOneWidget);
    expect(find.text('Activar el perfil familia'), findsOneWidget);

    await tester.tap(find.text('Continuar como familia'));
    await tester.pumpAndSettle();

    expect(session.controller.hasCompletedOnboarding, isTrue);
    expect(find.text('Modo familia'), findsWidgets);
    expect(find.text('Inicio'), findsOneWidget);
  });

  testWidgets('professional onboarding completes into professional dashboard', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.register(
      ownerName: 'Profesional Onboarding QA',
      email: 'professional-onboarding-flow@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.professional,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Onboarding inicial para profesionales y negocios'),
      findsOneWidget,
    );
    expect(find.text('Activar el perfil profesional'), findsOneWidget);
    expect(find.text('Preparar publicación futura'), findsOneWidget);

    await tester.tap(find.text('Continuar como profesional'));
    await tester.pumpAndSettle();

    expect(session.controller.hasCompletedOnboarding, isTrue);
    expect(find.text('Modo profesional'), findsWidgets);
    expect(find.text('Servicios'), findsWidgets);
  });
}
