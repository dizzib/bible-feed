import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/feed.dart';
import '../view/book_chapter_dialog_footer.dart';
import '../view/book_chapter_dialog_wheels.dart';
import '../view/list_wheel_state.dart';
import '../util/build_context.dart';

class BookChapterDialog extends StatelessWidget {
  final Feed feed;

  const BookChapterDialog(this.feed);

  @override
  build(context) {
    // NOTE: keep this OUTSIDE the LayoutBuilder, otherwise *WheelStates get reset on device rotation
    final bookWheelState = ListWheelState<Book>(feed.bookIndex);
    final chapterWheelState = ListWheelState<int>(feed.chapter - 1);

    // fix 3.19 -> 3.22 background color regression
    Widget coloriseBackground(Widget child) =>
      Container(
        alignment: Alignment.center,
        color: context.theme.colorScheme.surfaceContainerHigh,
        child: child
      );

    return LayoutBuilder(
      builder: (_, constraints) =>
        Dialog(
          clipBehavior: Clip.hardEdge,
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
                    child: coloriseBackground(
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
                  coloriseBackground(BookChapterDialogFooter(feed.readingList, feed.setBookAndChapter))
                ],
              )
            )
          )
        )
    );
  }
}
