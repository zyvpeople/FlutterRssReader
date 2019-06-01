class Feed {
  final int id;
  final String title;
  final Uri url;
  final Uri siteUrl;
  final Uri imageUrl;

  Feed(this.id, this.title, this.url, this.siteUrl, this.imageUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feed &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          url == other.url &&
          siteUrl == other.siteUrl &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'Feed{id: $id, title: $title, url: $url, siteUrl: $siteUrl, imageUrl: $imageUrl}';
  }

  Feed withId(int id) => Feed(id, title, url, siteUrl, imageUrl);
}
