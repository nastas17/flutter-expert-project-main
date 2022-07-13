import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/tv_test_helper.mocks.dart';

void main() {
  late GetWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTv(mockTvRepository);
  });

  test('should get list of TV Series from the repository', () async {
    // arrange
    when(mockTvRepository.getTvWatchlist())
        .thenAnswer((_) async => Right(testTvSerieslList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvSerieslList));
  });
}
