import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/datasource/remote/FeedRemoteRepository.dart';
import 'package:flutter_rss_reader/datasource/remote/HttpClient.dart';
import 'package:flutter_rss_reader/domain/common/Tuple2.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  final client = _MockHttpClient();
  final parser = _MockFeedParser();
  final repository = FeedRemoteRepository(client, parser);
  final feedUri = Uri.parse("http://test.com");
  final headers = {'Content-Type': 'application/xml'};
  final data = "data";
  final result = _MockTuple2<Feed, List<FeedItem>>();
  final exception = Exception();

  test("feed returns feed and feedItems", () async {
    when(client.get(feedUri, headers)).thenAnswer((_) async => data);
    when(parser.parse(feedUri, data)).thenAnswer((_) async => result);

    final actual = await repository.feed(feedUri);

    expect(actual, result);
  });

  test("feed throws error if cant load feed", () async {
    try {
      when(client.get(feedUri, headers)).thenThrow(exception);

      await repository.feed(feedUri);
      fail("Exception is expected");
    } catch (e) {}
  });

  test("feed throws error if cant parse feed", () async {
    try {
      when(client.get(feedUri, headers)).thenAnswer((_) async => data);
      when(parser.parse(feedUri, data)).thenThrow(exception);

      await repository.feed(feedUri);
      fail("Exception is expected");
    } catch (e) {}
  });
}

class _MockHttpClient extends Mock implements HttpClient {}

class _MockFeedParser extends Mock implements FeedParser {}

class _MockTuple2<A, B> extends Mock implements Tuple2<A, B> {}
