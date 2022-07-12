import 'package:flutter/material.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvStatus getWatchListStatusTv;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvFromWatchlist;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatusTv,
    required this.saveTvWatchlist,
    required this.removeTvFromWatchlist,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TvSeries> _tvRecommendations = [];
  List<TvSeries> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationStateTv = RequestState.Empty;
  RequestState get recommendationStateTv => _recommendationStateTv;

  String _message = '';
  String get message => _message;

  bool _isTvAddedToWatchlist = false;
  bool get isTvAddedToWatchlist => _isTvAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationStateTv = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationStateTv = RequestState.Error;
            _message = failure.message;
          },
          (tv) {
            _recommendationStateTv = RequestState.Loaded;
            _tvRecommendations = tv;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> insertTvWatchlist(TvDetail tv) async {
    final result = await saveTvWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeTvFromWatchlist.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTv.execute(id);
    _isTvAddedToWatchlist = result;
    notifyListeners();
  }
}
