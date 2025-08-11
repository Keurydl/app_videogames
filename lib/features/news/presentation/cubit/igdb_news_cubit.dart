import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_final/features/news/data/models/news_model.dart';
import 'package:proyect_final/features/news/data/repositories/igdb_repository.dart';
import 'package:proyect_final/features/news/presentation/cubit/news_state.dart';

class IGDBNewsCubit extends Cubit<NewsState> {
  // Cargar todas las secciones: Recently Reviewed, Most Anticipated, Popular, Events
  Future<void> loadSections() async {
    emit(NewsLoading());
    try {
      final recentlyReviewed = await _igdbRepository.getGameNews();
      final mostAnticipated = await _igdbRepository.getAnticipatedGames();
      final popularRightNow = await _igdbRepository.getPopularGames();
      final recentGamingEvents = await _igdbRepository.getRecentGamingEvents();

      emit(NewsSectionsLoaded(
        recentlyReviewed: recentlyReviewed,
        mostAnticipated: mostAnticipated,
        popularRightNow: popularRightNow,
        recentGamingEvents: recentGamingEvents,
      ));
    } catch (e) {
      emit(NewsError('Error al cargar las secciones de IGDB.'));
    }
  }
  final IGDBRepository _igdbRepository;
  
  List<NewsArticle> _allArticles = [];
  bool _hasReachedMax = false;

  IGDBNewsCubit({required IGDBRepository igdbRepository})
      : _igdbRepository = igdbRepository,
        super(NewsInitial());

  // Cargar noticias de videojuegos desde IGDB
  Future<void> loadNews() async {
    if (state is NewsLoading) return;

    emit(NewsLoading());
    print('IGDBNewsCubit: Cargando noticias...');
    
    try {
      // Obtener noticias del repositorio de IGDB
      final news = await _igdbRepository.getGameNews();
      print('IGDBNewsCubit: Noticias recibidas: ${news.length}');
      
      // Actualizar el estado
      _hasReachedMax = true; // Por ahora no implementamos paginación para IGDB
      _allArticles = news;
      
      if (_allArticles.isEmpty) {
        print('IGDBNewsCubit: No se cargaron artículos, emitiendo estado de error');
        emit(NewsError('No se pudieron cargar noticias. Usando datos de ejemplo.'));
      } else {
        print('IGDBNewsCubit: Emitiendo ${_allArticles.length} artículos');
        emit(NewsLoaded(articles: _allArticles, hasReachedMax: _hasReachedMax));
      }
    } catch (e) {
      print('Error en IGDBNewsCubit.loadNews: $e');
      emit(NewsError('Error al cargar las noticias de videojuegos. Usando datos de ejemplo.'));
      
      // Si hay un error pero ya teníamos artículos, mantenerlos
      if (_allArticles.isNotEmpty) {
        print('IGDBNewsCubit: Manteniendo ${_allArticles.length} artículos previos');
        emit(NewsLoaded(articles: _allArticles, hasReachedMax: _hasReachedMax));
      }
    }
  }

  // Buscar noticias por término
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      // Si la búsqueda está vacía, volver a cargar las noticias principales
      print('IGDBNewsCubit: Búsqueda vacía, cargando noticias principales');
      _allArticles = [];
      _hasReachedMax = false;
      await loadNews();
      return;
    }

    emit(NewsLoading());
    print('IGDBNewsCubit: Buscando noticias con el término: "$query"');
    
    try {
      // Buscar noticias en el repositorio de IGDB
      final results = await _igdbRepository.searchGameNews(query);
      print('IGDBNewsCubit: Resultados de búsqueda recibidos: ${results.length}');
      
      if (results.isEmpty) {
        print('IGDBNewsCubit: No se encontraron resultados para "$query"');
        emit(NewsError('No se encontraron resultados para "$query". Intenta con otro término.'));
      } else {
        print('IGDBNewsCubit: Emitiendo ${results.length} resultados de búsqueda');
        emit(NewsLoaded(articles: results, hasReachedMax: true));
      }
    } catch (e) {
      print('Error en IGDBNewsCubit.searchNews: $e');
      emit(NewsError('Error al buscar noticias. Intenta con otro término o verifica tu conexión.'));
      
      // Si hay un error pero ya teníamos artículos, mantenerlos
      if (_allArticles.isNotEmpty) {
        print('IGDBNewsCubit: Manteniendo ${_allArticles.length} artículos previos');
        emit(NewsLoaded(articles: _allArticles, hasReachedMax: _hasReachedMax));
      }
    }
  }

  // Limpiar el estado
  void clear() {
    _allArticles = [];
    _hasReachedMax = false;
    emit(NewsInitial());
  }

  @override
  Future<void> close() {
    _igdbRepository.dispose();
    return super.close();
  }
}