part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {}

class TvWatchlistLoaded extends TvWatchlistState {
  final List<TvSeries> result;

  TvWatchlistLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvWatchlistEmpty extends TvWatchlistState {
  @override
  List<Object> get props => [];
}

class TvWatchlistLoading extends TvWatchlistState {
  @override
  List<Object> get props => [];
}

class TvWatchlistMessage extends TvWatchlistState {
  final String message;

  TvWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TvAddedToWatchlist extends TvWatchlistState {
  final bool isTvAddedToWatchlist;

  TvAddedToWatchlist(this.isTvAddedToWatchlist);

  @override
  List<Object> get props => [isTvAddedToWatchlist];
}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
