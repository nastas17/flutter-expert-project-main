import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/season.dart';

class SeasonTvModel extends Equatable {
  final int id;
  final String name;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;

  SeasonTvModel({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
  });

  factory SeasonTvModel.fromJson(Map<String, dynamic> json) => SeasonTvModel(
        id: json['id'],
        name: json['name'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
        episodeCount: json['episode_count'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "poster_path": posterPath,
        "season_number": seasonNumber,
        "episode_count": episodeCount,
      };

  Season toEntity() => Season(
        id: this.id,
        name: this.name,
        posterPath: this.posterPath,
        seasonNumber: this.seasonNumber,
        episodeCount: this.episodeCount,
      );

  @override
  List<Object?> get props => [id, name, posterPath, seasonNumber, episodeCount];
}
