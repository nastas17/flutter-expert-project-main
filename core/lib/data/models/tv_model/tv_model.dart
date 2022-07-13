import 'package:core/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvModel extends Equatable {
  TvModel({
    required this.id,
    required this.voteCount,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.originalName,
    required this.originalLanguage,
    required this.voteAverage,
    required this.genreIds,
    required this.originCountry,
    required this.popularity,
  });

  int id;
  int voteCount;
  String name;
  String overview;
  String posterPath;
  String backdropPath;
  String originalName;
  String originalLanguage;
  double popularity;
  double voteAverage;
  List<int> genreIds;
  List<String> originCountry;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        id: json["id"],
        voteCount: json["vote_count"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? '',
        backdropPath: json["backdrop_path"] ?? '',
        originalName: json["original_name"],
        originalLanguage: json["original_language"],
        voteAverage: json["vote_average"].toDouble(),
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        popularity: json["popularity"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vote_count": voteCount,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "original_name": originalName,
        "original_language": originalLanguage,
        "vote_average": voteAverage,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "popularity": popularity,
      };

  TvSeries toEntity() {
    return TvSeries(
        id: this.id,
        voteCount: this.voteCount,
        name: this.name,
        overview: this.overview,
        posterPath: this.posterPath,
        backdropPath: this.backdropPath,
        originalName: this.originalName,
        originalLanguage: this.originalLanguage,
        voteAverage: this.voteAverage,
        genreIds: this.genreIds,
        originCountry: this.originCountry,
        popularity: this.popularity);
  }

  @override
  List<Object?> get props => [
        id,
        voteCount,
        name,
        overview,
        posterPath,
        backdropPath,
        originalName,
        originalLanguage,
        voteAverage,
        genreIds,
        originCountry,
        popularity,
      ];
}
