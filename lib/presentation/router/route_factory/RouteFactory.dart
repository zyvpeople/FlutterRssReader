import 'package:flutter/material.dart';

class RouteFactory {
  Route create(Widget pageBuilder()) =>
      MaterialPageRoute(builder: (_) => pageBuilder());
}
