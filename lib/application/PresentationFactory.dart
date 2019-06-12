import 'package:flutter_rss_reader/presentation/application/ApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

abstract class PresentationFactory {
  ApplicationFactory createApplicationFactory();

  PageFactory createPageFactory();

  RouteFactory createRouteFactory();

  ShareRouter createShareRouter();
}
