import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';

class FeedLocalRepository {
  Stream get feedsChanged => null;

  Stream get feedItemsChanged => null;

  Future createOrUpdateFeed(Feed feed) async {}

  Future removeFeed(String id) async {}

  Future<List<Feed>> feeds() async {}

  Future<Feed> findFeed(String id) async {}

  Future createOrUpdateFeedItems(List<FeedItem> feedItems) async {}

  Future<List<FeedItem>> feedItems(String feedId) async {}

  Future<FeedItem> findFeedItem(String id) async {}
}
