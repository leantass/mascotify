import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
    Locale('pt'),
  ];

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static Locale resolve(Locale? locale) {
    if (locale == null) return const Locale('es');
    final languageCode = locale.languageCode.toLowerCase();
    if (supportedLocales.any((item) => item.languageCode == languageCode)) {
      return Locale(languageCode);
    }
    return const Locale('es');
  }

  static String languageName(String? languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      default:
        return 'Automático según dispositivo';
    }
  }

  String get languageSettingTitle =>
      _text(es: 'Idioma', en: 'Language', pt: 'Idioma');

  String get automaticLanguage => _text(
    es: 'Automático según dispositivo',
    en: 'Automatic from device',
    pt: 'Automático pelo dispositivo',
  );

  String get languageSettingSubtitle => _text(
    es: 'Detecta el idioma del sistema o usa una preferencia manual.',
    en: 'Uses the system language or a manual preference.',
    pt: 'Detecta o idioma do sistema ou usa uma preferência manual.',
  );

  String get currentLanguageLabel =>
      _text(es: 'Idioma actual', en: 'Current language', pt: 'Idioma atual');

  String get unsupportedLocaleFallback => _text(
    es: 'Si el idioma del sistema no está traducido, Mascotify usa español.',
    en: 'If the system language is not translated, Mascotify uses Spanish.',
    pt: 'Se o idioma do sistema não estiver traduzido, Mascotify usa espanhol.',
  );

  String get languageUpdated => _text(
    es: 'Idioma actualizado.',
    en: 'Language updated.',
    pt: 'Idioma atualizado.',
  );

  String _text({required String es, required String en, required String pt}) {
    switch (locale.languageCode) {
      case 'en':
        return en;
      case 'pt':
        return pt;
      default:
        return es;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (item) => item.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      AppLocalizations(AppLocalizations.resolve(locale)),
    );
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
