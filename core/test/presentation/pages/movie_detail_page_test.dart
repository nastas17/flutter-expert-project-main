import 'package:core/presentation/bloc/bloc_movie/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_recommendation/movie_recommendations_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeMovieDetailBloc extends Mock implements MovieDetailBloc {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class FakeRecomendationMovieBloc extends Mock
    implements MovieRecomendationBloc {}

class RecomendationMovieStateFake extends Fake
    implements MovieRecomendationsState {}

class RecomendationMovieEventFake extends Fake
    implements MovieRecomendationEvent {}

void main() {
  late FakeMovieDetailBloc mockMovieDetailBloc;
  late FakeRecomendationMovieBloc mockRecomendationMovieBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(RecomendationMovieStateFake());
    registerFallbackValue(RecomendationMovieEventFake());
  });

  setUp(() {
    mockMovieDetailBloc = FakeMovieDetailBloc();
    mockRecomendationMovieBloc = FakeRecomendationMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecomendationBloc>.value(
            value: mockRecomendationMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }
}
