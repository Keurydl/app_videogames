import 'package:equatable/equatable.dart';
import 'package:proyect_final/features/news/data/models/news_model.dart';

// Estado para múltiples secciones de noticias/juegos/eventos
class NewsSectionsLoaded extends NewsState {
  final List<NewsArticle> recentlyReviewed;
  final List<NewsArticle> mostAnticipated;
  final List<NewsArticle> popularRightNow;
  final List<NewsArticle> recentGamingEvents;

  const NewsSectionsLoaded({
    required this.recentlyReviewed,
    required this.mostAnticipated,
    required this.popularRightNow,
    required this.recentGamingEvents,
  });

  @override
  List<Object> get props => [recentlyReviewed, mostAnticipated, popularRightNow, recentGamingEvents];
}
// Estados posibles para el manejo de noticias
abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

// Estado inicial
class NewsInitial extends NewsState {}

// Estado de carga
class NewsLoading extends NewsState {}

// Estado de éxito con datos
class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final bool hasReachedMax;

  const NewsLoaded({
    required this.articles,
    this.hasReachedMax = false,
  });

  // Método para copiar el estado con nuevos valores
  NewsLoaded copyWith({
    List<NewsArticle>? articles,
    bool? hasReachedMax,
  }) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [articles, hasReachedMax];
}

// Estado de error
class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}
