import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rawg_game_model.dart';

class RawgRepository {
  final String _apiKey = '460d6ca40b9a413f8d202e25d8a17aa0';
  final String _baseUrl = 'https://api.rawg.io/api';

  Future<List<RawgGame>> fetchGames() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&page_size=10'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<RawgGame> fetchGameDetails(int id) async {
    final url = Uri.parse('$_baseUrl/games/$id?key=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RawgGame.fromJson(data);
    } else {
      throw Exception('Error al cargar detalles del juego');
    }
  }

  Future<List<RawgGame>> fetchGamesByPlatform(String platform) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&platforms=${Uri.encodeComponent(platform)}&page_size=20');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar juegos por plataforma');
    }
  }

  Future<List<RawgGame>> fetchGamesByGenre(String genre) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&genres=${Uri.encodeComponent(genre)}&page_size=20');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar juegos por género');
    }
  }

  Future<List<RawgGame>> fetchRecentGames({int pageSize = 50}) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&ordering=-released&page_size=$pageSize');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar juegos recientes');
    }
  }

  Future<List<RawgGame>> fetchRecentGamesByPlatform(String platformId, {int pageSize = 30}) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&platforms=$platformId&ordering=-released&page_size=$pageSize');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar juegos recientes por plataforma');
    }
  }

  Future<List<RawgGame>> fetchNewReleasesByPlatform(String platformId, {int days = 30, int pageSize = 20}) async {
    final now = DateTime.now();
    final lastMonth = now.subtract(Duration(days: days));
    final dateRange = '${lastMonth.toIso8601String().substring(0, 10)},${now.toIso8601String().substring(0, 10)}';
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&platforms=$platformId&dates=$dateRange&ordering=-released&page_size=$pageSize');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar nuevos lanzamientos por plataforma');
    }
  }

  Future<List<RawgGame>> fetchRecentGamesByGenre(String genre, {int pageSize = 30}) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&genres=${Uri.encodeComponent(genre)}&ordering=-released&page_size=$pageSize');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar juegos recientes por género');
    }
  }

  Future<List<RawgGame>> fetchNewReleasesByGenre(String genre, {int days = 30, int pageSize = 20}) async {
    final now = DateTime.now();
    final lastMonth = now.subtract(Duration(days: days));
    final dateRange = '${lastMonth.toIso8601String().substring(0, 10)},${now.toIso8601String().substring(0, 10)}';
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&genres=${Uri.encodeComponent(genre)}&dates=$dateRange&ordering=-released&page_size=$pageSize');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar nuevos lanzamientos por género');
    }
  }

  // Nuevos lanzamientos (últimos 30 días)
  Future<List<RawgGame>> fetchNewReleases() async {
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 30));
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&dates=${lastMonth.toIso8601String().substring(0,10)},${now.toIso8601String().substring(0,10)}&ordering=-released&page_size=10'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load new releases');
    }
  }

  // Próximos lanzamientos (por venir)
  Future<List<RawgGame>> fetchUpcomingGames() async {
    final now = DateTime.now();
    final nextYear = now.add(const Duration(days: 365));
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&dates=${now.toIso8601String().substring(0,10)},${nextYear.toIso8601String().substring(0,10)}&ordering=released&page_size=10'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load upcoming games');
    }
  }

  // Top juegos (populares)
  Future<List<RawgGame>> fetchTopGames() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&ordering=-rating&page_size=10'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => RawgGame.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top games');
    }
  }
}
