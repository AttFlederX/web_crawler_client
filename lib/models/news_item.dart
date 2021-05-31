class NewsItem {
  final String id;

  final String title;
  final String shortContent;
  final String category;
  final String url;
  final String source;

  final DateTime added;

  NewsItem({
    this.id,
    this.title,
    this.shortContent,
    this.category,
    this.url,
    this.source,
    this.added,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      shortContent: json['shortContent'],
      category: json['category'],
      url: json['url'],
      source: json['source'],
      added: DateTime.parse(json['added']),
    );
  }
}
