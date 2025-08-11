import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/local_saved_games_storage.dart';
import '../../data/models/rawg_game_model.dart';
import '../../data/repositories/rawg_repository.dart';

part 'game_detail_state.dart';

class GameDetailCubit extends Cubit<GameDetailState> {
  final RawgRepository repository;
  final LocalSavedGamesStorage _savedGamesStorage = LocalSavedGamesStorage();
  
  GameDetailCubit(this.repository) : super(GameDetailInitial());

  Future<void> fetchDetails(int gameId) async {
    try {
      emit(GameDetailLoading());
      final game = await repository.fetchGameDetails(gameId);
      
      // Verificar si el juego ya está guardado
      final isSaved = await _savedGamesStorage.isGameSaved(game);
      emit(GameDetailLoaded(game, isSaved: isSaved));
      
    } catch (e) {
      emit(GameDetailError('Error al cargar los detalles del juego'));
    }
  }

  Future<void> toggleSaveGame(RawgGame game) async {
    try {
      if (state is GameDetailLoaded) {
        final currentState = state as GameDetailLoaded;
        
        if (currentState.isSaved) {
          await _savedGamesStorage.removeGame(game);
          emit(GameSavedSuccess(false));
          emit(currentState.copyWith(isSaved: false));
        } else {
          await _savedGamesStorage.saveGame(game);
          emit(GameSavedSuccess(true));
          emit(currentState.copyWith(isSaved: true));
        }
      }
    } catch (e) {
      emit(GameSaveError('Error al guardar/eliminar el juego'));
      
      // Restaurar el estado anterior en caso de error
      if (state is GameDetailLoaded) {
        final currentState = state as GameDetailLoaded;
        emit(currentState);
      }
    }
  }
}
