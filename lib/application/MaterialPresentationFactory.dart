import 'package:flutter_rss_reader/application/DomainFactory.dart';
import 'package:flutter_rss_reader/application/PresentationFactory.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/application_factory/ApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/application_factory/MaterialApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/MaterialPageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/MaterialRouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/share/FlutterShareRouter.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class MaterialPresentationFactory implements PresentationFactory {
  final _widgetFactory = MaterialWidgetFactory();
  final BlocFactory _blocFactory;

  MaterialPresentationFactory(
      RouterBloc routerBloc, DomainFactory domainFactory)
      : _blocFactory = BlocFactory(domainFactory.createFeedService(),
            domainFactory.networkService, routerBloc);

  @override
  ApplicationFactory createApplicationFactory() => MaterialApplicationFactory();

  @override
  PageFactory createPageFactory() =>
      MaterialPageFactory(_blocFactory, _widgetFactory);

  @override
  RouteFactory createRouteFactory() => MaterialRouteFactory();

  @override
  ShareRouter createShareRouter() => FlutterShareRouter();
}
