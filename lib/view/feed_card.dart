import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/feed.dart';
import '../util/build_context.dart';
import 'book_chapter_dialog.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  @override
  build(context) {
    watch<Feed>(feed);

    titleBar() =>
      Row(
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
            onPressed: () => context.showBlurBackgroundDialog(BookChapterDialog(feed))
          ),
        ],
      );

    bookChapter() =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AutoSizeText(
                    feed.book.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AutoSizeText(
                feed.chapter.toString(),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );

    return Opacity(
      opacity: feed.isChapterRead ? 0.25 : 1,
      child: Card(
        color: feed.isChapterRead ? context.colorScheme.surfaceContainerLowest : context.colorScheme.surfaceContainerLow,
        elevation: feed.isChapterRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          enableFeedback: false,
          onLongPress: () => context.showBlurBackgroundDialog(BookChapterDialog(feed)),
          onTap: () {
            HapticFeedback.lightImpact();
            feed.toggleIsChapterRead();
          },
          child: LayoutBuilder(builder: (_, BoxConstraints c) =>
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: c.maxHeight > 99,
                  child: titleBar()
                ),
                LinearProgressIndicator(
                  backgroundColor: context.colorScheme.surface,
                  value: feed.progress
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30),
                  child: bookChapter(),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
