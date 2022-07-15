import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/tv_usecase/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv_usecase/save_tv_watchlist.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTv,
  GetWatchListTvStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvWatchlistBloc = TvWatchlistBloc(
      mockGetWatchlistTv,
      mockGetWatchListTvStatus,
      mockRemoveTvWatchlist,
      mockSaveTvWatchlist,
    );
  });

  final tId = 1;

  final testTvDetail = TvDetail(
    adult: false,
    backdropPath: "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg",
    episodeRunTime: [42],
    genres: [Genre(id: 18, name: 'Drama')],
    homepage: "https://www.telemundo.com/shows/pasion-de-gavilanes",
    id: 1,
    name: "name",
    numberOfEpisodes: 259,
    numberOfSeasons: 2,
    originalName: "Pasión de gavilanes",
    overview: "overview",
    popularity: 1747.047,
    posterPath: "posterPath",
    seasons: [
      Season(
        episodeCount: 188,
        id: 72643,
        name: "Season 1",
        posterPath: "/elrDXqvMIX3EcExwCenQMVVmnvd.jpg",
        seasonNumber: 1,
      )
    ],
    status: "Returning Series",
    type: "Scripted",
    voteAverage: 7.6,
    voteCount: 1803,
  );

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

  group('bloc watch list tv testing', () {
    test('initial state should be empty', () {
      expect(tvWatchlistBloc.state, TvWatchlistEmpty());
    });

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistLoad()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistHasData(tTvList),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
        return TvWatchlistLoad().props;
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvWatchlistLoad()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistError('Server Failure'),
      ],
      verify: (bloc) => TvWatchlistLoading(),
    );
  });

  group('bloc status watch list tv testing', () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetWatchListTvStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadTvWatchlistStatus(tId)),
      expect: () => [TvAddedToWatchlist(false)],
      verify: (bloc) => TvWatchlistLoading(),
    );
  });

  // group('bloc add watch list tv testing', () {
  //   blocTest<TvWatchlistBloc, TvWatchlistState>(
  //     'Should emit [Loading, HasData] when data is gotten successfully',
  //     build: () {
  //       when(mockSaveTvWatchlist.execute(testTvDetail))
  //           .thenAnswer((_) async => Right('Added to Watchlist'));
  //       return tvWatchlistBloc;
  //     },
  //     act: (bloc) => bloc.add(AddTvToWatchlist(testTvDetail)),
  //     expect: () => [
  //       TvWatchlistLoading(),
  //       TvWatchlistMessage('Added to Watchlist'),
  //     ],
  //     verify: (bloc) {
  //       verify(mockSaveTvWatchlist.execute(testTvDetail));
  //       return AddTvToWatchlist(testTvDetail).props;
  //     },
  //   );

  //   group('bloc remove watch list tv testing', () {
  //     blocTest<TvWatchlistBloc, TvWatchlistState>(
  //       'Should emit [Loading, HasData] when data is gotten successfully',
  //       build: () {
  //         when(mockRemoveTvWatchlist.execute(testTvDetail))
  //             .thenAnswer((_) async => Right('Delete to Watchlist'));
  //         return tvWatchlistBloc;
  //       },
  //       act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
  //       expect: () => [
  //         TvWatchlistMessage('Delete to Watchlist'),
  //       ],
  //       verify: (bloc) {
  //         verify(mockRemoveTvWatchlist.execute(testTvDetail));
  //         return RemoveTvFromWatchlist(testTvDetail).props;
  //       },
  //     );

  //     blocTest<TvWatchlistBloc, TvWatchlistState>(
  //       'Should emit [Loading, Error] when get search is unsuccessful',
  //       build: () {
  //         when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer(
  //             (_) async => Left(DatabaseFailure('Delete to Watchlist Fail')));
  //         return tvWatchlistBloc;
  //       },
  //       act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
  //       expect: () => [
  //         TvWatchlistError('Delete to Watchlist Fail'),
  //       ],
  //       verify: (bloc) => RemoveTvFromWatchlist(testTvDetail),
  //     );
  //   });
  // });
}
