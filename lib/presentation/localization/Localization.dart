import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/localization/Strings.dart';
import 'package:flutter_rss_reader/presentation/localization/StringsFactory.dart';

class Localization {
  static Map<Locale, Strings> _strings = {
    Locale('en'): StringsFactory.en,
    Locale('uk'): StringsFactory.uk
  };

  static List<Locale> get supportedLocales => _strings.keys.toList();

  final Locale _locale;

  Localization(this._locale);

  static Strings of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization)._findStrings();

  Strings _findStrings() => _strings[_locale];
}
