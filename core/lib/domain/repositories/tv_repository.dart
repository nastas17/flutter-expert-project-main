import 'package:dartz/dartz.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tvseries_detail.dart';
import '../../utils/failure.dart';

abstract class TvRepository {
  Future<Either<Failure, List<TvSeries>>> getOnTheAirTv();
  Future<Either<Failure, List<TvSeries>>> getPopularTv();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTv(String query);
  Future<Either<Failure, String>> saveTvWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeTvFromWatchlist(TvDetail tv);
  Future<bool> isTvAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getTvWatchlist();
}
