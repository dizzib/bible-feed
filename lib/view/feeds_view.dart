import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feeds.dart';
import 'feed_card.dart';

class FeedsView extends StatelessWidget {
  // Columns and Rows work better than a GridView
  @override
  build(context) => Column(
    children: [
      for (int index in [0, 2, 4, 6, 8])
        Expanded(
          child: Row(
            children: [
              Expanded(child: FeedCard(sl<Feeds>()[index])),
              Expanded(child: FeedCard(sl<Feeds>()[index + 1])),
            ],
          ),
        ),
    ],
  );
}
