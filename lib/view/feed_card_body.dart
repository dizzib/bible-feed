import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/chapter_split_setting_manager.dart';
import '../manager/feed_tap_manager.dart';
import '../model/bible_reader_launch_result.dart';
import '../model/feed.dart';
import 'bible_reader_launch_failed_dialog.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';
import 'feed_card_book_chapter.dart';
import 'feed_card_title_bar.dart';

class FeedCardBody extends WatchingWidget {
  final Feed feed;
  const FeedCardBody(this.feed);

  Future<void> _handleTap(BuildContext context) async {
    final result = await sl<FeedTapManager>().handleTap(feed);
    if (result is! LaunchFailed) return;
    if (context.mounted) context.showDialogWithBlurBackground(BibleReaderLaunchFailedDialog(result));
  }

  @override
  build(context) {
    watch(feed);
    watchIt<ChapterSplitSettingManager>();

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
