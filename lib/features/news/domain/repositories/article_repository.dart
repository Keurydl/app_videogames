import 'package:proyect_final/features/news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getSavedArticles();
}
