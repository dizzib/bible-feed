import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/bible_reader_launch_service.dart';
import '../service/result.dart';
import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/bible_reader_link_service.dart';
import '/service/haptic_service.dart';
import '/service/chapter_split_toggler_service.dart';
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
    watch(feed);
    watchIt<ChapterSplitTogglerService>();
    final brs = watchIt<BibleReaderLinkService>();
    final feeds = watchIt<Feeds>();
    final state = feed.state;
    final isRead = state.isRead;

    return AnimatedOpacity(
      opacity: isRead ? 0.25 : 1,
      duration: Duration(seconds: isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed) ? 30 : 0),
      child: Card(
        elevation: isRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: Semantics(
          excludeSemantics: true,
          label: '${state.book.name} chapter ${state.chapter} is currently ${isRead ? 'read' : 'unread'}',
          hint: '''
              Tap to ${brs.isLinked && !isRead ? 'open Bible reader and' : ''} mark as ${isRead ? 'unread' : 'read'}.
              Long press to change the book and chapter.''',
          child: InkWell(
            enableFeedback: false,
            onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
            onTap: () async {
              sl<HapticService>().impact();
              final linkedBibleReader = sl<BibleReaderLinkService>().linkedBibleReader;
              final result = await sl<BibleReaderLaunchService>().launch(linkedBibleReader, state);
              if (result is Failure && context.mounted) {
                context.showDialogWithBlurBackground(BibleReaderFailureDialog(result));
              }
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
