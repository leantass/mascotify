import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/profile/presentation/screens/profile_screen.dart';

import '../../test_helpers.dart';

void main() {
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await Scrollable.ensureVisible(
      tester.element(finder),
      alignment: 0.35,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpProfileScreen(
    WidgetTester tester,
    TestAppSession session,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const ProfileScreen(),
        controller: session.controller,
        localeController: session.localeController,
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, 1600),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, -900),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Preferencias y plan'), findsOneWidget);
  }

  Future<void> openDemoFamilySession(WidgetTester tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(session.buildApp());
    await tester.pumpAndSettle();
    await pumpProfileScreen(tester, session);
  }

  Future<void> restoreSessionAndOpenProfile(WidgetTester tester) async {
    final restoredSession = await buildPersistentTestAppSession(
      resetPreferences: false,
    );
    await restoredSession.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );
    await pumpProfileScreen(tester, restoredSession);
  }

  T testerWidget<T extends Widget>(Finder finder) {
    final element = finder.evaluate().single;
    return element.widget as T;
  }

  bool switchValue(Finder finder) {
    return testerWidget<Switch>(finder).value;
  }

  testWidgets('notification preferences persist after app reconstruction', (
    tester,
  ) async {
    await openDemoFamilySession(tester);

    await tester.tap(find.text('Notificaciones').first);
    await tester.pumpAndSettle();

    final messagesSwitch = find.byKey(
      const ValueKey('notifications-messages-switch'),
    );
    expect(switchValue(messagesSwitch), isTrue);

    await scrollTo(tester, find.text('Notificaciones de mensajes'));
    await tester.tap(messagesSwitch);
    await tester.pumpAndSettle();
    expect(switchValue(messagesSwitch), isFalse);

    await restoreSessionAndOpenProfile(tester);
    await tester.tap(find.text('Notificaciones').first);
    await tester.pumpAndSettle();

    expect(switchValue(messagesSwitch), isFalse);
  });

  testWidgets('configuration preferences persist after app reconstruction', (
    tester,
  ) async {
    await openDemoFamilySession(tester);

    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();

    final publicProfileSwitch = find.byKey(
      const ValueKey('config-public-profile-switch'),
    );
    expect(switchValue(publicProfileSwitch), isTrue);

    await scrollTo(tester, find.text('Perfil visible'));
    await tester.tap(publicProfileSwitch);
    await tester.pumpAndSettle();
    expect(switchValue(publicProfileSwitch), isFalse);

    await restoreSessionAndOpenProfile(tester);
    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();

    expect(switchValue(publicProfileSwitch), isFalse);
  });

  testWidgets('subscription plan selection persists locally', (tester) async {
    await openDemoFamilySession(tester);

    final planDropdown = find.byKey(
      const ValueKey('subscription-plan-dropdown'),
    );
    expect(find.text('Plan actual'), findsOneWidget);

    await scrollTo(tester, find.text('Plan actual'));
    await tester.tap(planDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mascotify Pro').last);
    await tester.pumpAndSettle();

    expect(find.text('Mascotify Pro'), findsWidgets);

    await restoreSessionAndOpenProfile(tester);

    expect(find.text('Mascotify Pro'), findsWidgets);
  });

  testWidgets('subscription plans show updated prices and pet limits', (
    tester,
  ) async {
    await openDemoFamilySession(tester);

    await scrollTo(tester, find.text('Plan actual'));

    expect(find.text('US\$ 0 mensual'), findsOneWidget);
    expect(find.text('US\$ 1,99 mensual'), findsOneWidget);
    expect(find.text('US\$ 4,99 mensual'), findsOneWidget);
    expect(find.text('Hasta 1 mascota'), findsOneWidget);
    expect(find.text('Hasta 5 mascotas'), findsOneWidget);
    expect(
      find.text('Mascotas ilimitadas con politica de uso razonable'),
      findsOneWidget,
    );
  });

  testWidgets('subscription plan cards keep consistent desktop layout', (
    tester,
  ) async {
    setDesktopViewport(tester);
    await openDemoFamilySession(tester);

    await scrollTo(tester, find.text('Plan actual'));

    final freeSize = tester.getSize(
      find.byKey(const ValueKey('plan-card-free')),
    );
    final plusSize = tester.getSize(
      find.byKey(const ValueKey('plan-card-plus')),
    );
    final proSize = tester.getSize(find.byKey(const ValueKey('plan-card-pro')));

    expect(freeSize.width, plusSize.width);
    expect(plusSize.width, proSize.width);
    expect(freeSize.height, plusSize.height);
    expect(plusSize.height, proSize.height);
  });

  testWidgets('configuration exposes and persists manual language preference', (
    tester,
  ) async {
    await openDemoFamilySession(tester);

    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();
    await scrollTo(
      tester,
      find.byKey(const ValueKey('language-preference-dropdown')),
    );

    await tester.tap(
      find.byKey(const ValueKey('language-preference-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<DropdownButtonFormField<String>>(
            find.byKey(const ValueKey('language-preference-dropdown')),
          )
          .initialValue,
      'English',
    );

    await restoreSessionAndOpenProfile(tester);
    await tester.tap(find.textContaining('Configuraci').first);
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsWidgets);
  });
}
