part of 'movie_watchlist_bloc.dart';

abstract class WatchlistMoviesEvent extends Equatable {}

class MoviesWatchlistLoad extends WatchlistMoviesEvent {
  @override
  List<Object> get props => [];
}

class LoadWatchlistMoviesStatus extends WatchlistMoviesEvent {
  final int id;

  LoadWatchlistMoviesStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends WatchlistMoviesEvent {
  final MovieDetail movie;

  AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistMoviesEvent {
  final MovieDetail movie;

  RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnQueryMovieChanged extends WatchlistMoviesEvent {
  final String query;

  OnQueryMovieChanged(this.query);

  @override
  List<Object> get props => [query];
}
