import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/book_chapter_wheels.dart';
import '../view/wheel_state.dart';

class BookChapterDialog extends StatelessWidget {
  const BookChapterDialog({ super.key, required this.feed, });

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    var books = feed.books;
    var selectedBook = books.current;
    var selectedBookIndex = books.indexOf(selectedBook);

    WheelState<Book> bookWheelState = WheelState<Book>(selectedBookIndex, selectedBook);
    WheelState<int> chapterWheelState = WheelState<int>(selectedBook.chapter - 1, selectedBook.chapter);

    Widget header() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          feed.books.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget footer() {
      var bookWheelState = Provider.of<WheelState<Book>>(context);
      var f = feed;
      var chaptersTo = f.books.chaptersTo(bookWheelState.item, chapterWheelState.item).toString();
      var totalChapters = f.books.totalChapters.toString();
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                '$chaptersTo of $totalChapters',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ),
          TextButton(
            onPressed: () {
              f.setBookAndChapter(bookWheelState.item, chapterWheelState.item);
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text('Update'),
            ),
          ),
        ],
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
                  LinearProgressIndicator(value: feed.books.progressTo(bookWheelState.item, chapterWheelState.item)),
                  footer(),
                ],
              )
            );
          }
        ),
      )
    );
  }
}
