import 'package:core/data/models/movie_model/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  final testMovieTable = MovieTable(
      id: 1, title: 'title', posterPath: 'posterPath', overview: 'overview');

  group('toJson', () {
    test('should return a JSON map containing progres data', () async {
      // arrange

      // act
      final result = testMovieTable.toJson();
      //asert
      final expected = {
        "id": 1,
        "title": 'title',
        "posterPath": 'posterPath',
        "overview": 'overview',
      };
      expect(result, expected);
    });
  });
}
