import 'package:flutter/material.dart';
import 'RouteFactory.dart' as routeFactory;

class MaterialRouteFactory implements routeFactory.RouteFactory {
  @override
  Route create(Widget pageBuilder()) =>
      MaterialPageRoute(builder: (_) => pageBuilder());
}
