import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/datasource/local/FeedLocalRepository.dart';
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
import 'package:flutter_rss_reader/presentation/router/Router.dart';
import 'package:flutter_rss_reader/presentation/router/RouterBloc.dart';

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

void main() => runApp(MaterialApp(
    title: "Rss reader",
    home: Router(_routerBloc, _feedService, _networkService, WidgetFactory())));
