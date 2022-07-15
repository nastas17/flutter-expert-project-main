part of 'movie_watchlist_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {}

class AddToWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  AddToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class MovieWatchlistLoad extends WatchlistMovieEvent {
  @override
  List<Object> get props => [];
}

class LoadMovieWatchlistStatus extends WatchlistMovieEvent {
  final int id;

  LoadMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveMovieFromWatchlist extends WatchlistMovieEvent {
  final MovieDetail movie;

  RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

