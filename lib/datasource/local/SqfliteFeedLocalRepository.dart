import 'dart:async';

import 'package:flutter_rss_reader/datasource/local/FeedLocalRepository.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteFeedLocalRepository implements FeedLocalRepository {
  final Completer<Database> _databaseCompleter = Completer();

  Future<Database> get _database => _databaseCompleter.future;
  final _feedsChanged = StreamController.broadcast();
  final _feedItemsChanged = StreamController.broadcast();

  @override
  Stream get feedsChanged => _feedsChanged.stream;

  @override
  Stream get feedItemsChanged => _feedItemsChanged.stream;

  SqfliteFeedLocalRepository._();

  factory SqfliteFeedLocalRepository() {
    final repository = SqfliteFeedLocalRepository._();
    repository._init();
    return repository;
  }

  void _init() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, "feeds.db");
      final database = await openDatabase(path, version: 1,
          onCreate: (database, version) async {
        await database.execute("""CREATE TABLE IF NOT EXISTS Feeds (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                url TEXT NOT NULL UNIQUE,
                siteUrl TEXT NOT NULL,
                imageUrl TEXT NOT NULL)""");
      });
      await database.execute("""CREATE TABLE IF NOT EXISTS FeedItems (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    sid TEXT NOT NULL UNIQUE,
                    title TEXT NOT NULL,
                    summary TEXT NOT NULL,
                    dateTime INTEGER,
                    url TEXT NOT NULL,
                    imageUrl TEXT NOT NULL,
                    feedId INTEGER,
                    CONSTRAINT fk_feeds
                      FOREIGN KEY (feedId)
                      REFERENCES Feeds(id)
                      ON DELETE CASCADE)""");
      _databaseCompleter.complete(database);
    } catch (e) {
      _databaseCompleter.completeError(e);
      //TODO: log
    }
  }

  @override
  void release() {
    _database.then((it) => it.close());
    _feedsChanged.close();
    _feedItemsChanged.close();
  }

  @override
  Future createOrUpdateFeed(Feed feed) async {
    final database = await _database;
    await database
        .rawInsert("""INSERT OR REPLACE INTO Feeds (title,url,siteUrl,imageUrl)
        VALUES (?,?,?,?)""", [
      feed.title,
      feed.url.toString(),
      feed.siteUrl.toString(),
      feed.imageUrl.toString()
    ]);
    _feedsChanged.sink.add(null);
  }

  @override
  Future deleteFeed(int id) async {
    final database = await _database;
    await database.rawDelete("DELETE FROM Feeds WHERE id = ?", [id]);
    _feedsChanged.sink.add(null);
  }

  @override
  Future<List<Feed>> feeds(String searchTextOrNull) async {
    final database = await _database;
    final select = "SELECT id, title, url, siteUrl, imageUrl FROM Feeds ";
    final where = searchTextOrNull == null
        ? ""
        : "WHERE title LIKE '%${searchTextOrNull ?? ""}%' ";
    final orderBy = "ORDER BY title ASC";
    final rows = await database.rawQuery(select + where + orderBy);
    return rows.map(_rowToFeed).toList();
  }

  @override
  Future<Feed> findFeed(int id) async {
    final database = await _database;
    final rows = await database.rawQuery(
        "SELECT id, title, url, siteUrl, imageUrl FROM Feeds WHERE id = ? LIMIT 1",
        [id]);
    return rows.map(_rowToFeed).firstWhere((it) => true, orElse: () => null);
  }

  Feed _rowToFeed(Map<String, dynamic> row) => Feed(
      row["id"],
      row["title"],
      Uri.parse(row["url"]),
      Uri.parse(row["siteUrl"]),
      Uri.parse(row["imageUrl"]));

  @override
  Future createOrUpdateFeedItems(List<FeedItem> feedItems) =>
      _database.then((it) {
        it.transaction((tx) {
          feedItems.forEach(
              (feedItem) => tx.rawInsert("""INSERT OR REPLACE INTO FeedItems (
                            sid, title, summary, dateTime, url, imageUrl, feedId)
                            VALUES (?,?,?,?,?,?,?)""", [
                    feedItem.sid,
                    feedItem.title,
                    feedItem.summary,
                    feedItem.dateTime.millisecondsSinceEpoch,
                    feedItem.url.toString(),
                    feedItem.imageUrl.toString(),
                    feedItem.feedId
                  ]));
        });
        _feedItemsChanged.sink.add(null);
      });

  @override
  Future<List<FeedItem>> feedItems(int feedId, String searchTextOrNull) async {
    final database = await _database;
    final select =
        "SELECT id, sid, title, summary, dateTime, url, imageUrl, feedId FROM FeedItems ";
    final whereFeedId = "WHERE feedId = $feedId ";
    final whereSearchText =
        searchTextOrNull == null ? "" : "AND title LIKE '%$searchTextOrNull%' ";
    final where = whereFeedId + whereSearchText;
    final orderBy = "ORDER BY dateTime DESC";
    final rows = await database.rawQuery(select + where + orderBy);
    return rows.map(_rowToFeedItem).toList();
  }

  @override
  Future<FeedItem> findFeedItem(int id) async {
    final database = await _database;
    final rows = await database.rawQuery(
        """SELECT id, sid, title, summary, dateTime, url, imageUrl, feedId
        FROM FeedItems WHERE id = ? LIMIT 1""", [id]);
    return rows
        .map(_rowToFeedItem)
        .firstWhere((it) => true, orElse: () => null);
  }

  FeedItem _rowToFeedItem(Map<String, dynamic> row) => FeedItem(
      row["id"],
      row["sid"],
      row["title"],
      row["summary"],
      DateTime.fromMicrosecondsSinceEpoch(row["dateTime"]),
      Uri.parse(row["url"]),
      Uri.parse(row["imageUrl"]),
      row["feedId"]);
}
