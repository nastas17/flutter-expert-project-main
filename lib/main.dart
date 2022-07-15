import 'package:core/core.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:about/about_page.dart';
import 'package:core/presentation/pages/tv_pages/home_tv_page.dart';
import 'package:core/presentation/pages/tv_pages/popular_tv_page.dart';
import 'package:core/presentation/pages/tv_pages/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv_pages/tv_detail_page.dart';
import 'package:core/presentation/pages/tv_pages/watchlist_tv_page.dart';
import 'package:core/presentation/pages/movie_pages/movie_detail_page.dart';
import 'package:core/presentation/pages/movie_pages/home_movie_page.dart';
import 'package:core/presentation/pages/movie_pages/popular_movies_page.dart';
import 'package:core/presentation/pages/splash_screen.dart';
import 'package:core/presentation/pages/movie_pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/movie_pages/watchlist_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:search/presentation/bloc/tv/tv_searh/tv_search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:search/presentation/pages/tv_search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecomendationBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TvWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<TvPopularBloc>()),
        BlocProvider(create: (_) => di.locator<TvOnAirBloc>()),
        BlocProvider(create: (_) => di.locator<TvRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<TvTopRatedBloc>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TvWatchlistBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: SplashScreen(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return CupertinoPageRoute(builder: (_) => HomeMoviePage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return CupertinoPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case SplashScreen.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SplashScreen());
            case HomeMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => HomeTvPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => AboutPage());
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());

            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return CupertinoPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case WatchlistTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => WatchlistTvPage());
            case SearchPageTv.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageTv());

            default:
              return CupertinoPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
