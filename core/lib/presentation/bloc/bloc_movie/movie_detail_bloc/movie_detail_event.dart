part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {}

class MoviesDetailLoad extends MovieDetailEvent {
  final int id;

  MoviesDetailLoad(this.id);

  @override
  List<Object> get props => [];
}
