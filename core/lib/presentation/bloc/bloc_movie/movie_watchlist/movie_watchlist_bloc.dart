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

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListMoviesStatus;
  final RemoveWatchlist _removeWatchlistMovies;
  final SaveWatchlist _saveWatchlistMovies;

  WatchlistMoviesBloc(
    this._getWatchlistMovies,
    this._getWatchListMoviesStatus,
    this._removeWatchlistMovies,
    this._saveWatchlistMovies,
  ) : super(WatchlistMoviesEmpty()) {
    on<MoviesWatchlistLoad>(_loadWatchlistMovies);
    on<LoadWatchlistMoviesStatus>(_loadWatchlistMoviesStatus);
    on<AddMovieToWatchlist>(_addMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_removeMovieFromWatchlist);
  }

  FutureOr<void> _loadWatchlistMovies(
    MoviesWatchlistLoad event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(WatchlistMoviesLoading());

    final result = await _getWatchlistMovies.execute();

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

  FutureOr<void> _loadWatchlistMoviesStatus(
    LoadWatchlistMoviesStatus event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _getWatchListMoviesStatus.execute(event.id);
    emit(MovieAddedToWatchlist(result));
  }

  Future<void> _addMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _saveWatchlistMovies.execute(event.movie);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (message) {
        emit(WatchlistMoviesMessage(message));
      },
    );
  }

  Future<void> _removeMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _removeWatchlistMovies.execute(event.movie);

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
