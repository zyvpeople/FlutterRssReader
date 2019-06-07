import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/datasource/local/SqfliteFeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:flutter_rss_reader/datasource/logger/LogWriter.dart';
import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedRemoteRepository.dart';
import 'package:flutter_rss_reader/datasource/remote/HttpClient.dart';
import 'package:flutter_rss_reader/domain/service/FeedService.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';
import 'package:flutter_rss_reader/presentation/cupertino/CupertinoWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/material/MaterialWidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/PhoneRouter.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/CupertinoPageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/MaterialPageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/CupertinoRouteFactory.dart'
    as cupertinoRouteFactory;
import 'package:flutter_rss_reader/presentation/router/route_factory/MaterialRouteFactory.dart'
    as materialRouteFactory;

//TODO: add i18n
//TODO: add tablet mode

final _logger = Logger(LogFormatter(), LogWriter());
final _feedRemoteRepository = FeedRemoteRepository(HttpClient(), FeedParser());
final _feedLocalRepository = SqfliteFeedLocalRepository();
final _networkService = NetworkService();
final _feedService = FeedService(
    _feedRemoteRepository, _feedLocalRepository, _networkService, _logger);
final _routerBloc = RouterBloc();
//final _routeFactory = materialRouteFactory.MaterialRouteFactory();
final _routeFactory = cupertinoRouteFactory.CupertinoRouteFactory();
final _blocFactory = BlocFactory(_feedService, _networkService, _routerBloc);
//final _pageFactory = PageFactory(_blocFactory, WidgetFactory());
final _pageFactory =
    CupertinoPageFactory(_blocFactory, CupertinoWidgetFactory());
//final _appFactory = MaterialAppFactory();

void main() => runApp(_pageFactory.createApp(
    "Rss reader", PhoneRouter(_routerBloc, _routeFactory, _pageFactory)));
