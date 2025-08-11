import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyect_final/features/news/domain/entities/article.dart';

class LocalArticleStorage {
  static const String _storageKey = 'saved_articles';

  Future<void> saveArticle(Article article) async {
    final savedArticles = await getSavedArticles();
    
    // Verificar si el artículo ya está guardado
    if (!savedArticles.any((a) => a.id == article.id)) {
      savedArticles.add(article);
      await _saveArticlesList(savedArticles);
    }
  }

  Future<void> removeArticle(Article article) async {
    final savedArticles = await getSavedArticles();
    savedArticles.removeWhere((a) => a.id == article.id);
    await _saveArticlesList(savedArticles);
  }

  Future<List<Article>> getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? articlesJson = prefs.getString(_storageKey);
    
    if (articlesJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(articlesJson);
      return decoded
          .map((item) => Article.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al decodificar artículos guardados: $e');
      return [];
    }
  }

  Future<bool> isArticleSaved(String articleId) async {
    final savedArticles = await getSavedArticles();
    return savedArticles.any((article) => article.id == articleId);
  }

  Future<void> _saveArticlesList(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      articles.map((article) => article.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }
}
