import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/presentation/screens/account_onboarding_screen.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('family onboarding renders the initial setup sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1365, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = await buildTestAuthController();
    await controller.register(
      ownerName: 'Familia Test',
      email: 'familia-test@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.family,
    );

    await tester.pumpWidget(
      buildTestApp(
        const AccountOnboardingScreen(experience: AccountExperience.family),
        controller: controller,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Onboarding inicial'), findsOneWidget);
    expect(find.text('Como queda pensada la cuenta'), findsOneWidget);
    expect(find.text('Secuencia inicial'), findsOneWidget);
    expect(find.text('Senales del perfil elegido'), findsOneWidget);
    expect(find.text('Continuar como familia'), findsOneWidget);
  });
}
