import 'package:core/core.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:search/presentation/bloc/tv/tv_searh/tv_search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageTv extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv-series';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSearchBloc>().add(OnQuerySeriesChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search tv series title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<TvSearchBloc, TvSearchState>(builder: (context, state) {
              if (state is TvSearchLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvSearchLoaded) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      final series = result[index];
                      return TvSeriesCard(series);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is TvSearchError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
