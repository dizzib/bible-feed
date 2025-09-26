import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';

class FeedCardTitleBar extends WatchingWidget {
  final Feed feed;
  const FeedCardTitleBar(this.feed);

  Widget _buildLastReadIcon() {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Tooltip(message: 'This is the last chapter you read', child: Icon(Icons.auto_stories)),
    );
  }

  @override
  build(context) {
    final feeds = watchIt<Feeds>();
    final isLastReadChapter = feed.state.isRead && identical(feed, feeds.lastModifiedFeed);

    return Row(
      children: [
        if (isLastReadChapter) _buildLastReadIcon(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(feed.readingList.name, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.unfold_more),
          onPressed: () => context.showDialogWithBlurBackground(BookChapterDialog(feed)),
        ),
      ],
    );
  }
}
