part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {}

class TvDetailLoad extends TvDetailEvent {
  final int id;

  TvDetailLoad(this.id);

  @override
  List<Object> get props => [];
}
