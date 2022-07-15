part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {}

class AddTvToWatchlist extends TvWatchlistEvent {
  final TvDetail tv;

  AddTvToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class TvWatchlistLoad extends TvWatchlistEvent {
  @override
  List<Object> get props => [];
}

class LoadTvWatchlistStatus extends TvWatchlistEvent {
  final int id;

  LoadTvWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class RemoveTvFromWatchlist extends TvWatchlistEvent {
  final TvDetail tv;

  RemoveTvFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
