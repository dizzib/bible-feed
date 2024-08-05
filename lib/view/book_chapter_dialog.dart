import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/feed.dart';
import '../view/book_chapter_dialog_footer.dart';
import '../view/book_chapter_dialog_wheels.dart';
import '../view/list_wheel_state.dart';

class BookChapterDialog extends StatelessWidget {
  final Feed feed;

  const BookChapterDialog(this.feed);

  @override
  build(context) {
    // NOTE: keep this OUTSIDE the LayoutBuilder, otherwise *WheelStates get reset on device rotation
    final bookWheelState = ListWheelState<Book>(feed.bookIndex);
    final chapterWheelState = ListWheelState<int>(feed.chapter - 1);

    return LayoutBuilder(
      builder: (_, constraints) =>
        Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.8,
              maxWidth: 300,
            ),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: bookWheelState),
                ChangeNotifierProvider.value(value: chapterWheelState)
              ],
              child: Column(
                children: [
                  Visibility(
                    visible: constraints.maxHeight > 280,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        feed.readingList.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                  Expanded(child: BookChapterDialogWheels(feed.readingList)),
                  BookChapterDialogFooter(feed.readingList, feed.setBookAndChapter)
                ],
              )
            )
          )
        )
    );
  }
}
