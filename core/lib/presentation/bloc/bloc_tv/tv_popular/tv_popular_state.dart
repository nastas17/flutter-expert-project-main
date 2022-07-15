part of 'tv_popular_bloc.dart';

abstract class TvPopularState extends Equatable {}

class TvPopularEmpty extends TvPopularState {
  @override
  List<Object> get props => [];
}

class TvPopularLoading extends TvPopularState {
  @override
  List<Object> get props => [];
}

class TvPopularError extends TvPopularState {
  final String message;

  TvPopularError(this.message);

  @override
  List<Object> get props => [message];
}

class TvPopularLoaded extends TvPopularState {
  final List<TvSeries> result;

  TvPopularLoaded(this.result);

  @override
  List<Object> get props => [result];
}
