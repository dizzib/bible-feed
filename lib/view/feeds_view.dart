import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/feeds.dart';
import '../model/feeds.dart';
import 'all_done.dart';
import 'feed_card.dart';

class FeedsView extends StatelessWidget {
  // cache body (do not rebuild on update)
  // Columns and Rows work better than a GridView
  final _body = Column(
    children: [
      for (int index in [0, 2, 4, 6, 8])
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: ChangeNotifierProvider.value(
                value: feeds[index],
                child: FeedCard()
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider.value(
                value: feeds[index + 1],
                child: FeedCard()
              ),
            ),
          ],
        ),
      )
    ]
  );

  @override
  Widget build(BuildContext context) {
    context.watch<Feeds>();
    Navigator.maybePop(context);  // dismiss possible dialog (originator might be cron)

    return Scaffold(
      body: _body,
      floatingActionButton: feeds.areChaptersRead ? AllDone() : null,  // null activates animation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
