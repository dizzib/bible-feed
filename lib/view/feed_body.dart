import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feed_tap_manager.dart';
import '../model/feed.dart';
import '_build_context_extension.dart';
import 'bible_reader_launch_failed_dialog.dart';
import 'book_chapter_dialog.dart';
import 'feed_book_chapter.dart';
import 'feed_title_bar.dart';

class FeedBody extends StatelessWidget {
  final Feed feed;
  const FeedBody(this.feed);

  Future<void> _handleTap(BuildContext context) async {
    try {
      await sl<FeedTapManager>().handleTap(feed);
    } on Exception catch (e) {
      if (context.mounted) context.showDialogWithBlurBackground(BibleReaderLaunchFailedDialog(e));
    }
  }

  @override
  build(context) {
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
              Visibility(visible: isVisible, child: FeedTitleBar(feed)),
              LinearProgressIndicator(backgroundColor: context.colorScheme.surface, value: feed.progress),
              DefaultTextStyle.merge(style: TextStyle(fontSize: fontSize), child: FeedBookChapter(feed)),
            ],
          );
        },
      ),
    );
  }
}
