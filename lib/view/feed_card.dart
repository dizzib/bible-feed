import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/result.dart';
import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/bible_reader_service.dart';
import '/service/haptic_service.dart';
import '/service/verse_scope_toggler_service.dart';
import 'bible_reader_failure_dialog.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_title_bar.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();
    final feeds = watchIt<Feeds>();
    watchIt<VerseScopeTogglerService>();
    watch(feed);

    return AnimatedOpacity(
      opacity: feed.state.isRead ? 0.25 : 1,
      duration: Duration(
        seconds: feed.state.isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed) ? 30 : 0,
      ),
      child: Card(
        elevation: feed.state.isRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: Semantics(
          excludeSemantics: true,
          label:
              '${feed.state.book.name} chapter ${feed.state.chapter} is currently ${feed.state.isRead ? 'read' : 'unread'}',
          hint: '''
              Tap to ${brs.isLinked && !feed.state.isRead ? 'open Bible reader and' : ''} mark as ${feed.state.isRead ? 'unread' : 'read'}.
              Long press to change the book and chapter.''',
          child: InkWell(
            enableFeedback: false,
            onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
            onTap: () async {
              sl<HapticService>().impact();
              final result = await sl<BibleReaderService>().launchLinkedBibleReader(feed.state);
              if (result is Failure && context.mounted) context.showDialogWithBlurBackground(BibleReaderFailureDialog(result));
              feed.toggleIsRead();
            },
            child: LayoutBuilder(
              builder:
                  (_, BoxConstraints c) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(visible: c.maxHeight > 99, child: FeedCardTitleBar(feed)),
                      LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: feed.progress),
                      DefaultTextStyle.merge(
                        style: TextStyle(fontSize: (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30),
                        child: FeedCardBookChapter(feed),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
