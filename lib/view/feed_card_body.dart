import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_launch_manager.dart';
import '../manager/bible_reader_link_manager.dart';
import '../manager/chapter_split_toggler_manager.dart';
import '../model/bible_reader_launch_result.dart';
import '../model/feed.dart';
import '../service/haptic_service.dart';
import 'bible_reader_launch_failed_dialog.dart';
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
    final linkedBibleReader = sl<BibleReaderLinkManager>().linkedBibleReader;
    final result = await sl<BibleReaderLaunchManager>().maybeLaunch(linkedBibleReader, feed.state);
    if (result is! LaunchFailed) return;
    if (context.mounted) context.showDialogWithBlurBackground(BibleReaderLaunchFailedDialog(result));
  }

  @override
  build(context) {
    watch(feed);
    watchIt<ChapterSplitTogglerManager>();

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
