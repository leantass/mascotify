import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app.dart';
import 'features/auth/data/local_auth_repository.dart';
import 'features/auth/presentation/auth_session_controller.dart';
import 'shared/data/app_data_source.dart';
import 'shared/data/local_persistent_data_source.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final repository = LocalAuthRepository(preferences);
  final sessionController = AuthSessionController(repository: repository);
  // AppData depends on the auth controller because every persisted slice is
  // scoped to the active account. Wiring both here keeps the rest of the app
  // free from bootstrap decisions.
  AppData.source = PersistentLocalMascotifyDataSource(
    preferences: preferences,
    sessionController: sessionController,
  );
  // Restore auth first so the data source can hydrate the correct account
  // state before the first frame.
  await sessionController.initialize();
  await AppData.syncCurrentUserState();

  runApp(MascotifyApp(sessionController: sessionController));
}
