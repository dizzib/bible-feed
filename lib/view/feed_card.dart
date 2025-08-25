import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/extension/build_context.dart';
import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/bible_reader_service.dart';
import '/service/haptic_service.dart';
import '/service/verse_scope_service.dart';
import 'book_chapter_dialog.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_title_bar.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();
    final feeds = watchIt<Feeds>();
    watchIt<VerseScopeService>();
    watch(feed);

    return AnimatedOpacity(
      opacity: feed.state.isRead ? 0.25 : 1,
      duration:
          Duration(milliseconds: feed.state.isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed) ? 30000 : 0),
      child: Card(
        elevation: feed.state.isRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          enableFeedback: false,
          onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
          onTap: () {
            sl<HapticService>().impact();
            sl<BibleReaderService>().launchLinkedBibleReader(feed);
            feed.toggleIsRead();
          },
          child: LayoutBuilder(
            builder: (_, BoxConstraints c) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(visible: c.maxHeight > 99, child: FeedCardTitleBar(feed)),
                LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: feed.progress),
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30),
                  child: FeedCardBookChapter(feed),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
