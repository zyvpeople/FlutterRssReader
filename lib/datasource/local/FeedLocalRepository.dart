import 'dart:async';

import 'package:flutter_rss_reader/datasource/logger/Logger.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';

//TODO: add tests
class FeedLocalRepository {
  final Logger _logger;
  var _feedIdCounter = 0;
  var _feedItemIdCounter = 0;
  final _feeds = <Feed>[];
  final _feedItems = <FeedItem>[];
  final _feedsChanged = StreamController.broadcast();
  final _feedItemsChanged = StreamController.broadcast();

  FeedLocalRepository(this._logger);

  Stream get feedsChanged => _feedsChanged.stream;

  Stream get feedItemsChanged => _feedItemsChanged.stream;

  void release() {
    _feedsChanged.close();
    _feedItemsChanged.close();
  }

  Future createOrUpdateFeed(Feed feed) async {
    final logSuccessAndNotify = () {
      _logger.d(this, "Success createOrUpdateFeed");
      _feedsChanged.sink.add(null);
    };
    final logErrorAndThrow = (String message) {
      final exception = Exception(message);
      _logger.e(this, "Error createOrUpdateFeed", exception);
      throw exception;
    };
    final insertNewFeed = (Feed feed) {
      _feedIdCounter++;
      _feeds.add(feed.withId(_feedIdCounter));
      logSuccessAndNotify();
    };
    final updateFeedAtIndex = (Feed feed, int index) {
      _feeds.removeAt(index);
      _feeds.insert(index, feed);
      logSuccessAndNotify();
    };
    if (feed.id == 0) {
      final index = _feeds.indexWhere((it) => it.url == feed.url);
      if (index == -1) {
        insertNewFeed(feed);
      } else {
        final existedFeed = _feeds[index];
        updateFeedAtIndex(feed.withId(existedFeed.id), index);
      }
    } else {
      final feedWithIdIndex = _feeds.indexWhere((it) => it.id == feed.id);
      final feedWithUrlIndex = _feeds.indexWhere((it) => it.url == feed.url);
      if (feedWithIdIndex == -1) {
        logErrorAndThrow("Id should be 0");
      } else if (feedWithUrlIndex == -1) {
        updateFeedAtIndex(feed, feedWithIdIndex);
      } else {
        if (feedWithIdIndex == feedWithUrlIndex) {
          updateFeedAtIndex(feed, feedWithIdIndex);
        } else {
          logErrorAndThrow("Constraints violation");
        }
      }
    }
  }

  Future removeFeed(int id) async {
    _feeds.removeWhere((it) => it.id == id);
    _feedItems.removeWhere((it) => it.feedId == id);
    _logger.d(this, "Success removeFeed");
    _feedsChanged.sink.add(null);
    _feedItemsChanged.sink.add(null);
  }

  Future<List<Feed>> feeds() async {
    final copy = _feeds.toList();
    copy.sort((first, second) => first.title.compareTo(second.title));
    return copy;
  }

  Future<Feed> findFeed(int id) async =>
      _feeds.firstWhere((it) => it.id == id, orElse: () => null);

  Future createOrUpdateFeedItems(List<FeedItem> feedItems) async =>
      Future.wait(feedItems.map(_createOrUpdateFeedItem));

  Future _createOrUpdateFeedItem(FeedItem feedItem) async {
    final logSuccessAndNotify = () {
      _logger.d(this, "Success _createOrUpdateFeedItem");
      _feedItemsChanged.sink.add(null);
    };
    final logErrorAndThrow = (String message) {
      final exception = Exception(message);
      _logger.e(this, "Error _createOrUpdateFeedItem", exception);
      throw exception;
    };
    final insertNewFeedItem = (FeedItem feedItem) {
      _feedItemIdCounter++;
      _feedItems.add(feedItem.withId(_feedItemIdCounter));
      logSuccessAndNotify();
    };
    final updateFeedItemAtIndex = (FeedItem feedItem, int index) {
      _feedItems.removeAt(index);
      _feedItems.insert(index, feedItem);
      logSuccessAndNotify();
    };
    if (feedItem.id == 0) {
      final index = _feedItems.indexWhere((it) => it.sid == feedItem.sid);
      if (index == -1) {
        insertNewFeedItem(feedItem);
      } else {
        final existedFeedItem = _feedItems[index];
        updateFeedItemAtIndex(feedItem.withId(existedFeedItem.id), index);
      }
    } else {
      final feedItemWithIdIndex =
          _feedItems.indexWhere((it) => it.id == feedItem.id);
      final feedItemWithSidIndex =
          _feedItems.indexWhere((it) => it.sid == feedItem.sid);
      if (feedItemWithIdIndex == -1) {
        logErrorAndThrow("Id should be 0");
      } else if (feedItemWithSidIndex == -1) {
        updateFeedItemAtIndex(feedItem, feedItemWithIdIndex);
      } else {
        if (feedItemWithIdIndex == feedItemWithSidIndex) {
          updateFeedItemAtIndex(feedItem, feedItemWithIdIndex);
        } else {
          logErrorAndThrow("Constraints violation");
        }
      }
    }
  }

  Future<List<FeedItem>> feedItems(int feedId) async {
    final items = _feedItems.where((it) => it.feedId == feedId).toList();
    items.sort((first, second) => first.dateTime.compareTo(second.dateTime));
    return items;
  }

  Future<FeedItem> findFeedItem(int id) async =>
      _feedItems.firstWhere((it) => it.id == id, orElse: () => null);
}
