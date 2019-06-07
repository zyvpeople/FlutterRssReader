import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/presentation/router/application_factory/ApplicationFactory.dart';

class CupertinoApplicationFactory implements ApplicationFactory {
  @override
  Widget create(String title, Widget home) =>
      CupertinoApp(title: title, home: home);
}
