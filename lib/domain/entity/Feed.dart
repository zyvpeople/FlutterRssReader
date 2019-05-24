class Feed {
  final int id;
  final String title;
  final Uri url;

  Feed(this.id, this.title, this.url);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Feed &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              url == other.url;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      url.hashCode;

  @override
  String toString() {
    return 'Feed{id: $id, title: $title, url: $url}';
  }
}
