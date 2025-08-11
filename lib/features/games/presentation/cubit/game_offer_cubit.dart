import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_final/features/games/data/models/game_offer_model.dart';
import 'package:proyect_final/features/games/data/repositories/game_offer_repository.dart';
import 'package:proyect_final/features/games/presentation/cubit/game_offer_state.dart';

class GameOfferCubit extends Cubit<GameOfferState> {
  final GameOfferRepository _repository;
  int _page = 0;
  static const int _pageSize = 10;
  bool _hasReachedMax = false;
  List<dynamic> _allOffers = [];

  GameOfferCubit(this._repository) : super(GameOfferInitial());

  Future<void> loadOffers() async {
    if (state is GameOfferLoading) return;

    emit(GameOfferLoading());

    try {
      final List<GameOffer> offers = await _repository.getGameOffers();
      _allOffers = offers;
      
      emit(GameOfferLoaded(
        offers: _getPaginatedOffers(),
        hasReachedMax: _hasReachedMax,
      ));
    } catch (e) {
      emit(GameOfferError(e.toString()));
    }
  }

  Future<void> loadMoreOffers() async {
    if (state is! GameOfferLoaded || _hasReachedMax) return;

    final currentState = state as GameOfferLoaded;
    
    if (currentState.offers.length < _allOffers.length) {
      _page++;
      
      emit(currentState.copyWith(
        hasReachedMax: _hasReachedMax,
      ));
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(GameOfferLoaded(
        offers: _getPaginatedOffers(),
        hasReachedMax: _hasReachedMax,
      ));
    } else {
      _hasReachedMax = true;
      emit(currentState.copyWith(hasReachedMax: true));
    }
  }

  Future<void> searchOffers(String query) async {
    emit(GameOfferLoading());
    
    try {
      final List<GameOffer> results = await _repository.searchGameOffers(query);
      emit(GameOfferLoaded(
        offers: results,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(GameOfferError('Error al buscar ofertas: $e'));
    }
  }

  void clearSearch() {
    if (state is GameOfferLoaded) {
      emit(GameOfferLoaded(
        offers: _getPaginatedOffers(),
        hasReachedMax: _hasReachedMax,
      ));
    }
  }

  List<GameOffer> _getPaginatedOffers() {
    final start = _page * _pageSize;
    if (start >= _allOffers.length) {
      _hasReachedMax = true;
      return _allOffers.cast<GameOffer>();
    }
    
    final end = (start + _pageSize).clamp(0, _allOffers.length);
    return _allOffers.sublist(0, end).cast<GameOffer>();
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
