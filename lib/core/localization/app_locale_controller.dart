import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController({required SharedPreferences preferences})
    : _preferences = preferences {
    final storedCode = _preferences.getString(_preferenceKey);
    if (_isSupportedCode(storedCode)) {
      _manualLocale = Locale(storedCode!);
    }
  }

  static const String _preferenceKey = 'mascotify.locale.manual-code.v1';

  final SharedPreferences _preferences;
  Locale? _manualLocale;

  Locale? get manualLocale => _manualLocale;

  Locale? get materialLocale => _manualLocale;

  String? get manualLanguageCode => _manualLocale?.languageCode;

  String labelFor(Locale? systemLocale) {
    if (_manualLocale != null) {
      return AppLocalizations.languageName(_manualLocale!.languageCode);
    }
    final resolved = AppLocalizations.resolve(systemLocale);
    return '${AppLocalizations.languageName(resolved.languageCode)} (automático)';
  }

  Future<void> setManualLanguageCode(String? languageCode) async {
    if (languageCode == null || languageCode == 'auto') {
      _manualLocale = null;
      await _preferences.remove(_preferenceKey);
      notifyListeners();
      return;
    }

    if (!_isSupportedCode(languageCode)) {
      return;
    }

    _manualLocale = Locale(languageCode);
    await _preferences.setString(_preferenceKey, languageCode);
    notifyListeners();
  }

  static bool _isSupportedCode(String? languageCode) {
    if (languageCode == null) return false;
    return AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }
}

class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    super.key,
    required AppLocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope is missing from the widget tree.');
    return scope!.notifier!;
  }

  static AppLocaleController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLocaleScope>()
        ?.notifier;
  }
}
