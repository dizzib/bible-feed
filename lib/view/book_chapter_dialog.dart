import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/book.dart';
import '../model/feed.dart';
import '../model/list_wheel_state.dart';
import '../view/book_chapter_dialog_footer.dart';
import '../view/book_chapter_dialog_wheels.dart';
import '../util/build_context.dart';

class BookChapterDialog extends StatelessWidget {
  final Feed feed;

  BookChapterDialog(this.feed) {
    di<ListWheelState<Book>>().index = feed.bookIndex;
    di<ListWheelState<int>>().index = feed.chapter - 1;
  }

  @override
  build(context) {
    withBackground(Widget child) =>  // fix 3.19 -> 3.22 background color regression
      Container(alignment: Alignment.center, color: context.colorScheme.surfaceContainerHigh, child: child);

    return LayoutBuilder(
      builder: (_, constraints) =>
        Dialog(
          clipBehavior: Clip.hardEdge,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.8,
              maxWidth: 300,
            ),
            child: Column(
              children: [
                Visibility(
                  visible: constraints.maxHeight > 280,
                  child: withBackground(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        feed.readingList.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ),
                Expanded(child: BookChapterDialogWheels(feed.readingList)),
                withBackground(BookChapterDialogFooter(feed.readingList, feed.setBookAndChapter))
              ],
            )
          )
        )
    );
  }
}
