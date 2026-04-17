import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app.dart';
import 'features/auth/data/local_auth_repository.dart';
import 'features/auth/presentation/auth_session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final repository = LocalAuthRepository(preferences);
  final sessionController = AuthSessionController(repository: repository);
  await sessionController.initialize();

  runApp(MascotifyApp(sessionController: sessionController));
}
