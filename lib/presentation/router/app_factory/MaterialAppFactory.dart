import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/router/app_factory/AppFactory.dart';

class MaterialAppFactory implements AppFactory {
  @override
  Widget create(String title, Widget home) =>
      MaterialApp(title: title, home: home);
}
