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
import 'package:flutter_rss_reader/presentation/common/WidgetFactory.dart';
import 'package:flutter_rss_reader/presentation/router/PhoneRouter.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';
import 'package:flutter_rss_reader/presentation/router/bloc_factory/BlocFactory.dart';
import 'package:flutter_rss_reader/presentation/router/page_factory/PageFactory.dart';
import 'package:flutter_rss_reader/presentation/router/route_factory/RouteFactory.dart'
    as routeFactory;

//TODO: add i18n
//TODO: add tablet mode
//TODO: add cupertino pages

final _logger = Logger(LogFormatter(), LogWriter());
final _feedRemoteRepository = FeedRemoteRepository(HttpClient(), FeedParser());
final _feedLocalRepository = SqfliteFeedLocalRepository();
final _networkService = NetworkService();
final _feedService = FeedService(
    _feedRemoteRepository, _feedLocalRepository, _networkService, _logger);
final _routerBloc = RouterBloc();
final _routeFactory = routeFactory.RouteFactory();
final _blocFactory = BlocFactory(_feedService, _networkService, _routerBloc);
final _pageFactory = PageFactory(_blocFactory, WidgetFactory());

void main() => runApp(MaterialApp(
    title: "Rss reader",
    home: PhoneRouter(_routerBloc, _routeFactory, _pageFactory)));
