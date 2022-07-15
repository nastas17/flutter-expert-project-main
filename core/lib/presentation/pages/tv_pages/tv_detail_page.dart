import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:core/presentation/bloc/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(TvDetailLoad(widget.id));
      context
          .read<TvRecommendationsBloc>()
          .add(LoadTvRecommendations(widget.id));
      context.read<TvWatchlistBloc>().add(LoadTvWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final seriesWatchlistStatus = context.select<TvWatchlistBloc, bool>((bloc) {
      if (bloc.state is TvAddedToWatchlist) {
        return (bloc.state as TvAddedToWatchlist).isTvAddedToWatchlist;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailLoaded) {
            final tv = state.result;
            return SafeArea(
              child: DetailContent(
                tv,
                seriesWatchlistStatus,
              ),
            );
          } else {
            return Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TvDetail tv;
  final bool isTvAddedToWatchlist;

  DetailContent(this.tv, this.isTvAddedToWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  late bool isTvAddedToWatchlist = widget.isTvAddedToWatchlist;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${widget.tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: const CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isTvAddedToWatchlist) {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(AddTvToWatchlist(widget.tv));
                                } else {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(RemoveTvFromWatchlist(widget.tv));
                                }
                                final state =
                                    BlocProvider.of<TvWatchlistBloc>(context)
                                        .state;
                                String message = '';
                                if (state is TvAddedToWatchlist) {
                                  final isTvAddedToWatchlist =
                                      state.isTvAddedToWatchlist;
                                  message = isTvAddedToWatchlist == false
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist';
                                } else {
                                  message = !isTvAddedToWatchlist
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist';
                                }

                                if (message == 'Added to Watchlist' ||
                                    message == 'Removed from Watchlist') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                                setState(() {
                                  isTvAddedToWatchlist = !isTvAddedToWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isTvAddedToWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres),
                            ),
                            Text(
                              _formattedDuration(widget.tv.episodeRunTime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Total Episodes: ' +
                                  widget.tv.numberOfEpisodes.toString(),
                              style: kHeading6,
                            ),
                            Text(
                              'Season ' + widget.tv.numberOfSeasons.toString(),
                              style: kHeading6,
                            ),
                            if (widget.tv.seasons.isEmpty)
                              Container(
                                child: const Text(
                                  'There is no Season',
                                ),
                              )
                            else
                              Column(
                                children: <Widget>[
                                  widget.tv.seasons.isNotEmpty
                                      ? Container(
                                          height: 150,
                                          margin:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (ctx, index) {
                                              final season =
                                                  widget.tv.seasons[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  child: season.posterPath ==
                                                          null
                                                      ? Container(
                                                          width: 96.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: kGrey,
                                                          ),
                                                          child: const Center(
                                                            child: const Icon(
                                                              Icons.hide_image,
                                                            ),
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              '$BASE_IMAGE_URL${widget.tv.posterPath}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                ),
                                              );
                                            },
                                            itemCount: widget.tv.seasons.length,
                                          ),
                                        )
                                      : const Text('-'),
                                ],
                              ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 20),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview,
                            ),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc,
                                TvRecommendationsState>(
                              builder: (context, state) {
                                if (state is TvRecommendationsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationsError) {
                                  return Text(state.message);
                                } else if (state is TvRecommendationsLoaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final series = state.result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: series.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _formattedDuration(List<int> runtimes) =>
      runtimes.map((runtime) => _showDuration(runtime)).join(", ");

  // Widget _buildRecommendationsTvItem(
  //   BuildContext context,
  // ) {
  //   return Container(
  //     height: 150,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         final tvRecommendations = recommendations[index];
  //         return Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: InkWell(
  //             onTap: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 TvDetailPage.ROUTE_NAME,
  //                 arguments: tvRecommendations.id,
  //               );
  //             },
  //             child: ClipRRect(
  //               borderRadius: const BorderRadius.all(
  //                 Radius.circular(8),
  //               ),
  //               child: CachedNetworkImage(
  //                 imageUrl: '$BASE_IMAGE_URL${tvRecommendations.posterPath}',
  //                 placeholder: (context, url) => const Center(
  //                   child: const CircularProgressIndicator(),
  //                 ),
  //                 errorWidget: (context, url, error) => const Icon(Icons.error),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: recommendations.length,
  //     ),
  //   );
  // }
}
