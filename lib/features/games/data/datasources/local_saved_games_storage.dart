import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/rawg_game_model.dart';
import 'dart:convert';

class LocalSavedGamesStorage {
  static const _savedGamesKey = 'saved_games';

  Future<void> saveGame(RawgGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_savedGamesKey) ?? [];
    final gameJson = jsonEncode(game.toLocalJson());
    if (!saved.contains(gameJson)) {
      saved.add(gameJson);
      await prefs.setStringList(_savedGamesKey, saved);
    }
  }

  Future<void> removeGame(RawgGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_savedGamesKey) ?? [];
    final gameJson = jsonEncode(game.toLocalJson());
    saved.remove(gameJson);
    await prefs.setStringList(_savedGamesKey, saved);
  }

  Future<List<RawgGame>> getSavedGames() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_savedGamesKey) ?? [];
    final games = saved.map((g) => RawgGame.fromLocalJson(jsonDecode(g))).toList();
    return games;
  }

  Future<bool> isGameSaved(RawgGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_savedGamesKey) ?? [];
    final gameJson = jsonEncode(game.toLocalJson());
    return saved.contains(gameJson);
  }
}
