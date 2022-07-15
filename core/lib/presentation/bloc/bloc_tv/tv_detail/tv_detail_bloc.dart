import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/usecases/tv_usecase/get_tv_detail.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;

  TvDetailBloc(this._getTvDetail) : super(TvDetailEmpty()) {
    on<TvDetailLoad>(_loadTvDetail);
  }

  FutureOr<void> _loadTvDetail(
    TvDetailLoad event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(TvDetailLoading());

    final result = await _getTvDetail.execute(event.id);

    result.fold(
      (failure) {
        emit(TvDetailError(failure.message));
      },
      (data) {
        emit(TvDetailHasData(data));
      },
    );
  }
}
