import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/chapter_split_manager.dart';
import '../manager/chapter_split_setting_manager.dart';
import '../model/feed.dart';
import '_constants.dart';

class FeedBookChapter extends WatchingWidget {
  final Feed feed;
  const FeedBookChapter(this.feed);

  @override
  build(context) {
    const maxLines = 2;
    final chapterSplitLabel = sl<ChapterSplitManager>().getLabel(feed.state);
    watchIt<ChapterSplitSettingManager>();

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
