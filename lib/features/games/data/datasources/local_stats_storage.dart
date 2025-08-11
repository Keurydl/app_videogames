import 'package:shared_preferences/shared_preferences.dart';

class LocalStatsStorage {
  static const _demoGamesKey = 'demo_games_explored';
  static const _triviasPlayedKey = 'trivias_played';
  static const _triviaCorrectKey = 'trivia_correct';
  static const _gamesHistoryKey = 'games_history';
  static const _savedGamesCountKey = 'saved_games_count';

  Future<void> incrementDemoGamesExplored() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_demoGamesKey) ?? 0;
    await prefs.setInt(_demoGamesKey, current + 1);
  }

  Future<void> incrementTriviasPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_triviasPlayedKey) ?? 0;
    await prefs.setInt(_triviasPlayedKey, current + 1);
  }

  Future<void> incrementTriviaCorrect() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_triviaCorrectKey) ?? 0;
    await prefs.setInt(_triviaCorrectKey, current + 1);
  }

  Future<void> addGameToHistory(String gameName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_gamesHistoryKey) ?? [];
    if (!history.contains(gameName)) {
      history.add(gameName);
      await prefs.setStringList(_gamesHistoryKey, history);
    }
  }

  Future<void> decrementSavedGamesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_savedGamesCountKey) ?? 0;
    final newValue = current > 0 ? current - 1 : 0;
    await prefs.setInt(_savedGamesCountKey, newValue);
  }

  Future<int> getDemoGamesExplored() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_demoGamesKey) ?? 0;
  }

  Future<int> getTriviasPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_triviasPlayedKey) ?? 0;
  }

  Future<int> getTriviaCorrect() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_triviaCorrectKey) ?? 0;
  }

  Future<List<String>> getGamesHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_gamesHistoryKey) ?? [];
  }

  Future<void> clearStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_demoGamesKey);
    await prefs.remove(_triviasPlayedKey);
    await prefs.remove(_triviaCorrectKey);
    await prefs.remove(_gamesHistoryKey);
  }
}
