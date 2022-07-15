import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/movie_usecase/get_movie_recommendations.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_recommendation/movie_recommendations_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations usecase;
  late MovieRecomendationBloc bloc;

  setUp(() {
    usecase = MockGetMovieRecommendations();
    bloc = MovieRecomendationBloc(getMovierecomandations: usecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, MovieRecomendationsEmpty());
  });

  blocTest<MovieRecomendationBloc, MovieRecomendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(usecase.execute(tId)).thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(MovieRecommendationLoad(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieRecomendationsLoading(),
      MovieRecomendationsLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(usecase.execute(tId));
    },
  );

  blocTest<MovieRecomendationBloc, MovieRecomendationsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(usecase.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(MovieRecommendationLoad(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieRecomendationsLoading(),
      MovieRecomendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(usecase.execute(tId));
    },
  );
}
