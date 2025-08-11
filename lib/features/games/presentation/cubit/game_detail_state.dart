part of 'game_detail_cubit.dart';

abstract class GameDetailState {}

class GameDetailInitial extends GameDetailState {}

class GameDetailLoading extends GameDetailState {}

class GameDetailLoaded extends GameDetailState {
  final RawgGame game;
  final bool isSaved;
  
  GameDetailLoaded(this.game, {this.isSaved = false});
  
  GameDetailLoaded copyWith({bool? isSaved}) {
    return GameDetailLoaded(
      game,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class GameDetailError extends GameDetailState {
  final String message;
  GameDetailError(this.message);
}

class GameSavedSuccess extends GameDetailState {
  final bool isSaved;
  GameSavedSuccess(this.isSaved);
}

class GameSaveError extends GameDetailState {
  final String message;
  GameSaveError(this.message);
}
