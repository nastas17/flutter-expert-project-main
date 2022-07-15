import 'package:core/presentation/bloc/bloc_tv/tv_popular/tv_popular_bloc.dart';
import 'package:core/presentation/pages/tv_pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvPopularShowBloc extends Mock implements TvPopularBloc {}

class FakeEvent extends Fake implements TvPopularEvent {}

class FakeState extends Fake implements TvPopularState {}

void main() {
  late MockTvPopularShowBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeEvent());
    registerFallbackValue(FakeState());
  });

  setUp(() {
    bloc = MockTvPopularShowBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvPopularBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "Page should display center progress bar when loading",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer(((_) => Stream.value(TvPopularLoading())));
      when(() => bloc.state).thenReturn(TvPopularLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(progressBarFinder, findsOneWidget);
      expect(centerFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display ListView when data is loaded",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer(((_) => Stream.value(TvPopularHasData(tTvList))));
      when(() => bloc.state).thenReturn(TvPopularHasData(tTvList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display text with message when Error",
    (WidgetTester tester) async {
      when(() => bloc.stream)
          .thenAnswer(((_) => Stream.value(TvPopularError('Server Failure'))));
      when(() => bloc.state).thenReturn(TvPopularError('Server Failure'));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
