import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class SaveTvWatchlist {
  final TvRepository repository;

  SaveTvWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveTvWatchlist(tv);
  }
}
