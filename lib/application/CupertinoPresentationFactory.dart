import 'package:flutter_rss_reader/application/DomainFactory.dart';
import 'package:flutter_rss_reader/application/PresentationFactory.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/application/ApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/application/CupertinoApplicationFactory.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/CupertinoPageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/CupertinoRouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart';
import 'package:flutter_rss_reader/presentation/router/share/FlutterShareRouter.dart';
import 'package:flutter_rss_reader/presentation/router/share/NativeShareRouter.dart';
import 'package:flutter_rss_reader/presentation/router/share/ShareRouter.dart';

class CupertinoPresentationFactory implements PresentationFactory {
  final _widgetFactory = CupertinoWidgetFactory();
  final BlocFactory _blocFactory;

  CupertinoPresentationFactory(
      RouterBloc routerBloc, DomainFactory domainFactory)
      : _blocFactory = BlocFactory(domainFactory.createFeedService(),
            domainFactory.networkService, routerBloc);

  @override
  ApplicationFactory createApplicationFactory() =>
      CupertinoApplicationFactory();

  @override
  PageFactory createPageFactory() =>
      CupertinoPageFactory(_blocFactory, _widgetFactory);

  @override
  RouteFactory createRouteFactory() => CupertinoRouteFactory();

  @override
  ShareRouter createShareRouter() => NativeShareRouter();
}
