import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '/service/bible_reader_launch_result.dart';
import '/service/bible_reader_launch_service.dart';
import '/service/bible_reader_link_service.dart';
import '/service/chapter_split_toggler_service.dart';
import '/service/haptic_service.dart';
import 'bible_reader_failure_dialog.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_title_bar.dart';

class FeedCardBody extends WatchingWidget {
  final Feed feed;
  const FeedCardBody(this.feed);

  Future<void> _handleTap(BuildContext context) async {
    sl<HapticService>().impact();
    feed.toggleIsRead();
    final result = await sl<BibleReaderLaunchService>().maybeLaunch(
      sl<BibleReaderLinkService>().linkedBibleReader,
      feed.state,
    );
    if (result is! LaunchFailed) return;
    if (context.mounted) context.showDialogWithBlurBackground(BibleReaderFailureDialog(result));
  }

  @override
  build(context) {
    watch(feed);
    watchIt<ChapterSplitTogglerService>();

    return InkWell(
      enableFeedback: false,
      onLongPress: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
      onTap: () => _handleTap(context),
      child: LayoutBuilder(
        builder: (_, BoxConstraints c) {
          final fontSize = (c.maxWidth < 300 || c.maxHeight < 80) ? 24.0 : 30.0;
          final isVisible = c.maxHeight > 99;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(visible: isVisible, child: FeedCardTitleBar(feed)),
              LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: feed.progress),
              DefaultTextStyle.merge(style: TextStyle(fontSize: fontSize), child: FeedCardBookChapter(feed)),
            ],
          );
        },
      ),
    );
  }
}
