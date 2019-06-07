import 'package:flutter/widgets.dart';

abstract class AppFactory {
  Widget create(String title, Widget home);
}
