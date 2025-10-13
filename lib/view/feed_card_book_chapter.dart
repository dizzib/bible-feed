import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/chapter_split_manager.dart';
import '../model/feed.dart';
import 'constants.dart';

class FeedCardBookChapter extends StatelessWidget {
  final Feed feed;
  const FeedCardBookChapter(this.feed);

  @override
  build(context) {
    const maxLines = 2;
    final chapterSplitLabel = sl<ChapterSplitManager>().getLabel(feed.state);

    return Expanded(
      child: Padding(
        padding: Constants.defaultPadding,
        child: Center(
          child: AutoSizeText(
            '${feed.state.book.name} ${feed.state.chapter} $chapterSplitLabel'.trim(),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
