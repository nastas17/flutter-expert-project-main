import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_on_air_tv.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_on_air/tv_on_air_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_air_tv_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTv])
void main() {
  late TvOnAirBloc onAirTvBloc;
  late MockGetOnTheAirTv mockTvOnAir;

  setUp(() {
    mockTvOnAir = MockGetOnTheAirTv();
    onAirTvBloc = TvOnAirBloc(mockTvOnAir);
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

  group('bloc airing today tv series testing', () {
    test('initial state should be empty', () {
      expect(onAirTvBloc.state, TvOnAirEmpty());
    });

    blocTest<TvOnAirBloc, TvOnAirState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockTvOnAir.execute()).thenAnswer((_) async => Right(tTvList));
        return onAirTvBloc;
      },
      act: (bloc) => bloc.add(TvOnAirLoad()),
      expect: () => [
        TvOnAirLoading(),
        TvOnAirLoaded(tTvList),
      ],
      verify: (bloc) {
        verify(mockTvOnAir.execute());
        return TvOnAirLoad().props;
      },
    );

    blocTest<TvOnAirBloc, TvOnAirState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockTvOnAir.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return onAirTvBloc;
      },
      act: (bloc) => bloc.add(TvOnAirLoad()),
      expect: () => [
        TvOnAirLoading(),
        TvOnAirError('Server Failure'),
      ],
      verify: (bloc) => TvOnAirLoading(),
    );
  });
}
