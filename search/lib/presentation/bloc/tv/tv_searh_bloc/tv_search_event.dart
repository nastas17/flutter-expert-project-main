part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryTvChanged extends TvSearchEvent {
  final String query;

  OnQueryTvChanged(this.query);

  @override
  List<Object> get props => [query];
}
