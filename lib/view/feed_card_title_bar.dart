import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/model/feed.dart';
import '/service/bible_reader_service.dart';
import 'book_chapter_dialog.dart';

class FeedCardTitleBar extends WatchingWidget {
  const FeedCardTitleBar(this.feed);

  final Feed feed;

  @override
  build(context) {
    watchIt<BibleReaderService>();
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              feed.readingList.name,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
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
