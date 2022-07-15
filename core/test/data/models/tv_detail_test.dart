import 'package:core/data/models/movie_model/genre_model.dart';
import 'package:core/data/models/tv_model/season_model.dart';
import 'package:core/data/models/tv_model/tv_detail.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvResponse = TvDetailResponse(
    adult: false,
    backdropPath: "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg",
    episodeRunTime: [42],
    genres: [GenreModel(id: 18, name: 'Drama')],
    homepage: "https://www.telemundo.com/shows/pasion-de-gavilanes",
    id: 1,
    name: "name",
    numberOfEpisodes: 259,
    numberOfSeasons: 2,
    originalName: "Pasión de gavilanes",
    overview: "overview",
    popularity: 1747.047,
    posterPath: "posterPath",
    seasons: [
      SeasonTvModel(
        episodeCount: 188,
        id: 72643,
        name: "Season 1",
        posterPath: "/elrDXqvMIX3EcExwCenQMVVmnvd.jpg",
        seasonNumber: 1,
      )
    ],
    status: "Returning Series",
    type: "Script",
    voteAverage: 7.6,
    voteCount: 1803,
  );

  group('toJson', () {
    test('should return a JSON map containing progres data', () async {
      final result = tTvResponse.toJson();
      final expected = {
        'adult': false,
        'backdrop_path': "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg",
        'episode_run_time': [42],
        'genres': [
          {'id': 18, 'name': 'Drama'}
        ],
        'homepage': "https://www.telemundo.com/shows/pasion-de-gavilanes",
        'id': 1,
        'name': 'name',
        'number_of_episodes': 259,
        'number_of_seasons': 2,
        'original_name': 'Pasión de gavilanes',
        'overview': 'overview',
        'popularity': 1747.047,
        'poster_path': 'posterPath',
        'seasons': [
          {
            'id': 72643,
            'name': 'Season 1',
            'poster_path': '/elrDXqvMIX3EcExwCenQMVVmnvd.jpg',
            'season_number': 1,
            'episode_count': 188
          }
        ],
        'status': 'Returning Series',
        'type': 'Script',
        'vote_average': 7.6,
        'vote_count': 1803,
      };
      expect(result, expected);
    });
  });
}
