import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rss_reader/presentation/localization/Localization.dart';
import 'package:flutter_rss_reader/presentation/localization/LocalizationDelegate.dart';
import 'package:flutter_rss_reader/presentation/router/application_factory/ApplicationFactory.dart';

class MaterialApplicationFactory implements ApplicationFactory {
  @override
  Widget create(String title, Widget home) => MaterialApp(
      title: title,
      home: home,
      localizationsDelegates: [
        LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localization.supportedLocales);
}
