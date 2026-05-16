import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app.dart';
import 'package:mascotify/core/localization/app_locale_controller.dart';
import 'package:mascotify/core/localization/app_localizations.dart';
import 'package:mascotify/features/auth/data/google_auth_service.dart';
import 'package:mascotify/features/auth/data/local_auth_repository.dart';
import 'package:mascotify/features/auth/presentation/auth_session_controller.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/local_persistent_data_source.dart';
import 'package:mascotify/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestAppSession {
  const TestAppSession({
    required this.preferences,
    required this.controller,
    required this.localeController,
  });

  final SharedPreferences preferences;
  final AuthSessionController controller;
  final AppLocaleController localeController;

  Widget buildApp() {
    return MascotifyApp(
      sessionController: controller,
      localeController: localeController,
    );
  }
}

class TestGoogleAuthService extends GoogleAuthService {
  @override
  Future<GoogleAuthResult> signIn() async {
    return const GoogleAuthResult.cancelled();
  }

  @override
  Future<void> signOut() async {}
}

Future<AuthSessionController> buildTestAuthController() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final preferences = await SharedPreferences.getInstance();
  final repository = LocalAuthRepository(preferences);
  final controller = AuthSessionController(
    repository: repository,
    googleAuthService: TestGoogleAuthService(),
  );
  await controller.initialize();
  return controller;
}

Future<TestAppSession> buildPersistentTestAppSession({
  bool resetPreferences = true,
}) async {
  if (resetPreferences) {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  }

  final preferences = await SharedPreferences.getInstance();
  final repository = LocalAuthRepository(preferences);
  final controller = AuthSessionController(
    repository: repository,
    googleAuthService: TestGoogleAuthService(),
  );
  AppData.source = PersistentLocalMascotifyDataSource(
    preferences: preferences,
    sessionController: controller,
  );
  final localeController = AppLocaleController(preferences: preferences);
  await controller.initialize();
  await AppData.syncCurrentUserState();

  return TestAppSession(
    preferences: preferences,
    controller: controller,
    localeController: localeController,
  );
}

void setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1365, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> fillPetForm(
  WidgetTester tester, {
  required String name,
  String breed = 'Mestizo / Sin raza definida',
  String age = '3',
  String? manualCity,
}) async {
  await tester.enterText(find.byKey(const ValueKey('pet-name-field')), name);

  if (breed != 'Mestizo / Sin raza definida') {
    await tester.tap(find.byKey(const ValueKey('pet-breed-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Otra').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('pet-other-breed-field')),
      breed,
    );
  }

  await tester.enterText(find.byKey(const ValueKey('pet-age-field')), age);

  if (manualCity != null) {
    await tester.tap(find.byKey(const ValueKey('pet-city-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Otra localidad').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('pet-other-city-field')),
      manualCity,
    );
  }
}

Future<void> tapSavePetForm(WidgetTester tester) async {
  final saveButton = find.byKey(const ValueKey('pet-save-button'));
  await Scrollable.ensureVisible(
    tester.element(saveButton),
    alignment: 0.85,
    duration: Duration.zero,
  );
  await tester.pumpAndSettle();
  await tester.tap(saveButton, warnIfMissed: false);
  await tester.pumpAndSettle();
}

Widget buildTestApp(
  Widget child, {
  AuthSessionController? controller,
  AppLocaleController? localeController,
}) {
  Widget app = MaterialApp(
    theme: AppTheme.light(),
    locale: localeController?.materialLocale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: child,
  );

  if (controller == null) {
    return app;
  }

  app = AuthScope(controller: controller, child: app);
  if (localeController != null) {
    app = AppLocaleScope(controller: localeController, child: app);
  }
  return app;
}
