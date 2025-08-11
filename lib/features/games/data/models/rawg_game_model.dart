class RawgGame {
  final int id;
  final String name;
  final String backgroundImage;
  final String released;
  final double rating;
  final List<String> genres;
  final String description;
  final List<String> platforms;
  final List<String> tips; // curiosidades, trucos, etc.

  RawgGame({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.released,
    this.rating = 0.0,
    this.genres = const [],
    this.description = '',
    this.platforms = const [],
    this.tips = const [],
  });

  factory RawgGame.fromJson(Map<String, dynamic> json) {
    return RawgGame(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['background_image'] ?? '',
      released: json['released'] ?? '',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      genres: (json['genres'] != null)
          ? List<String>.from((json['genres'] as List).map((g) => g['name'] as String))
          : [],
      description: json['description_raw'] ?? json['description'] ?? '',
      platforms: (json['platforms'] != null)
          ? List<String>.from((json['platforms'] as List).map((p) => p['platform']['name'] as String))
          : [],
      tips: (json['tips'] != null) ? List<String>.from(json['tips']) : [],
    );
  }

  // Para almacenamiento local: toJson y fromLocalJson
  Map<String, dynamic> toJson() {
    // Para API o almacenamiento completo
    return {
      'id': id,
      'name': name,
      'background_image': backgroundImage,
      'released': released,
      'rating': rating,
      'genres': genres,
      'description': description,
      'platforms': platforms,
      'tips': tips,
    };
  }

  Map<String, dynamic> toLocalJson() {
    // Para almacenamiento local simplificado
    return {
      'id': id,
      'name': name,
      'background_image': backgroundImage,
      'released': released,
      'rating': rating,
      'genres': genres,
      'description': description,
      'platforms': platforms,
      'tips': tips,
    };
  }

  factory RawgGame.fromLocalJson(Map<String, dynamic> json) {
    return RawgGame(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['background_image'] ?? '',
      released: json['released'] ?? '',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      genres: (json['genres'] != null)
          ? List<String>.from(json['genres'])
          : [],
      description: json['description'] ?? '',
      platforms: (json['platforms'] != null)
          ? List<String>.from(json['platforms'])
          : [],
      tips: (json['tips'] != null) ? List<String>.from(json['tips']) : [],
    );
  }
}

