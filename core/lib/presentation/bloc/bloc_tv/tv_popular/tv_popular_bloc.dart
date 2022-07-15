import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTv _getTvPopular;

  TvPopularBloc(this._getTvPopular) : super(TvPopularEmpty()) {
    on<LoadTvPopular>(_loadTvPopular);
  }

  FutureOr<void> _loadTvPopular(
    LoadTvPopular event,
    Emitter<TvPopularState> emit,
  ) async {
    emit(TvPopularLoading());

    final result = await _getTvPopular.execute();

    result.fold(
      (failure) {
        emit(TvPopularError(failure.message));
      },
      (data) {
        data.isEmpty ? emit(TvPopularEmpty()) : emit(TvPopularHasData(data));
      },
    );
  }
}
