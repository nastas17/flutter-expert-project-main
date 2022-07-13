import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class GetPopularTv {
  final TvRepository repository;

  GetPopularTv(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getPopularTv();
  }
}
