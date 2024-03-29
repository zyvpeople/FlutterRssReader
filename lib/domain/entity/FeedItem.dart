class FeedItem {
  final int id;
  final String sid;
  final String title;
  final String summary;
  final DateTime dateTime;
  final Uri url;
  final Uri imageUrl;
  final int feedId;

  FeedItem(this.id, this.sid, this.title, this.summary, this.dateTime, this.url,
      this.imageUrl, this.feedId);

  FeedItem withId(int id) =>
      FeedItem(id, sid, title, summary, dateTime, url, imageUrl, feedId);

  FeedItem withFeedId(int feedId) =>
      FeedItem(id, sid, title, summary, dateTime, url, imageUrl, feedId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sid == other.sid &&
          title == other.title &&
          summary == other.summary &&
          dateTime == other.dateTime &&
          url == other.url &&
          imageUrl == other.imageUrl &&
          feedId == other.feedId;

  @override
  int get hashCode =>
      id.hashCode ^
      sid.hashCode ^
      title.hashCode ^
      summary.hashCode ^
      dateTime.hashCode ^
      url.hashCode ^
      imageUrl.hashCode ^
      feedId.hashCode;

  @override
  String toString() {
    return 'FeedItem{id: $id, sid: $sid, title: $title, summary: $summary, dateTime: $dateTime, url: $url, imageUrl: $imageUrl, feedId: $feedId}';
  }
}
