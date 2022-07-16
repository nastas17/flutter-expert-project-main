import 'package:core/data/models/tv_model/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTvTable = TvTable(
      id: 1, name: 'name', posterPath: 'posterPath', overview: 'overview');

  group('toJson', () {
    test('should return a JSON map containing progres data', () async {
      // arrange

      // act
      final result = testTvTable.toJson();
      //asert
      final expected = {
        "id": 1,
        "name": 'name',
        "posterPath": 'posterPath',
        "overview": 'overview',
      };
      expect(result, expected);
    });
  });
}
