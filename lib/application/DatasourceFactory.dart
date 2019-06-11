import 'package:flutter_rss_reader/datasource/local/FeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/local/SqfliteFeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:flutter_rss_reader/datasource/logger/LogWriter.dart';
import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedRemoteRepository.dart';
import 'package:flutter_rss_reader/datasource/remote/http_client/HttpClient.dart';
import 'package:flutter_rss_reader/datasource/remote/http_client/IoHttpClient.dart';
import 'package:flutter_rss_reader/datasource/remote/http_client/NativeHttpClient.dart';

class DatasourceFactory {
  Logger createLogger() => Logger(LogFormatter(), LogWriter());

  FeedRemoteRepository createFeedRemoteRepository() =>
      FeedRemoteRepository(_createHttpClient(), FeedParser());

  FeedLocalRepository createFeedLocalRepository() =>
      SqfliteFeedLocalRepository();

//  HttpClient _createHttpClient() => IoHttpClient();
  HttpClient _createHttpClient() => NativeHttpClient();
}
