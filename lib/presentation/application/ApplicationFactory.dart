import 'package:flutter/widgets.dart';

abstract class ApplicationFactory {
  Widget create(String title, Widget home);
}
