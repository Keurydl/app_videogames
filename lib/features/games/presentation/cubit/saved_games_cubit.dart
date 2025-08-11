import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/local_saved_games_storage.dart';
import '../../data/datasources/local_stats_storage.dart';
import '../../data/models/rawg_game_model.dart';

// Estados
abstract class SavedGamesState extends Equatable {
  const SavedGamesState();
  
  @override
  List<Object> get props => [];
}

class SavedGamesInitial extends SavedGamesState {}

class SavedGamesLoading extends SavedGamesState {}

class SavedGamesLoaded extends SavedGamesState {
  final List<RawgGame> games;
  
  const SavedGamesLoaded(this.games);
  
  @override
  List<Object> get props => [games];
}

class SavedGamesError extends SavedGamesState {
  final String message;
  
  const SavedGamesError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Cubit
class SavedGamesCubit extends Cubit<SavedGamesState> {
  final LocalSavedGamesStorage _savedGamesStorage;
  final LocalStatsStorage _statsStorage;
  
  SavedGamesCubit({
    LocalSavedGamesStorage? savedGamesStorage,
    LocalStatsStorage? statsStorage,
  })  : _savedGamesStorage = savedGamesStorage ?? LocalSavedGamesStorage(),
        _statsStorage = statsStorage ?? LocalStatsStorage(),
        super(SavedGamesInitial());
  
  Future<void> loadSavedGames() async {
    try {
      emit(SavedGamesLoading());
      final games = await _savedGamesStorage.getSavedGames();
      emit(SavedGamesLoaded(games));
    } catch (e) {
      emit(SavedGamesError('Error al cargar los juegos guardados'));
    }
  }
  
  Future<void> removeGame(RawgGame game) async {
    try {
      await _savedGamesStorage.removeGame(game);
      await _statsStorage.decrementSavedGamesCount();
      if (state is SavedGamesLoaded) {
        final games = List<RawgGame>.from((state as SavedGamesLoaded).games)
          ..removeWhere((g) => g.id == game.id);
        emit(SavedGamesLoaded(games));
      }
    } catch (e) {
      emit(SavedGamesError('Error al eliminar el juego'));
    }
  }
}
