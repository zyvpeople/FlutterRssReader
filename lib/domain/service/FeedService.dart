import 'dart:async';

import 'package:flutter_rss_reader/datasource/local/FeedLocalRepository.dart';
import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedRemoteRepository.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:flutter_rss_reader/domain/service/NetworkService.dart';

//TODO: add tests
class FeedService {
  final FeedRemoteRepository _feedRemoteRepository;
  final FeedLocalRepository _feedLocalRepository;
  final NetworkService _networkService;
  final Logger _logger;
  final _syncStatusChanged = StreamController.broadcast();
  final StreamController<Object> _syncException = StreamController.broadcast();
  var _isSync = false;
  final _subscriptions = <StreamSubscription>[];

  Stream get feedsChanged => _feedLocalRepository.feedsChanged;

  Stream get feedItemsChanged => _feedLocalRepository.feedItemsChanged;

  Stream get syncStatusChanged => _syncStatusChanged.stream;

  Stream<Object> get syncException => _syncException.stream;

  bool get isSync => _isSync;

  FeedService._(this._feedRemoteRepository, this._feedLocalRepository,
      this._networkService, this._logger);

  factory FeedService(
      FeedRemoteRepository feedRemoteRepository,
      FeedLocalRepository feedLocalRepository,
      NetworkService networkService,
      Logger logger) {
    final service = FeedService._(
        feedRemoteRepository, feedLocalRepository, networkService, logger);
    service._init();
    return service;
  }

  void _init() {
    _subscriptions.add(_networkService.onlineStatusChanged.listen((_) => {
          if (_networkService.isOnline) {syncAll()}
        }));
  }

  void release() {
    _subscriptions.forEach((it) => it.cancel());
    _syncStatusChanged.close();
    _syncException.close();
  }

  void syncAll() {
    if (!_canSync()) {
      return;
    }
    _setIsSyncAndNotify(true);
    _feedLocalRepository
        .feeds(null)
        .then((feeds) => Future.wait(feeds.map(_loadFeedItems)))
        .then((it) => it.expand((feedItems) => feedItems).toList())
        .then((it) => _feedLocalRepository.createOrUpdateFeedItems(it))
        .then(_onSuccessSyncAll)
        .catchError(_onErrorSyncAll);
  }

  Future _onSuccessSyncAll(event) async {
    _logger.d(this, "Success syncAll");
    _setIsSyncAndNotify(false);
  }

  void _onErrorSyncAll(Object error) async {
    _logger.e(this, "Error syncAll", error);
    _setIsSyncAndNotify(false);
    _syncException.sink.add(error);
  }

  void syncFeed(int id) {
    if (!_canSync()) {
      return;
    }
    _setIsSyncAndNotify(true);
    _feedLocalRepository
        .findFeed(id)
        .then((feed) async {
          if (feed == null) {
            return null;
          }
          final feedItems = await _loadFeedItems(feed);
          await _feedLocalRepository.createOrUpdateFeedItems(feedItems);
        })
        .then(_onSuccessSyncFeed)
        .catchError(_onErrorSyncFeed);
  }

  Future<List<FeedItem>> _loadFeedItems(Feed feed) async {
    final feedAndFeedItems = await _feedRemoteRepository.feed(feed.url);
    final feedItems =
        feedAndFeedItems.value2.map((it) => it.withFeedId(feed.id)).toList();
    return feedItems;
  }

  Future _onSuccessSyncFeed(event) async {
    _logger.d(this, "Success syncFeed");
    _setIsSyncAndNotify(false);
  }

  void _onErrorSyncFeed(Object error) {
    _logger.e(this, "Error syncFeed", error);
    _setIsSyncAndNotify(false);
    _syncException.add(error);
  }

  Future createFeed(Uri feedUrl) async {
    try {
      final feedAndFeedItems = await _feedRemoteRepository.feed(feedUrl);
      return await _feedLocalRepository
          .createOrUpdateFeed(feedAndFeedItems.value1);
    } catch (e) {
      _logger.e(this, "Error createFeed", e);
      throw e;
    }
  }

  Future<Feed> findFeed(int id) => _feedLocalRepository.findFeed(id);

  Future deleteFeed(int id) => _feedLocalRepository.deleteFeed(id);

  Future<List<Feed>> feeds(String searchTextOrNull) =>
      _feedLocalRepository.feeds(searchTextOrNull);

  Future<List<FeedItem>> feedItems(int feedId, String searchTextOrNull) =>
      _feedLocalRepository.feedItems(feedId, searchTextOrNull);

  Future<FeedItem> findFeedItem(int id) =>
      _feedLocalRepository.findFeedItem(id);

  void _setIsSyncAndNotify(bool isSync) {
    _isSync = isSync;
    _syncStatusChanged.sink.add(null);
    _logger.d(this, "_setIsSyncAndNotify. IsSync: $_isSync");
  }

  bool _canSync() => !_isSync && _networkService.isOnline;
}
