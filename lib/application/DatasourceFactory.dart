import 'package:flutter_rss_reader/datasource/local/FeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/local/SqfliteFeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/logger/LogFormatter.dart';
import 'package:flutter_rss_reader/datasource/logger/LogWriter.dart';
import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedRemoteRepository.dart';
import 'package:flutter_rss_reader/datasource/remote/HttpClient.dart';

class DatasourceFactory {
  Logger createLogger() => Logger(LogFormatter(), LogWriter());

  FeedRemoteRepository createFeedRemoteRepository() =>
      FeedRemoteRepository(HttpClient(), FeedParser());

  FeedLocalRepository createFeedLocalRepository() =>
      SqfliteFeedLocalRepository();
}
