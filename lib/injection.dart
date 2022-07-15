import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/movie_usecase/get_movie_detail.dart';
import 'package:core/domain/usecases/movie_usecase/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie_usecase/get_now_playing_movies.dart';
import 'package:core/domain/usecases/tv_usecase/get_on_air_tv.dart';
import 'package:core/domain/usecases/movie_usecase/get_popular_movies.dart';
import 'package:core/domain/usecases/tv_usecase/get_popular_tv.dart';
import 'package:core/domain/usecases/movie_usecase/get_top_rated_movies.dart';
import 'package:core/domain/usecases/tv_usecase/get_top_rated_tv.dart';
import 'package:core/domain/usecases/tv_usecase/get_tv_detail.dart';
import 'package:core/domain/usecases/tv_usecase/get_tv_recommendations.dart';
import 'package:core/domain/usecases/movie_usecase/get_watchlist_movies.dart';
import 'package:core/domain/usecases/movie_usecase/get_watchlist_status.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_usecase/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/tv_usecase/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/movie_usecase/remove_watchlist.dart';
import 'package:core/domain/usecases/tv_usecase/save_tv_watchlist.dart';
import 'package:core/domain/usecases/movie_usecase/save_watchlist.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_popular/movie_popular_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_recommendation/movie_recommendations_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:core/presentation/bloc/bloc_movie/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_on_air/tv_on_air_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_popular/tv_popular_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:search/search.dart';

final locator = GetIt.instance;

void init() {
  // bloc movie
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(() => TvDetailBloc(locator()));
  locator.registerFactory(() => TvOnAirBloc(locator()));
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(
      () => MovieRecomendationBloc(getMovierecomandations: locator()));
  locator.registerFactory(() => TvRecommendationsBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(getPopularMovies: locator()));
  locator.registerFactory(() => TvPopularBloc(locator()));
  locator.registerFactory(() => TvSearchBloc(locator()));
  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator
      .registerFactory(() => TopRatedMoviesBloc(getTopRatedMovies: locator()));
  locator.registerFactory(() => TvTopRatedBloc(locator()));
  locator.registerFactory(
    () => TvWatchlistBloc(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieBloc(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  //usecase tv
  locator.registerLazySingleton(() => GetOnTheAirTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  //repository tv
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  //data sources tv
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
