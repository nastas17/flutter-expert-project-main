import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie_usecase/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  final tMovie = <Movie>[];

  test('should get list of movies from repository', () async {
    // arrange
    when(mockMovieRepository.getTopRatedMovies())
        .thenAnswer((_) async => Right(tMovie));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovie));
  });
}
