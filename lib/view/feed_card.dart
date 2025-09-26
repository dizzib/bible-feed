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
    final isLastModifiedReadFeed = state.isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed);

    return AnimatedOpacity(
      opacity: state.isRead ? 0.25 : 1,
      duration: Duration(seconds: isLastModifiedReadFeed ? 30 : 0),
      child: Card(
        elevation: state.isRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: FeedCardSemantics(
          feed,
          child: InkWell(
            enableFeedback: false,
            onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
            onTap: () => _handleTap(context),
            child: LayoutBuilder(
              builder: (_, BoxConstraints c) {
                final fontSize = (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(visible: c.maxHeight > 99, child: FeedCardTitleBar(feed)),
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
