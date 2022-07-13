import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import '../../../utils/failure.dart';

class GetTvDetail {
  final TvRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
