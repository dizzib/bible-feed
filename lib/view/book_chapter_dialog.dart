import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/book_chapter_dialog_footer.dart';
import '../view/book_chapter_dialog_wheels.dart';
import '../view/list_wheel_state.dart';

class BookChapterDialog extends StatelessWidget {
  final Feed feed;

  const BookChapterDialog({
    super.key,
    required this.feed,
  });

  @override
  Widget build(context) {
    final selectedBook = feed.books.current;

    return LayoutBuilder(
      builder: (_, constraints) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.8,
              maxWidth: 300,
            ),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: ListWheelState<Book>(feed.books.indexOf(selectedBook), selectedBook)
                ),
                ChangeNotifierProvider.value(
                  value: ListWheelState<int>(selectedBook.chapter - 1, selectedBook.chapter)
                )
              ],
              child: Column(
                children: [
                  Visibility(
                    visible: constraints.maxHeight > 280,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        feed.books.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: BookChapterWheels(books: feed.books)
                  ),
                  BookChapterDialogFooter(feed: feed)
                ],
              )
            )
          )
        );
      }
    );
  }
}
