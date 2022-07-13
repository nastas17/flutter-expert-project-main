import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class RemoveTvWatchlist {
  final TvRepository repository;

  RemoveTvWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeTvFromWatchlist(tv);
  }
}
