part of 'tv_on_air_bloc.dart';

abstract class TvOnAirState extends Equatable {}

class TvOnAirEmpty extends TvOnAirState {
  @override
  List<Object> get props => [];
}

class TvOnAirLoading extends TvOnAirState {
  @override
  List<Object> get props => [];
}

class TvOnAirError extends TvOnAirState {
  final String message;

  TvOnAirError(this.message);

  @override
  List<Object> get props => [message];
}

class TvOnAirHasData extends TvOnAirState {
  final List<TvSeries> result;

  TvOnAirHasData(this.result);

  @override
  List<Object> get props => [result];
}
