import 'package:flutter/material.dart';
import 'package:mascotify/features/auth/data/local_auth_repository.dart';
import 'package:mascotify/features/auth/presentation/auth_session_controller.dart';
import 'package:mascotify/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthSessionController> buildTestAuthController() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final preferences = await SharedPreferences.getInstance();
  final repository = LocalAuthRepository(preferences);
  final controller = AuthSessionController(repository: repository);
  await controller.initialize();
  return controller;
}

Widget buildTestApp(Widget child, {AuthSessionController? controller}) {
  final app = MaterialApp(theme: AppTheme.light(), home: child);

  if (controller == null) {
    return app;
  }

  return AuthScope(controller: controller, child: app);
}
