import 'package:flutter_rss_reader/application/DomainFactory.dart';
import 'package:flutter_rss_reader/application/PresentationFactory.dart';
import 'package:flutter_rss_reader/presentation/application/ApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/application/MaterialApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/MaterialPageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/MaterialRouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/share/FlutterShareRouter.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class MaterialPresentationFactory implements PresentationFactory {
  final RouterBloc _routerBloc;
  final _widgetFactory = MaterialWidgetFactory();
  final BlocFactory _blocFactory;

  MaterialPresentationFactory(this._routerBloc, DomainFactory domainFactory)
      : _blocFactory = BlocFactory(domainFactory.createFeedService(),
            domainFactory.networkService, _routerBloc);

  @override
  ApplicationFactory createApplicationFactory() => MaterialApplicationFactory();

  @override
  PageFactory createPageFactory() =>
      MaterialPageFactory(_blocFactory, _widgetFactory, _routerBloc);

  @override
  RouteFactory createRouteFactory() => MaterialRouteFactory();

  @override
  ShareRouter createShareRouter() => FlutterShareRouter();
}
