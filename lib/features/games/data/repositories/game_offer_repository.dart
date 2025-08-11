import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_offer_model.dart';

class GameOfferRepository {
  final String _baseUrl = 'https://www.gamerpower.com/api';
  final http.Client client;

  GameOfferRepository({http.Client? client}) : client = client ?? http.Client();

  Future<List<GameOffer>> getGameOffers() async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/filter?platform=epic-games-store,steam,ubisoft,gog,itchio,origin,battle.net,rockstar'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GameOffer.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las ofertas de juegos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<GameOffer>> searchGameOffers(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/filter?platform=pc&title=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GameOffer.fromJson(json)).toList();
      } else {
        throw Exception('Error al buscar ofertas');
      }
    } catch (e) {
      throw Exception('Error de búsqueda: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
