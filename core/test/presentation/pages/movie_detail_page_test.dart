import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_recommendation/movie_recommendations_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:core/presentation/pages/movie_pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class FakeRecomendationMovieBloc
    extends MockBloc<MovieRecomendationEvent, MovieRecomendationsState>
    implements MovieRecomendationBloc {}

class RecomendationMovieStateFake extends Fake
    implements MovieRecomendationsState {}

class RecomendationMovieEventFake extends Fake
    implements MovieRecomendationEvent {}

class MovieRecommendationsEventFake extends Fake
    implements MovieRecommendationsEvent {}

class MovieRecommendationsStateFake extends Fake
    implements MovieRecomendationsState {}

class FakeMovieDetailWatchlistBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMoviesState>
    implements WatchlistMovieBloc {}

class MovieDetailWatchlistEventFake extends Fake
    implements WatchlistMovieEvent {}

class MovieDetailWatchlistStateFake extends Fake
    implements WatchlistMoviesState {}

void main() {
  late MovieDetailBloc movieBloc;
  late MovieRecomendationBloc movieRecommendationBloc;
  late WatchlistMovieBloc movieWatchlistBloc;

  setUp(() {
    movieBloc = FakeMovieDetailBloc();
    movieRecommendationBloc = FakeRecomendationMovieBloc();
    movieWatchlistBloc = FakeMovieDetailWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(
          value: movieBloc,
        ),
        BlocProvider<MovieRecomendationBloc>.value(
            value: movieRecommendationBloc),
        BlocProvider<WatchlistMovieBloc>.value(
          value: movieWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => movieRecommendationBloc.state)
        .thenReturn(MovieRecomendationsLoaded(testMovieList));
    when(() => movieWatchlistBloc.state)
        .thenReturn(MovieAddedToWatchlist(true));
    when(() => movieWatchlistBloc.state)
        .thenReturn(WatchlistMoviesMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => movieRecommendationBloc.state)
        .thenReturn(MovieRecomendationsLoaded(const <Movie>[]));
    when(() => movieWatchlistBloc.state)
        .thenReturn(MovieWatchlistStatusLoaded(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieBloc.state).thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => movieRecommendationBloc.state)
        .thenReturn(MovieRecomendationsLoaded(testMovieList));
    when(() => movieWatchlistBloc.state)
        .thenReturn(MovieAddedToWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
