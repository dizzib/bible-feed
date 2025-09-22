import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '/model/feed.dart';

class FeedCardBookChapter extends StatelessWidget {
  final Feed feed;
  const FeedCardBookChapter(this.feed);

  @override
  build(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AutoSizeText(
            '${feed.state.book.name} ${feed.state.chapter} ${feed.chapterSplitLabel}'.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
