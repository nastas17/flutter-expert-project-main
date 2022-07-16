import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecase/search_tv.dart';
import 'package:search/presentation/bloc/tv/tv_searh_bloc/tv_search_bloc.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTvSeries mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTvSeries();
    tvSearchBloc = TvSearchBloc(mockSearchTv);
  });

  final tTvModel = TvSeries(
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
  final tTvList = <TvSeries>[tTvModel];
  final tQuery = 'moon knight';

  test('initial state should be empty', () {
    expect(tvSearchBloc.state, TvSearchEmpty());
  });
  blocTest<TvSearchBloc, TvSearchState>(
      'should emit [Loading, Loaded] when data is obtained sucessfulle',
      build: () {
        when(mockSearchTv.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return tvSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryTvChanged(tQuery)),
      wait: const Duration(milliseconds: 750),
      expect: () => [
            TvSearchLoading(),
            TvSearchLoaded(tTvList),
          ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
      });
}
