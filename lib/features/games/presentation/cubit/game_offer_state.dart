import 'package:equatable/equatable.dart';
import '../../data/models/game_offer_model.dart';

abstract class GameOfferState extends Equatable {
  const GameOfferState();

  @override
  List<Object?> get props => [];
}

class GameOfferInitial extends GameOfferState {}

class GameOfferLoading extends GameOfferState {}

class GameOfferLoaded extends GameOfferState {
  final List<GameOffer> offers;
  final bool hasReachedMax;

  const GameOfferLoaded({
    required this.offers,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [offers, hasReachedMax];

  GameOfferLoaded copyWith({
    List<GameOffer>? offers,
    bool? hasReachedMax,
  }) {
    return GameOfferLoaded(
      offers: offers ?? this.offers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class GameOfferError extends GameOfferState {
  final String message;

  const GameOfferError(this.message);

  @override
  List<Object?> get props => [message];
}
