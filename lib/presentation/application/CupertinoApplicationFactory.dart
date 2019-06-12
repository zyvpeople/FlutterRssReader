import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/localization/LocalizationDelegate.dart';
import 'package:flutter_rss_reader/presentation/application/ApplicationFactory.dart';

class CupertinoApplicationFactory implements ApplicationFactory {
  @override
  Widget create(String title, Widget home) => CupertinoApp(
      title: title,
      home: home,
      localizationsDelegates: [
        LocalizationDelegate(),
        FallbackCupertinoLocalisationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localization.supportedLocales);
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
