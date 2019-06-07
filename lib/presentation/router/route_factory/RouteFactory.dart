import 'package:flutter/widgets.dart';

abstract class RouteFactory {
  Route create(Widget pageBuilder());
}
