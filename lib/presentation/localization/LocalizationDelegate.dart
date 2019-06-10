import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      Localization.supportedLocales.contains(locale);

  @override
  Future<Localization> load(Locale locale) =>
      SynchronousFuture<Localization>(Localization(locale));

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
