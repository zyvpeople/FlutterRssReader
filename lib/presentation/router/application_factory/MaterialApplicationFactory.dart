import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/presentation/router/application_factory/ApplicationFactory.dart';

class MaterialApplicationFactory implements ApplicationFactory {
  @override
  Widget create(String title, Widget home) =>
      MaterialApp(title: title, home: home);
}
