import 'package:core/presentation/bloc/bloc_tv/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:core/presentation/pages/tv_pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTvShowBloc extends Mock implements TvTopRatedBloc {}

class FakeEvent extends Fake implements TvTopRatedEvent {}

class FakeState extends Fake implements TvTopRatedState {}

void main() {
  late MockTopRatedTvShowBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeState());
  });

  setUp(() {
    bloc = MockTopRatedTvShowBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvTopRatedBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "Page should display progress bar when loading",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer((_) => Stream.value(TvTopRatedLoading()));
      when(() => bloc.state).thenReturn(TvTopRatedLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display when data is loaded",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer((_) => Stream.value(TvTopRatedHasData(tTvList)));
      when(() => bloc.state).thenReturn(TvTopRatedHasData(tTvList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display text with message when Error",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer((_) => Stream.value(TvTopRatedError(tError)));
      when(() => bloc.state).thenReturn(TvTopRatedError(tError));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
