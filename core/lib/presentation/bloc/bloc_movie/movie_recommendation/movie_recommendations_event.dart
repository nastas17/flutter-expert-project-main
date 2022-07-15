part of 'movie_recommendations_bloc.dart';

abstract class MovieRecommendationsEvent extends Equatable {}

abstract class MovieRecomendationEvent extends Equatable {
  const MovieRecomendationEvent();

  @override
  List<Object> get props => [];
}

class MovieRecommendationLoad extends MovieRecomendationEvent {
  final int id;

  MovieRecommendationLoad(this.id);
}
