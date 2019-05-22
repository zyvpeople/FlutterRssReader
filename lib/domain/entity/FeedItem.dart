class FeedItem {
  final String id;
  final String title;
  final String summary;
  final DateTime dateTime;
  final Uri url;
  final Uri imageUrl;
  final String feedId;

  FeedItem(this.id, this.title, this.summary, this.dateTime, this.url,
      this.imageUrl, this.feedId);
}
