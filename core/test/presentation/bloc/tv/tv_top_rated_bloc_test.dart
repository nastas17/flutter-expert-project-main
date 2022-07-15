import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_top_rated_tv.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late TvTopRatedBloc seriesTopRatedBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    seriesTopRatedBloc = TvTopRatedBloc(mockGetTopRatedTv);
  });

  final tTv = TvSeries(
    backdropPath: "/9hp4JNejY6Ctg9i9ItkM9rd6GE7.jpg",
    genreIds: [10764],
    id: 12610,
    name: "Robinson",
    originCountry: ["SE"],
    originalLanguage: "sv",
    originalName: "Robinson",
    overview:
        "Expedition Robinson is a Swedish reality television program in which contestants are put into survival situations, and a voting process eliminates one person each episode until a winner is determined. The format was developed in 1994 by Charlie Parsons for a United Kingdom TV production company called Planet 24, but the Swedish debut in 1997 was the first production to actually make it to television.",
    popularity: 2338.977,
    posterPath: "/sWA0Uo9hkiAtvtjnPvaqfnulIIE.jpg",
    voteAverage: 5,
    voteCount: 3,
  );
  final tTvList = <TvSeries>[tTv];

  group('bloc top rated tv series testing', () {
    test('initial state should be empty', () {
      expect(seriesTopRatedBloc.state, TvTopRatedEmpty());
    });

    blocTest<TvTopRatedBloc, TvTopRatedState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return seriesTopRatedBloc;
      },
      act: (bloc) => bloc.add(TvTopRatedLoad()),
      expect: () => [
        TvTopRatedLoading(),
        TvTopRatedHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
        return TvTopRatedLoad().props;
      },
    );

    blocTest<TvTopRatedBloc, TvTopRatedState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return seriesTopRatedBloc;
      },
      act: (bloc) => bloc.add(TvTopRatedLoad()),
      expect: () => [
        TvTopRatedLoading(),
        TvTopRatedError('Server Failure'),
      ],
      verify: (bloc) => TvTopRatedLoading(),
    );
  });
}
