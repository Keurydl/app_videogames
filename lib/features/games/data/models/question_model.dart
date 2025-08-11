class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String category;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        text: json['text'],
        options: List<String>.from(json['options']),
        correctIndex: json['correctIndex'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'category': category,
      };
}
