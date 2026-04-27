import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app.dart';
import 'package:mascotify/features/auth/data/google_auth_service.dart';
import 'package:mascotify/features/auth/data/local_auth_repository.dart';
import 'package:mascotify/features/auth/presentation/auth_session_controller.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/local_persistent_data_source.dart';
import 'package:mascotify/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestAppSession {
  const TestAppSession({required this.preferences, required this.controller});

  final SharedPreferences preferences;
  final AuthSessionController controller;

  Widget buildApp() {
    return MascotifyApp(sessionController: controller);
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
  await controller.initialize();
  await AppData.syncCurrentUserState();

  return TestAppSession(preferences: preferences, controller: controller);
}

void setDesktopViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1365, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget buildTestApp(Widget child, {AuthSessionController? controller}) {
  final app = MaterialApp(theme: AppTheme.light(), home: child);

  if (controller == null) {
    return app;
  }

  return AuthScope(controller: controller, child: app);
}
