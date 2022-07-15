part of 'movie_now_playing_bloc.dart';

abstract class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();
}

class NowPlayingMoviesLoad extends NowPlayingMoviesEvent {
  @override
  List<Object> get props => [];
}
