import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_top_rated_event.dart';
part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTv _getTvTopRated;

  TvTopRatedBloc(this._getTvTopRated) : super(TvTopRatedEmpty()) {
    on<TvTopRatedLoad>(_loadTvTopRated);
  }

  FutureOr<void> _loadTvTopRated(
    TvTopRatedLoad event,
    Emitter<TvTopRatedState> emit,
  ) async {
    emit(TvTopRatedLoading());

    final result = await _getTvTopRated.execute();

    result.fold(
      (failure) {
        emit(TvTopRatedError(failure.message));
      },
      (data) {
        data.isEmpty ? emit(TvTopRatedEmpty()) : emit(TvTopRatedHasData(data));
      },
    );
  }
}
