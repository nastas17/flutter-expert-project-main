part of 'tv_recommendations_bloc.dart';

abstract class TvRecommendationsEvent extends Equatable {}

class LoadTvRecommendations extends TvRecommendationsEvent {
  final int id;

  LoadTvRecommendations(this.id);

  @override
  List<Object> get props => [];
}
