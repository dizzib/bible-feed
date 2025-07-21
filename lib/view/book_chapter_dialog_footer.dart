import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/model/book.dart';
import '/model/feed.dart';
import '/model/list_wheel_state.dart';

class BookChapterDialogFooter extends WatchingWidget {
  const BookChapterDialogFooter(this.feed);

  final Feed feed;

  @override
  build(context) {
    var bookIndex = watchIt<ListWheelState<Book>>().index;
    var chapter = watchIt<ListWheelState<int>>().index + 1;

    return Column(
      children: [
        LinearProgressIndicator(
            backgroundColor: context.colorScheme.surface, value: feed.readingList.progressTo(bookIndex, chapter)),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                '${feed.readingList.chaptersTo(bookIndex, chapter)} of ${feed.readingList.totalChapters}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                feed.setBookAndChapter(bookIndex, chapter);
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
