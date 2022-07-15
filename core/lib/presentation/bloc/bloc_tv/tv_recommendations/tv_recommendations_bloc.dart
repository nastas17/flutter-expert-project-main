import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_recommendations_event.dart';
part 'tv_recommendations_state.dart';

class TvRecommendationsBloc
    extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvRecommendations _getTvRecommendations;

  TvRecommendationsBloc(this._getTvRecommendations)
      : super(TvRecommendationsEmpty()) {
    on<LoadTvRecommendations>(_loadTvRecommendations);
  }

  FutureOr<void> _loadTvRecommendations(
    LoadTvRecommendations event,
    Emitter<TvRecommendationsState> emit,
  ) async {
    emit(TvRecommendationsLoading());

    final result = await _getTvRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(TvRecommendationsError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(TvRecommendationsEmpty())
            : emit(TvRecommendationsLoaded(data));
      },
    );
  }
}
