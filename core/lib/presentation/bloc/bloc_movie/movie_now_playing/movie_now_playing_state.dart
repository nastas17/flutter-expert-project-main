part of 'movie_now_playing_bloc.dart';

abstract class NowPlayingMoviesState extends Equatable {}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {
  @override
  List<Object> get props => [];
}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {
  @override
  List<Object> get props => [];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;

  NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> result;

  NowPlayingMoviesLoaded(this.result);

  @override
  List<Object> get props => [result];
}
