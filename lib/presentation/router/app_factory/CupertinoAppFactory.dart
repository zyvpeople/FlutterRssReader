import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/router/app_factory/AppFactory.dart';

class CupertinoAppFactory implements AppFactory {
  @override
  Widget create(String title, Widget home) =>
      CupertinoApp(title: title, home: home);
}
