import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '/model/feeds.dart';
import '/service/bible_reader_link_service.dart';
import 'book_chapter_dialog.dart';
import 'build_context_extension.dart';

class FeedCardTitleBar extends WatchingWidget {
  final Feed feed;
  const FeedCardTitleBar(this.feed);

  @override
  build(context) {
    final brs = watchIt<BibleReaderLinkService>();
    final feeds = watchIt<Feeds>();
    return Row(
      children: [
        if (feed.state.isRead && brs.isLinked && identical(feed, feeds.lastModifiedFeed))
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Tooltip(message: 'This is the last chapter you read', child: Icon(Icons.auto_stories)),
          ),
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
