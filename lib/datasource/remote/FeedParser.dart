import 'package:flutter_rss_reader/domain/common/Tuple2.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';

class FeedParser {
  Future<Tuple2<Feed, List<FeedItem>>> parse(Uri feedUrl, String data) async {
    final document = xml.parse(data);
    final channelElement = document.findAllElements("channel").first;
    final feed = _parseFeed(feedUrl, channelElement);
    final feedItems = _parseFeedItems(channelElement).toList();
    return Tuple2(feed, feedItems);
  }

  Feed _parseFeed(Uri feedUrl, xml.XmlElement channelElement) => Feed(
      0,
      channelElement
          .findAllElements("title")
          .firstWhere((it) => it.parent == channelElement)
          .text,
      feedUrl);

  List<FeedItem> _parseFeedItems(xml.XmlElement channelElement) =>
      channelElement
          .findAllElements("item")
          .where((it) => it.parent == channelElement)
          .map(_parseFeedItem)
          .toList();

  FeedItem _parseFeedItem(xml.XmlElement itemElement) => FeedItem(
      0,
      itemElement.findAllElements("guid").first.text,
      itemElement.findAllElements("title").first.text,
      itemElement.findAllElements("description").first.text,
      DateFormat("EEE, dd MMM yyyy hh:mm:ss zzz")
          .parse(itemElement.findAllElements("pubDate").first.text),
      Uri.parse(itemElement.findAllElements("link").first.text),
      Uri.parse(itemElement
          .findAllElements("media:thumbnail")
          .first
          .getAttribute("url")),
      0);
}
