class Article {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final DateTime? publishedAt;

  Article({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'],
      publishedAt: json['publishedAt'] != null ? DateTime.tryParse(json['publishedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}
