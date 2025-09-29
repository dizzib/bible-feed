import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/list_wheel_state.dart';
import '/model/reading_list.dart';
import '/view/list_wheel.dart';

class BookChapterDialogWheels extends WatchingWidget {
  final ReadingList readingList;
  const BookChapterDialogWheels(this.readingList);

  @override
  build(context) {
    var bookIndex = watchIt<BookListWheelState>().index;
    return LayoutBuilder(
      builder: (_, constraints) {
        final fontSize = (constraints.maxWidth < 200 || constraints.maxHeight < 190) ? 16.0 : 23.0;
        final dialogWidth = constraints.maxWidth * 0.8;

        return DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis, // without this, large text wraps and disappears
          ),
          child: Row(
            children: [
              SizedBox(
                width: dialogWidth,
                child: ListWheel(
                  sl<BookListWheelState>(),
                  key: const Key('book_wheel'),
                  indexToString: (index) => readingList[index].name,
                  maxIndex: readingList.count - 1,
                ),
              ),
              Flexible(
                child: ListWheel(
                  sl<ChapterListWheelState>(),
                  key: const Key('chapter_wheel'),
                  indexToString: (index) => (index + 1).toString(),
                  maxIndex: readingList[bookIndex].chapterCount - 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
