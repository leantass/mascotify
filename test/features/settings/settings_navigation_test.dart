import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets(
    'profile settings tabs render subscription notifications and config',
    (tester) async {
      setDesktopViewport(tester);
      final session = await buildPersistentTestAppSession();
      await session.controller.login(
        email: LocalAuthSeedData.familyEmail,
        password: LocalAuthSeedData.demoPassword,
      );

      await tester.pumpWidget(session.buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
      await tester.pumpAndSettle();

      expect(find.text('Preferencias y plan'), findsOneWidget);
      expect(find.textContaining('Suscripci'), findsWidgets);
      expect(find.text('Plan actual'), findsOneWidget);
      expect(find.textContaining('billing real'), findsOneWidget);

      await tester.tap(find.text('Notificaciones').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('estrat'), findsOneWidget);

      await tester.tap(find.textContaining('Configuraci').first);
      await tester.pumpAndSettle();
      expect(find.text('Privacidad'), findsOneWidget);
      expect(find.text('Seguridad'), findsOneWidget);
      expect(find.text('Modificar'), findsOneWidget);
      expect(find.text('Cambiar'), findsOneWidget);
    },
  );
}
