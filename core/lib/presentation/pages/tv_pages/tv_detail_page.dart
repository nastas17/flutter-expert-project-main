import 'package:cached_network_image/cached_network_image.dart';
import '../../../core.dart';
import '../../../utils/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tvseries_detail.dart';
import '../../../presentation/provider/tv_detail_notifier.dart';
import '../../../utils/state_enum.dart';
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
      Provider.of<TvDetailNotifier>(context, listen: false)
          .fetchTvDetail(widget.id);
      Provider.of<TvDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else if (provider.tvState == RequestState.Loaded) {
            final series = provider.tv;
            return SafeArea(
              child: DetailContent(
                series,
                provider.tvRecommendations,
                provider.isTvAddedToWatchlist,
                provider,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<TvSeries> recommendations;
  final bool isTvAddedWatchlist;
  final TvDetailNotifier provider;

  DetailContent(
      this.tv, this.recommendations, this.isTvAddedWatchlist, this.provider);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
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
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isTvAddedWatchlist) {
                                  await Provider.of<TvDetailNotifier>(context,
                                          listen: false)
                                      .insertTvWatchlist(tv);
                                } else {
                                  await Provider.of<TvDetailNotifier>(context,
                                          listen: false)
                                      .removeFromWatchlist(tv);
                                }

                                final message = Provider.of<TvDetailNotifier>(
                                        context,
                                        listen: false)
                                    .watchlistMessage;

                                if (message ==
                                        TvDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
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
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isTvAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              _formattedDuration(tv.episodeRunTime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Total Episodes: ' +
                                  tv.numberOfEpisodes.toString(),
                              style: kHeading6,
                            ),
                            Text(
                              'Season ' + tv.numberOfSeasons.toString(),
                              style: kHeading6,
                            ),
                            if (provider.tv.seasons.isEmpty)
                              Container(
                                child: const Text(
                                  'There is no Season',
                                ),
                              )
                            else
                              Column(
                                children: <Widget>[
                                  tv.seasons.isNotEmpty
                                      ? Container(
                                          height: 150,
                                          margin:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (ctx, index) {
                                              final season = tv.seasons[index];
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
                                                              '$BASE_IMAGE_URL${season.posterPath}',
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
                                            itemCount: tv.seasons.length,
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
                              tv.overview,
                            ),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            if (provider.tvRecommendations.isEmpty)
                              Container(
                                child: const Text(
                                  'There is no recommendations',
                                ),
                              )
                            else
                              Consumer<TvDetailNotifier>(
                                builder: (context, data, child) {
                                  if (data.recommendationStateTv ==
                                      RequestState.Loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (data.recommendationStateTv ==
                                      RequestState.Error) {
                                    return Text(data.message);
                                  } else if (data.recommendationStateTv ==
                                      RequestState.Loaded) {
                                    return SizedBox(
                                      child: Column(
                                        children: <Widget>[
                                          _buildRecommendationsTvItem(context),
                                        ],
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

  Widget _buildRecommendationsTvItem(
    BuildContext context,
  ) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvRecommendations = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tvRecommendations.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvRecommendations.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }
}