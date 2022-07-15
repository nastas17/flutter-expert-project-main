import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie_usecase/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecomendationBloc
    extends Bloc<MovieRecomendationEvent, MovieRecomendationsState> {
  final GetMovieRecommendations getMovierecomandations;
  MovieRecomendationBloc({required this.getMovierecomandations})
      : super(MovieRecomendationsEmpty()) {
    on<MovieRecommendationLoad>((event, emit) async {
      emit(MovieRecomendationsLoading());
      final result = await getMovierecomandations.execute(event.id);

      result.fold(
        (failure) => emit(MovieRecomendationsError(failure.message)),
        (result) => emit(MovieRecomendationsLoaded(result)),
      );
    });
  }
}
