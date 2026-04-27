import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_session_controller.dart';
import '../features/auth/presentation/screens/account_onboarding_screen.dart';
import '../features/auth/presentation/screens/auth_placeholder_screen.dart';
import 'navigation/main_navigation_screen.dart';
import '../theme/app_theme.dart';

class MascotifyApp extends StatelessWidget {
  const MascotifyApp({super.key, required this.sessionController});

  final AuthSessionController sessionController;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: sessionController,
      child: MaterialApp(
        title: 'Mascotify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const _AppSessionGate(),
      ),
    );
  }
}

class _AppSessionGate extends StatelessWidget {
  const _AppSessionGate();

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    if (!auth.isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isAuthenticated) {
      return const AuthPlaceholderScreen();
    }

    final experience = auth.currentExperience;
    if (experience == null) {
      return const AuthPlaceholderScreen();
    }

    if (!auth.hasCompletedOnboarding) {
      return AccountOnboardingScreen(experience: experience);
    }

    // The navigation shell is keyed by experience so switching between family
    // and professional resets the tab stack instead of leaking stale state
    // across roles.
    return MainNavigationScreen(
      key: ValueKey<String>('nav-${experience.name}'),
      experience: experience,
    );
  }
}
