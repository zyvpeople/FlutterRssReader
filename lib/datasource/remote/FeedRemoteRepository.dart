import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/datasource/remote/HttpClient.dart';
import 'package:flutter_rss_reader/domain/common/Tuple2.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';

class FeedRemoteRepository {
  final HttpClient _httpClient;
  final FeedParser _feedParser;

  FeedRemoteRepository(this._httpClient, this._feedParser);

  Future<Tuple2<Feed, List<FeedItem>>> feed(Uri feedUrl) => _httpClient
      .get(feedUrl, _headers())
      .then((data) => _feedParser.parse(feedUrl, data));

  Map<String, Object> _headers() {
    return {'Content-Type': 'application/xml'};
  }
}
