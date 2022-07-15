import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/tv_usecase/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv_usecase/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTv _getTvWatchlist;
  final GetWatchListTvStatus _getWatchListTvStatus;
  final RemoveTvWatchlist _removeTvWatchlist;
  final SaveTvWatchlist _saveTvWatchlist;

  TvWatchlistBloc(
    this._getTvWatchlist,
    this._getWatchListTvStatus,
    this._removeTvWatchlist,
    this._saveTvWatchlist,
  ) : super(TvWatchlistEmpty()) {
    on<TvWatchlistLoad>(_loadTvWatchlist);
    on<LoadTvWatchlistStatus>(_loadTvWatchlistStatus);
    on<AddTvToWatchlist>(_addTvToWatchlist);
    on<RemoveTvFromWatchlist>(_removeTvFromWatchlist);
  }

  FutureOr<void> _loadTvWatchlist(
    TvWatchlistLoad event,
    Emitter<TvWatchlistState> emit,
  ) async {
    emit(TvWatchlistLoading());

    final result = await _getTvWatchlist.execute();

    result.fold(
      (failure) {
        emit(TvWatchlistError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(TvWatchlistEmpty())
            : emit(TvWatchlistHasData(data));
      },
    );
  }

  Future<void> _removeTvFromWatchlist(
    RemoveTvFromWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final result = await _removeTvWatchlist.execute(event.tv);

    result.fold(
      (failure) {
        emit(TvWatchlistError(failure.message));
      },
      (message) {
        emit(TvWatchlistMessage(message));
      },
    );
  }

  FutureOr<void> _loadTvWatchlistStatus(
    LoadTvWatchlistStatus event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final result = await _getWatchListTvStatus.execute(event.id);
    emit(TvAddedToWatchlist(result));
  }

  Future<void> _addTvToWatchlist(
    AddTvToWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final result = await _saveTvWatchlist.execute(event.tv);

    result.fold(
      (failure) {
        emit(TvWatchlistError(failure.message));
      },
      (message) {
        emit(TvWatchlistMessage(message));
      },
    );
  }
}
