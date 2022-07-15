import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_usecase/get_on_air_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_on_air_event.dart';
part 'tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState> {
  final GetOnTheAirTv _getTvOnAir;

  TvOnAirBloc(this._getTvOnAir) : super(TvOnAirEmpty()) {
    on<TvOnAirLoad>(_loadTvOnAir);
  }

  FutureOr<void> _loadTvOnAir(
    TvOnAirLoad event,
    Emitter<TvOnAirState> emit,
  ) async {
    emit(TvOnAirLoading());

    final result = await _getTvOnAir.execute();

    result.fold(
      (failure) {
        emit(TvOnAirError(failure.message));
      },
      (data) {
        data.isEmpty ? emit(TvOnAirEmpty()) : emit(TvOnAirLoaded(data));
      },
    );
  }
}
