import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/localization/app_localizations.dart';

void main() {
  test('unsupported locales fall back to Spanish', () {
    expect(AppLocalizations.resolve(const Locale('fr')).languageCode, 'es');
    expect(AppLocalizations.resolve(const Locale('de')).languageCode, 'es');
  });

  test('supported locales resolve by language code', () {
    expect(
      AppLocalizations.resolve(const Locale('en', 'US')).languageCode,
      'en',
    );
    expect(
      AppLocalizations.resolve(const Locale('pt', 'BR')).languageCode,
      'pt',
    );
  });
}
