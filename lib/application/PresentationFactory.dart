import 'package:flutter_rss_reader/presentation/router/application_factory/ApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart';

abstract class PresentationFactory {
  ApplicationFactory createApplicationFactory();

  PageFactory createPageFactory();

  RouteFactory createRouteFactory();
}
