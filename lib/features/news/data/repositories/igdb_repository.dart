import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/igdb_news_model.dart';
import '../models/news_model.dart';

class IGDBRepository {
  // Obtener juegos populares
  Future<List<NewsArticle>> getPopularGames() async {
    try {
      final String query = '''
        fields id, title, summary, content, image, created_at, updated_at, author, url, games, platforms;
        sort popularity desc;
        limit 10;
      ''';
      final List<dynamic> data = await _makeIGDBRequest('pulse', query);
      if (data.isEmpty) return [];
      final List<IGDBNewsArticle> igdbArticles = data.map((item) => IGDBNewsArticle.fromJson(item)).toList();
      return igdbArticles.map((article) => article.toNewsArticle()).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtener juegos anticipados
  Future<List<NewsArticle>> getAnticipatedGames() async {
    try {
      final String query = '''
        fields id, title, summary, content, image, created_at, updated_at, author, url, games, platforms;
        sort hypes desc;
        limit 10;
      ''';
      final List<dynamic> data = await _makeIGDBRequest('pulse', query);
      if (data.isEmpty) return [];
      final List<IGDBNewsArticle> igdbArticles = data.map((item) => IGDBNewsArticle.fromJson(item)).toList();
      return igdbArticles.map((article) => article.toNewsArticle()).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtener eventos recientes de videojuegos
  Future<List<NewsArticle>> getRecentGamingEvents() async {
    try {
      final String query = '''
        fields id, title, summary, content, image, created_at, updated_at, author, url, games, platforms;
        where category = 2;
        sort created_at desc;
        limit 10;
      ''';
      final List<dynamic> data = await _makeIGDBRequest('pulse', query);
      if (data.isEmpty) return [];
      final List<IGDBNewsArticle> igdbArticles = data.map((item) => IGDBNewsArticle.fromJson(item)).toList();
      return igdbArticles.map((article) => article.toNewsArticle()).toList();
    } catch (e) {
      return [];
    }
  }
  // Credenciales de Twitch Developer Portal
  final String _clientId = '1dpyhwwfq4kb15ohghne8bp5pf8h2q';
  final String _clientSecret = '95t2sla5o1g6pdcvoomcwf47hcnwvy';
  
  // URLs de la API
  final String _twitchAuthUrl = 'https://id.twitch.tv/oauth2/token';
  final String _igdbApiUrl = 'https://api.igdb.com/v4';
  
  // Cliente HTTP
  final http.Client _client;
  
  // Clave para almacenar el token en SharedPreferences
  static const String _authTokenKey = 'igdb_auth_token';
  
  IGDBRepository({http.Client? client}) : _client = client ?? http.Client();
  
  // Obtener token de autenticación de Twitch
  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedAuthJson = prefs.getString(_authTokenKey);
    
    if (storedAuthJson != null) {
      final TwitchAuth auth = TwitchAuth.fromJson(json.decode(storedAuthJson));
      if (!auth.isExpired) {
        return auth.accessToken;
      }
    }
    
    // Si no hay token almacenado o está expirado, obtener uno nuevo
    return _refreshAuthToken();
  }
  
  // Refrescar el token de autenticación
  Future<String> _refreshAuthToken() async {
    try {
      final response = await _client.post(
        Uri.parse(_twitchAuthUrl),
        body: {
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'grant_type': 'client_credentials',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final TwitchAuth auth = TwitchAuth.fromJson(data);
        
        // Guardar el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, json.encode(auth.toJson()));
        
        return auth.accessToken;
      } else {
        throw Exception('Error al obtener token de autenticación: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener token de autenticación: $e');
    }
  }
  
  // Realizar una solicitud a la API de IGDB
  Future<List<dynamic>> _makeIGDBRequest(String endpoint, String query) async {
    try {
      final String token = await _getAuthToken();
      
      print('Realizando solicitud a IGDB endpoint: $endpoint');
      print('Query: $query');
      
      final response = await _client.post(
        Uri.parse('$_igdbApiUrl/$endpoint'),
        headers: {
          'Client-ID': _clientId,
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'text/plain',
        },
        body: query,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Respuesta exitosa de IGDB. Longitud de datos: ${data is List ? data.length : "no es lista"}');
        
        if (data is List) {
          return data;
        } else {
          print('Error: La respuesta de IGDB no es una lista: $data');
          return [];
        }
      } else {
        print('Error en la solicitud a IGDB: ${response.statusCode} - ${response.body}');
        throw Exception('Error en la solicitud a IGDB: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al hacer solicitud a IGDB: $e');
      throw Exception('Error en la solicitud a IGDB: $e');
    }
  }
  
  // Obtener noticias de videojuegos
  Future<List<NewsArticle>> getGameNews() async {
    try {
      // Consulta para obtener artículos recientes
      final String query = '''
        fields id, title, summary, content, image, created_at, updated_at, author, url, games, platforms;
        where category = 1;
        sort created_at desc;
        limit 20;
      ''';
      
      print('Realizando consulta a IGDB: $query');
      final List<dynamic> data = await _makeIGDBRequest('pulse', query);
      print('Respuesta de IGDB recibida: ${data.length} artículos');
      
      if (data.isEmpty) {
        print('No se encontraron artículos en IGDB, usando datos de ejemplo');
        return _getMockGameNews();
      }
      
      // Convertir los datos a objetos IGDBNewsArticle y luego a NewsArticle
      final List<IGDBNewsArticle> igdbArticles = data
          .map((item) => IGDBNewsArticle.fromJson(item))
          .toList();
      
      final articles = igdbArticles.map((article) => article.toNewsArticle()).toList();
      print('Artículos procesados: ${articles.length}');
      return articles;
    } catch (e) {
      print('Error al obtener noticias de IGDB: $e');
      // En caso de error, devolver datos de ejemplo
      return _getMockGameNews();
    }
  }
  
  // Buscar noticias por término
  Future<List<NewsArticle>> searchGameNews(String query) async {
    try {
      // Consulta para buscar artículos que coincidan con el término
      final String searchQuery = '''
        fields id, title, summary, content, image, created_at, updated_at, author, url, games, platforms;
        where category = 1 & (title ~ *"$query"* | summary ~ *"$query"*);
        sort created_at desc;
        limit 20;
      ''';
      
      print('Realizando búsqueda en IGDB: $searchQuery');
      final List<dynamic> data = await _makeIGDBRequest('pulse', searchQuery);
      print('Resultados de búsqueda recibidos: ${data.length} artículos');
      
      if (data.isEmpty) {
        print('No se encontraron resultados para la búsqueda "$query"');
        // Filtrar los datos de ejemplo que coincidan con la consulta
        final mockNews = _getMockGameNews();
        return mockNews.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
                 article.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      
      // Convertir los datos a objetos IGDBNewsArticle y luego a NewsArticle
      final List<IGDBNewsArticle> igdbArticles = data
          .map((item) => IGDBNewsArticle.fromJson(item))
          .toList();
      
      final articles = igdbArticles.map((article) => article.toNewsArticle()).toList();
      print('Artículos de búsqueda procesados: ${articles.length}');
      return articles;
    } catch (e) {
      print('Error al buscar noticias en IGDB: $e');
      // En caso de error, devolver una lista vacía
      return [];
    }
  }
  
  // Datos de ejemplo para cuando la API no esté disponible
  List<NewsArticle> _getMockGameNews() {
    return [
      NewsArticle(
        id: 'igdb-1',
        title: 'Nuevo DLC anunciado para Elden Ring',
        description: 'FromSoftware ha anunciado un nuevo DLC para Elden Ring que expandirá la historia del juego.',
        content: 'FromSoftware y Bandai Namco han anunciado oficialmente un nuevo DLC para Elden Ring titulado "Shadow of the Erdtree". Este DLC expandirá la historia del juego y añadirá nuevas áreas, jefes y equipamiento. Se espera su lanzamiento para el próximo año.',
        imageUrl: 'https://picsum.photos/800/400?random=10',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        source: 'IGDB',
        author: 'IGDB News',
        url: 'https://ejemplo.com/elden-ring-dlc',
      ),
      NewsArticle(
        id: 'igdb-2',
        title: 'Revelado el nuevo juego de Nintendo',
        description: 'Nintendo ha revelado su próximo gran título exclusivo para Switch durante el último Nintendo Direct.',
        content: 'Durante el último Nintendo Direct, la compañía japonesa ha revelado su próximo gran título exclusivo para Switch. Se trata de una nueva IP que combinará elementos de acción y aventura en un mundo abierto. El juego está siendo desarrollado por el equipo responsable de The Legend of Zelda: Breath of the Wild.',
        imageUrl: 'https://picsum.photos/800/400?random=11',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        source: 'IGDB',
        author: 'IGDB News',
        url: 'https://ejemplo.com/nuevo-juego-nintendo',
      ),
      NewsArticle(
        id: 'igdb-3',
        title: 'PlayStation anuncia nuevos juegos para PSVR2',
        description: 'Sony ha anunciado una nueva línea de juegos exclusivos para PlayStation VR2.',
        content: 'Sony Interactive Entertainment ha anunciado una nueva línea de juegos exclusivos para PlayStation VR2. Entre los títulos anunciados se encuentran secuelas de franquicias populares y nuevas IPs desarrolladas específicamente para aprovechar las características del nuevo dispositivo de realidad virtual.',
        imageUrl: 'https://picsum.photos/800/400?random=12',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        source: 'IGDB',
        author: 'IGDB News',
        url: 'https://ejemplo.com/psvr2-nuevos-juegos',
      ),
    ];
  }
  
  // Cerrar el cliente HTTP cuando ya no se necesite
  void dispose() {
    _client.close();
  }
}