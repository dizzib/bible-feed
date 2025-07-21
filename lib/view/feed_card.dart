import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/model/feed.dart';
import '/service/bible_reader_service.dart';
import 'book_chapter_dialog.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_title_bar.dart';

class FeedCard extends WatchingWidget {
  const FeedCard(this._feed);

  final Feed _feed;

  @override
  build(context) {
    watch(_feed);

    return Opacity(
      opacity: _feed.isChapterRead ? 0.25 : 1,
      child: Card(
        color:
            _feed.isChapterRead ? context.colorScheme.surfaceContainerLowest : context.colorScheme.surfaceContainerLow,
        elevation: _feed.isChapterRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          enableFeedback: false,
          onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(_feed)),
          onTap: () {
            HapticFeedback.lightImpact();
            sl<BibleReaderService>().launchLinkedBibleReader(_feed);
            _feed.toggleIsChapterRead();
          },
          child: LayoutBuilder(
            builder: (_, BoxConstraints c) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(visible: c.maxHeight > 99, child: FeedCardTitleBar(_feed)),
                LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: _feed.progress),
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30),
                  child: FeedCardBookChapter(_feed),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
