import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/local_article_storage.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final LocalArticleStorage localArticleStorage;

  ArticleRepositoryImpl({required this.localArticleStorage});

  @override
  Future<List<Article>> getSavedArticles() {
    return localArticleStorage.getSavedArticles();
  }
}
