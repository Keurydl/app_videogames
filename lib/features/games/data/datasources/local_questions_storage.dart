import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalQuestionsStorage {
  static const String _questionsKey = 'game_vault_questions';

  /// Carga preguntas desde assets (solo la primera vez o cuando el usuario descarga el vault)
  Future<List<Question>> loadQuestionsFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/questions/game_vault.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((q) => Question.fromJson(q)).toList();
  }

  /// Guarda preguntas localmente en SharedPreferences
  Future<void> saveQuestions(List<Question> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = questions.map((q) => json.encode(q.toJson())).toList();
    await prefs.setStringList(_questionsKey, jsonList);
  }

  /// Obtiene preguntas guardadas localmente
  Future<List<Question>> getLocalQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_questionsKey);
    if (jsonList == null) return [];
    return jsonList.map((q) => Question.fromJson(json.decode(q))).toList();
  }

  /// Borra el banco local (opcional)
  Future<void> clearQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_questionsKey);
  }
}
