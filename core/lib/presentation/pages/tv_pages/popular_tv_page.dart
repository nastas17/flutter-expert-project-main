import 'package:core/presentation/bloc/bloc_tv/tv_popular/tv_popular_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvPopularBloc>().add(LoadTvPopular());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularBloc, TvPopularState>(
          builder: (context, state) {
            if (state is TvPopularLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvPopularHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvSeriesCard(state.result[index]);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as TvPopularError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
