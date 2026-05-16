import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/presentation/auth_session_controller.dart';
import '../features/auth/presentation/screens/account_onboarding_screen.dart';
import '../features/auth/presentation/screens/auth_placeholder_screen.dart';
import 'localization/app_locale_controller.dart';
import 'localization/app_localizations.dart';
import 'navigation/main_navigation_screen.dart';
import '../theme/app_theme.dart';

class MascotifyApp extends StatefulWidget {
  const MascotifyApp({
    super.key,
    required this.sessionController,
    this.localeController,
  });

  final AuthSessionController sessionController;
  final AppLocaleController? localeController;

  @override
  State<MascotifyApp> createState() => _MascotifyAppState();
}

class _MascotifyAppState extends State<MascotifyApp> {
  AppLocaleController? _ownedLocaleController;
  Future<AppLocaleController>? _localeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.localeController == null) {
      _localeControllerFuture = SharedPreferences.getInstance().then((
        preferences,
      ) {
        _ownedLocaleController = AppLocaleController(preferences: preferences);
        return _ownedLocaleController!;
      });
    }
  }

  @override
  void dispose() {
    _ownedLocaleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providedController = widget.localeController;
    if (providedController != null) {
      return _LocalizedMascotifyApp(
        sessionController: widget.sessionController,
        localeController: providedController,
      );
    }

    return FutureBuilder<AppLocaleController>(
      future: _localeControllerFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return _LocalizedMascotifyApp(
          sessionController: widget.sessionController,
          localeController: snapshot.data!,
        );
      },
    );
  }
}

class _LocalizedMascotifyApp extends StatelessWidget {
  const _LocalizedMascotifyApp({
    required this.sessionController,
    required this.localeController,
  });

  final AuthSessionController sessionController;
  final AppLocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      controller: localeController,
      child: AuthScope(
        controller: sessionController,
        child: AnimatedBuilder(
          animation: localeController,
          builder: (context, _) {
            return MaterialApp(
              title: 'Mascotify',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              locale: localeController.materialLocale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                return AppLocalizations.resolve(locale);
              },
              home: const _AppSessionGate(),
            );
          },
        ),
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
