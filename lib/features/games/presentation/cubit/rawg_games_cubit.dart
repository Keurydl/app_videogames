import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/rawg_game_model.dart';
import '../../data/repositories/rawg_repository.dart';

class RawgGamesState {
  final List<RawgGame> newReleases;
  final List<RawgGame> upcoming;
  final List<RawgGame> top;
  final bool loading;
  final String? error;

  RawgGamesState({
    this.newReleases = const [],
    this.upcoming = const [],
    this.top = const [],
    this.loading = false,
    this.error,
  });

  RawgGamesState copyWith({
    List<RawgGame>? newReleases,
    List<RawgGame>? upcoming,
    List<RawgGame>? top,
    bool? loading,
    String? error,
  }) {
    return RawgGamesState(
      newReleases: newReleases ?? this.newReleases,
      upcoming: upcoming ?? this.upcoming,
      top: top ?? this.top,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class RawgGamesCubit extends Cubit<RawgGamesState> {
  final RawgRepository repository;
  RawgGamesCubit(this.repository) : super(RawgGamesState(loading: true));

  Future<void> loadAllSections() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final newReleases = await repository.fetchNewReleases();
      final upcoming = await repository.fetchUpcomingGames();
      final top = await repository.fetchTopGames();
      emit(RawgGamesState(
        newReleases: newReleases,
        upcoming: upcoming,
        top: top,
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
