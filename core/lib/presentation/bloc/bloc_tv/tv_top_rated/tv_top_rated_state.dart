part of 'tv_top_rated_bloc.dart';

abstract class TvTopRatedState extends Equatable {}

class TvTopRatedError extends TvTopRatedState {
  final String message;
  TvTopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TvTopRatedLoading extends TvTopRatedState {
  @override
  List<Object> get props => [];
}

class TvTopRatedEmpty extends TvTopRatedState {
  @override
  List<Object> get props => [];
}

class TvTopRatedHasData extends TvTopRatedState {
  final List<TvSeries> result;

  TvTopRatedHasData(this.result);

  @override
  List<Object> get props => [result];
}
