import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import '../../../utils/failure.dart';

class GetOnTheAirTv {
  final TvRepository repository;

  GetOnTheAirTv(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getOnTheAirTv();
  }
}
