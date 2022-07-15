part of 'movie_recommendations_bloc.dart';

abstract class MovieRecomendationsState extends Equatable {
  const MovieRecomendationsState();

  @override
  List<Object> get props => [];
}

class MovieRecomendationsEmpty extends MovieRecomendationsState {}

class MovieRecomendationsLoading extends MovieRecomendationsState {}

class MovieRecomendationsLoaded extends MovieRecomendationsState {
  final List<Movie> result;

  MovieRecomendationsLoaded(this.result);
}

class MovieRecomendationsError extends MovieRecomendationsState {
  final String message;

  MovieRecomendationsError(this.message);
}
