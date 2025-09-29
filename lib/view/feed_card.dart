import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/bible_reader_launch_service.dart';
import '/service/bible_reader_link_service.dart';
import '/service/chapter_split_toggler_service.dart';
import '/service/haptic_service.dart';
import '/service/result.dart';
import 'bible_reader_failure_dialog.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_semantics.dart';
import 'feed_card_title_bar.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  Future<void> _handleTap(BuildContext context) async {
    sl<HapticService>().impact();
    feed.toggleIsRead();
    final res = await sl<BibleReaderLaunchService>().launch(sl<BibleReaderLinkService>().linkedBibleReader, feed.state);
    if (res is Success) return;
    if (context.mounted) context.showDialogWithBlurBackground(BibleReaderFailureDialog(res as Failure));
  }

  @override
  build(context) {
    watch(feed);
    watchIt<ChapterSplitTogglerService>();
    final brs = watchIt<BibleReaderLinkService>();
    final feeds = watchIt<Feeds>();
    final state = feed.state;
    final isLastReadAndLinked = state.isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed);
    final secondsToFade = Duration(seconds: isLastReadAndLinked ? 30 : 0);
    final opacity = state.isRead ? 0.25 : 1.0;
    final elevation = state.isRead ? 0.0 : 12.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: secondsToFade,
      child: Card(
        elevation: elevation,
        clipBehavior: Clip.hardEdge,
        child: FeedCardSemantics(
          feed: feed,
          child: InkWell(
            enableFeedback: false,
            onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
            onTap: () => _handleTap(context),
            child: LayoutBuilder(
              builder: (_, BoxConstraints c) {
                final fontSize = (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30;
                final visible = c.maxHeight > 99;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(visible: visible, child: FeedCardTitleBar(feed)),
                    LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: feed.progress),
                    DefaultTextStyle.merge(
                      style: TextStyle(fontSize: fontSize.toDouble()),
                      child: FeedCardBookChapter(feed),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
