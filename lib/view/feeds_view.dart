import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import 'all_done_fab.dart';
import 'feed_card.dart';

class FeedsView extends StatelessWidget {
  @override
  build(context) {
    feedCard(index) => Expanded(child: FeedCard(di<Feeds>()[index]));

    return Scaffold(
      body: Column(  // Columns and Rows work better than a GridView
        children: [
          for (int index in [0, 2, 4, 6, 8]) Expanded(
            child: Row(
              children: [feedCard(index), feedCard(index + 1)]
            )
          )
        ]
      ),
      floatingActionButton: AllDoneFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
