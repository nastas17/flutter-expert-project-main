import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  int id;
  int voteCount;
  int numberOfSeasons;
  int numberOfEpisodes;
  bool adult;
  String name;
  String type;
  String status;
  String homepage;
  String overview;
  double popularity;
  String posterPath;
  String backdropPath;
  String originalName;
  double voteAverage;
  List<Genre> genres;
  List<Season> seasons;
  List<dynamic> episodeRunTime;

  TvDetail({
    required this.id,
    required this.voteCount,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.adult,
    required this.name,
    required this.type,
    required this.status,
    required this.seasons,
    required this.homepage,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.originalName,
    required this.backdropPath,
    required this.voteAverage,
    required this.genres,
    required this.episodeRunTime,
  });

  @override
  List<Object?> get props => [
        id,
        voteCount,
        numberOfSeasons,
        numberOfEpisodes,
        adult,
        name,
        type,
        status,
        homepage,
        overview,
        popularity,
        posterPath,
        backdropPath,
        originalName,
        voteAverage,
        genres,
        seasons,
        episodeRunTime,
      ];
}
