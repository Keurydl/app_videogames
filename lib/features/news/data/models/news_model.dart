class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final String source;
  final String author;
  final String url;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      source: json['source']?['name'] ?? '',
      author: json['author'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
      'author': author,
      'url': url,
    };
  }
}
