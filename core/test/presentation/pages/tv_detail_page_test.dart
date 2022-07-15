import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:core/presentation/pages/tv_pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class FakeTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class FakeTvRecommendationsBloc
    extends MockBloc<TvRecommendationsEvent, TvRecommendationsState>
    implements TvRecommendationsBloc {}

class FakeWatchlistTvBloc extends MockBloc<TvWatchlistEvent, TvWatchlistState>
    implements TvWatchlistBloc {}

void main() {
  late FakeTvDetailBloc fakeTvDetailBloc;
  late FakeTvRecommendationsBloc fakeTvRecommendationsBloc;
  late FakeWatchlistTvBloc fakeWatchlistTvBloc;

  setUpAll(() {
    fakeTvDetailBloc = FakeTvDetailBloc();
    fakeTvRecommendationsBloc = FakeTvRecommendationsBloc();
    fakeWatchlistTvBloc = FakeWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (_) => fakeTvDetailBloc,
        ),
        BlocProvider<TvRecommendationsBloc>(
          create: (_) => fakeTvRecommendationsBloc,
        ),
        BlocProvider<TvWatchlistBloc>(
          create: (_) => fakeWatchlistTvBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeWatchlistTvBloc.state).thenReturn(TvAddedToWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeWatchlistTvBloc.state).thenReturn(TvAddedToWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeTvDetailBloc.state)
        .thenReturn(TvDetailHasData(testTvDetail));
    when(() => fakeTvRecommendationsBloc.state)
        .thenReturn(TvRecommendationsHasData(tTvList));
    when(() => fakeWatchlistTvBloc.state).thenReturn(TvAddedToWatchlist(true));
    when(() => fakeWatchlistTvBloc.state)
        .thenReturn(TvWatchlistMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
