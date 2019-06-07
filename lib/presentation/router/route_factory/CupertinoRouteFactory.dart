import 'package:flutter/cupertino.dart';

import 'RouteFactory.dart' as routeFactory;

class CupertinoRouteFactory implements routeFactory.RouteFactory {
  @override
  Route create(Widget pageBuilder()) =>
      CupertinoPageRoute(builder: (_) => pageBuilder());
}
