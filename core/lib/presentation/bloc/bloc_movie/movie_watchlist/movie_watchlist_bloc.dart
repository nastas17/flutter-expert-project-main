import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/movie_usecase/get_watchlist_movies.dart';
import 'package:core/domain/usecases/movie_usecase/remove_watchlist.dart';
import 'package:core/domain/usecases/movie_usecase/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie_usecase/save_watchlist.dart';

import 'package:equatable/equatable.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getMovieWatchlist;
  final GetWatchListStatus _getWatchListMovieStatus;
  final RemoveWatchlist _removeMovieWatchlist;
  final SaveWatchlist _saveMovieWatchlist;

  WatchlistMovieBloc(
    this._getMovieWatchlist,
    this._getWatchListMovieStatus,
    this._removeMovieWatchlist,
    this._saveMovieWatchlist,
  ) : super(WatchlistMoviesEmpty()) {
    on<MovieWatchlistLoad>(_loadMovieWatchlist);
    on<LoadMovieWatchlistStatus>(_loadMovieWatchlistStatus);
    on<AddToWatchlist>(_addMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_removeMovieFromWatchlist);
  }

  FutureOr<void> _loadMovieWatchlist(
    MovieWatchlistLoad event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(WatchlistMoviesLoading());

    final result = await _getMovieWatchlist.execute();

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(WatchlistMoviesEmpty())
            : emit(WatchlistMoviesLoaded(data));
      },
    );
  }

  Future<void> _removeMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _removeMovieWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (message) {
        emit(WatchlistMoviesMessage(message));
      },
    );
  }

  FutureOr<void> _loadMovieWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _getWatchListMovieStatus.execute(event.id);
    emit(MovieAddedToWatchlist(result));
  }

  Future<void> _addMovieToWatchlist(
    AddToWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _saveMovieWatchlist.execute(event.movie);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (message) {
        emit(WatchlistMoviesMessage(message));
      },
    );
  }
}
