import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/book_chapter_wheels.dart';
import '../view/book_chapter_dialog_footer.dart';
import '../view/list_wheel_state.dart';

class BookChapterDialog extends StatelessWidget {
  const BookChapterDialog({ super.key, required this.feed, });
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    final selectedBook = feed.books.current;
    final bookWheelState = WheelState<Book>(feed.books.indexOf(selectedBook), selectedBook);
    final chapterWheelState = WheelState<int>(selectedBook.chapter - 1, selectedBook.chapter);

    Widget header() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          feed.books.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: bookWheelState),
                ChangeNotifierProvider.value(value: chapterWheelState)
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: constraints.maxHeight > 280,
                    child: header(),
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.65,
                    child: BookChapterWheels(
                      feed: feed,
                      constraints: constraints
                    )
                  ),
                  BookChapterDialogFooter(feed: feed),
                ],
              )
            );
          }
        ),
      )
    );
  }
}
