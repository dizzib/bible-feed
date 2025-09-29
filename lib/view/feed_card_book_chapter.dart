import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '/model/feed.dart';
import 'constants.dart';

class FeedCardBookChapter extends StatelessWidget {
  final Feed feed;
  const FeedCardBookChapter(this.feed);

  @override
  build(context) {
    const maxLines = 2;

    return Expanded(
      child: Padding(
        padding: Constants.defaultPadding,
        child: Center(
          child: AutoSizeText(
            '${feed.state.book.name} ${feed.state.chapter} ${feed.chapterSplitLabel}'.trim(),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
