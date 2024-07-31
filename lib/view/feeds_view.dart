import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/feeds.dart';
import '../model/feeds.dart';
import 'all_done.dart';
import 'feed_card.dart';

class FeedsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<Feeds>();
    Navigator.maybePop(context);  // dismiss possible dialog (originator might be cron)

    feedCard(int index) =>
      Expanded(
        child: ChangeNotifierProvider.value(
          value: feeds[index],
          child: FeedCard()
        ),
      );

    return Scaffold(
      body: Column(  // Columns and Rows work better than a GridView
        children: [
          for (int index in [0, 2, 4, 6, 8])
          Expanded(
            child: Row(
              children: [feedCard(index), feedCard(index + 1)]
            )
          )
        ]
      ),
      floatingActionButton: feeds.areChaptersRead ? AllDone() : null,  // null activates animation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
