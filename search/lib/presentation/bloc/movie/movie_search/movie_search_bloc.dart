import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:search/domain/usecase/search_movies.dart';
import '../../../../domain/usecase/search_movies.dart';
import 'package:rxdart/transformers.dart';
import 'package:bloc/bloc.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  MovieSearchBloc(this._searchMovies) : super(MovieSearchEmpty()) {
    on<OnQueryMovieChanged>((event, emit) async {
      final query = event.query;

      emit(MovieSearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(MovieSearchError(failure.message));
        },
        (data) {
          emit(MovieSearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 750)));
  }
}
