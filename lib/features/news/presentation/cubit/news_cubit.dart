import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_final/features/news/data/models/news_model.dart';
// Make sure NewsArticle is defined in news_model.dart or import the correct file where NewsArticle is defined.
import 'package:proyect_final/features/news/data/repositories/news_repository.dart';
import 'package:proyect_final/features/news/presentation/cubit/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;
  
  // TODO: Implementar paginación más adelante
  // Nota: Se agregará _currentPage cuando se implemente la paginación
  static const int _pageSize = 10;
  bool _hasReachedMax = false;
  List<NewsArticle> _allArticles = [];

  NewsCubit({required NewsRepository newsRepository})
      : _newsRepository = newsRepository,
        super(NewsInitial());

  // Cargar las primeras noticias
  Future<void> loadNews() async {
    // Si ya se está cargando o ya no hay más artículos, no hacer nada
    if (state is NewsLoading || _hasReachedMax) return;

      // Emitir estado de carga
    emit(NewsLoading());
    
    try {
      // Obtener noticias del repositorio
      final news = await _newsRepository.getTopHeadlines();
      
      // Actualizar el estado
      _hasReachedMax = news.length < _pageSize;
      _allArticles = news;
      // _currentPage++; // Se usará cuando se implemente la paginación
      
      emit(NewsLoaded(articles: _allArticles, hasReachedMax: _hasReachedMax));
    } catch (e) {
      emit(NewsError('Error al cargar las noticias: $e'));
      
      // Si hay un error pero ya teníamos artículos, mantenerlos
      if (_allArticles.isNotEmpty) {
        emit(NewsLoaded(articles: _allArticles, hasReachedMax: _hasReachedMax));
      }
    }
  }

  // Cargar más noticias (paginación)
  Future<void> loadMoreNews() async {
    if (state is! NewsLoaded || _hasReachedMax) return;

    try {
      final currentState = state as NewsLoaded;
      
      // Obtener más noticias del repositorio
      final moreNews = await _newsRepository.getTopHeadlines();
      
      if (moreNews.isEmpty) {
        _hasReachedMax = true;
      } else {
        _allArticles = List.of(currentState.articles)..addAll(moreNews);
      }
      
      emit(currentState.copyWith(
        articles: _allArticles,
        hasReachedMax: _hasReachedMax,
      ));
    } catch (e) {
      // Si hay un error, mantener el estado actual
      if (state is NewsLoaded) {
        emit((state as NewsLoaded).copyWith(hasReachedMax: _hasReachedMax));
      }
    }
  }

  // Actualizar una noticia (por ejemplo, marcar como favorita)
  void updateArticle(NewsArticle updatedArticle) {
    if (state is! NewsLoaded) return;
    
    final currentState = state as NewsLoaded;
    final index = _allArticles.indexWhere((a) => a.id == updatedArticle.id);
    
    if (index != -1) {
      _allArticles = List.of(_allArticles);
      _allArticles[index] = updatedArticle;
      
      emit(currentState.copyWith(articles: _allArticles));
    }
  }

  // Buscar noticias por término de búsqueda
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      // Si la búsqueda está vacía, volver a cargar las noticias principales
      _allArticles = [];
      _hasReachedMax = false;
      await loadNews();
      return;
    }

    emit(NewsLoading());
    
    try {
      // En una implementación real, llamarías a un método de búsqueda en el repositorio
      // Por ahora, filtramos las noticias existentes como ejemplo
      final results = _allArticles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      emit(NewsLoaded(articles: results, hasReachedMax: true));
    } catch (e) {
      emit(NewsError('Error al buscar noticias: $e'));
    }
  }

  // Limpiar el estado
  void clear() {
    // _currentPage = 1; // Se usará cuando se implemente la paginación
    _allArticles = [];
    _hasReachedMax = false;
    emit(NewsInitial());
  }

  @override
  Future<void> close() {
    _newsRepository.dispose();
    return super.close();
  }
}
