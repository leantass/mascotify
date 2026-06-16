import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MascotifyThemeMode {
  system,
  light,
  dark;

  String get label => switch (this) {
    MascotifyThemeMode.system => 'Usar sistema',
    MascotifyThemeMode.light => 'Modo claro',
    MascotifyThemeMode.dark => 'Modo oscuro',
  };

  String get storageValue => name;

  ThemeMode get materialThemeMode => switch (this) {
    MascotifyThemeMode.system => ThemeMode.system,
    MascotifyThemeMode.light => ThemeMode.light,
    MascotifyThemeMode.dark => ThemeMode.dark,
  };

  static MascotifyThemeMode fromStorage(String? value) {
    return MascotifyThemeMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => MascotifyThemeMode.system,
    );
  }

  static MascotifyThemeMode fromLabel(String label) {
    return MascotifyThemeMode.values.firstWhere(
      (mode) => mode.label == label,
      orElse: () => MascotifyThemeMode.system,
    );
  }
}

class AppThemeController extends ChangeNotifier {
  AppThemeController({required SharedPreferences preferences})
    : _preferences = preferences {
    _mode = MascotifyThemeMode.fromStorage(
      _preferences.getString(_preferenceKey),
    );
  }

  static const String _preferenceKey = 'mascotify.theme.mode.v1';

  final SharedPreferences _preferences;
  late MascotifyThemeMode _mode;

  MascotifyThemeMode get mode => _mode;

  ThemeMode get materialThemeMode => _mode.materialThemeMode;

  Future<void> setMode(MascotifyThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _preferences.setString(_preferenceKey, mode.storageValue);
    notifyListeners();
  }
}

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static AppThemeController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeScope>()
        ?.notifier;
  }
}
