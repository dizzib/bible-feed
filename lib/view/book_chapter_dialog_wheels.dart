import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/model/reading_list.dart';
import '/model/list_wheel/book_list_wheel_state.dart';
import '/model/list_wheel/chapter_list_wheel_state.dart';
import '/view/list_wheel.dart';

class BookChapterDialogWheels extends WatchingWidget {
  final ReadingList readingList;

  const BookChapterDialogWheels(this.readingList);

  @override
  build(context) {
    var bookIndex = watchIt<BookListWheelState>().index;
    return LayoutBuilder(
      builder: (_, constraints) => DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: (constraints.maxWidth < 200 || constraints.maxHeight < 190) ? 16 : 23,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis, // without this, large text wraps and disappears
        ),
        child: Row(
          children: [
            SizedBox(
                width: constraints.maxWidth * 0.8,
                child: ListWheel(
                  sl<BookListWheelState>(),
                  key: const Key('book_wheel'),
                  maxIndex: readingList.count - 1,
                )),
            Flexible(
              child: ListWheel(
                sl<ChapterListWheelState>(),
                key: const Key('chapter_wheel'),
                maxIndex: readingList[bookIndex].chapterCount - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
