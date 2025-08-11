import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsRepository {
  final String _apiKey = 'YOUR_NEWSAPI_KEY'; // Reemplaza con tu API key
  final String _baseUrl = 'https://newsapi.org/v2';
  final http.Client client;

  NewsRepository({http.Client? client}) : client = client ?? http.Client();

  // Obtener noticias de videojuegos
  Future<List<NewsArticle>> getTopHeadlines() async {
    try {
      final response = await client.get(
        Uri.parse(
          '$_baseUrl/top-headlines?category=technology&q=videojuegos&language=es&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articles = data['articles'];
          return articles
              .map((article) => NewsArticle.fromJson(article))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Error al cargar las noticias');
        }
      } else {
        throw Exception('Error al cargar las noticias: ${response.statusCode}');
      }
    } catch (e) {
      // En caso de error, devolver datos de ejemplo
      return _getMockNews();
    }
  }

  // Datos de ejemplo para cuando la API no esté disponible
  List<NewsArticle> _getMockNews() {
    return [
      NewsArticle(
        id: '1',
        title: 'Lanzamiento del nuevo juego más esperado',
        description: 'Descripción del nuevo lanzamiento...',
        content: 'Contenido detallado sobre el nuevo lanzamiento...',
        imageUrl: 'https://picsum.photos/800/400?random=1',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        source: 'Fuente de ejemplo',
        author: 'Autor de ejemplo',
        url: 'https://ejemplo.com/noticia1',
      ),
      NewsArticle(
        id: '2',
        title: 'Análisis del último lanzamiento de consolas',
        description: 'Análisis en profundidad de la nueva consola...',
        content: 'Contenido detallado del análisis...',
        imageUrl: 'https://picsum.photos/800/400?random=2',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        source: 'Otra fuente',
        author: 'Otro autor',
        url: 'https://ejemplo.com/noticia2',
      ),
    ];
  }

  // Cerrar el cliente HTTP cuando ya no se necesite
  void dispose() {
    client.close();
  }
}
