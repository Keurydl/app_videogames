import 'news_model.dart';

class IGDBNewsArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final String source;
  final String author;
  final String url;
  final List<String> gameIds;
  final List<String> platforms;

  IGDBNewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.url,
    required this.gameIds,
    required this.platforms,
  });

  // Método estático para procesar URLs de imágenes
  static String _processImageUrl(Map<String, dynamic> json) {
    // Verificar si hay una imagen disponible
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      final String imageUrl = json['image'].toString();
      
      // Verificar si la URL comienza con // (protocolo relativo)
      if (imageUrl.startsWith('//')) {
        return 'https:$imageUrl';
      }
      // Verificar si la URL ya tiene un protocolo
      else if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return imageUrl;
      }
      // Agregar https:// si no tiene protocolo
      else {
        return 'https://$imageUrl';
      }
    }
    
    // Si no hay imagen, usar una imagen de placeholder
    final String id = json['id']?.toString() ?? '1';
    return 'https://picsum.photos/800/400?random=$id';
  }

  factory IGDBNewsArticle.fromJson(Map<String, dynamic> json) {
    // Convertir la fecha de IGDB (timestamp en segundos) a DateTime
    final DateTime date = json['created_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000)
        : DateTime.now();

    // Extraer IDs de juegos relacionados
    List<String> gameIds = [];
    if (json['games'] != null && json['games'] is List) {
      gameIds = (json['games'] as List).map((game) => game.toString()).toList();
    }

    // Extraer plataformas relacionadas
    List<String> platforms = [];
    if (json['platforms'] != null && json['platforms'] is List) {
      platforms = (json['platforms'] as List).map((platform) => platform.toString()).toList();
    }

    return IGDBNewsArticle(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['summary'] ?? '',
      content: json['content'] ?? json['summary'] ?? '',
      imageUrl: IGDBNewsArticle._processImageUrl(json),
      publishedAt: date,
      source: 'IGDB',
      author: json['author'] ?? 'IGDB',
      url: json['url'] ?? '',
      gameIds: gameIds,
      platforms: platforms,
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
      'gameIds': gameIds,
      'platforms': platforms,
    };
  }

  // Convertir a NewsArticle para mantener compatibilidad con la UI existente
  NewsArticle toNewsArticle() {
    return NewsArticle(
      id: id,
      title: title,
      description: description,
      content: content,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      source: source,
      author: author,
      url: url,
    );
  }
}

// Clase para manejar la autenticación de Twitch/IGDB
class TwitchAuth {
  final String accessToken;
  final int expiresIn;
  final DateTime createdAt;

  TwitchAuth({
    required this.accessToken,
    required this.expiresIn,
    required this.createdAt,
  });

  factory TwitchAuth.fromJson(Map<String, dynamic> json) {
    return TwitchAuth(
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'expires_in': expiresIn,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isExpired {
    final expirationDate = createdAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expirationDate);
  }
}