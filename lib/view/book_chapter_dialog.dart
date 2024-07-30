import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/book_chapter_wheels.dart';
import '../view/wheel_state.dart';

class BookChapterDialog extends StatefulWidget {
  const BookChapterDialog({ super.key, required this.feed, });

  final Feed feed;

  @override
  State<BookChapterDialog> createState() => _BookChapterDialogState();
}

class _BookChapterDialogState extends State<BookChapterDialog> {
  late WheelState<Book> _bookWheelState;
  late WheelState<int> _chapterWheelState;

  @override
  void initState() {
    super.initState();

    var books = widget.feed.books;
    var selectedBook = books.current;
    var selectedBookIndex = books.indexOf(selectedBook);

    _bookWheelState = WheelState<Book>(selectedBookIndex, selectedBook);
    _chapterWheelState = WheelState<int>(selectedBook.chapter - 1, selectedBook.chapter);
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.feed.books.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget footer() {
      var f = widget.feed;
      var chaptersTo = f.books.chaptersTo(_bookWheelState.item, _chapterWheelState.item).toString();
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
              f.setBookAndChapter(_bookWheelState.item, _chapterWheelState.item);
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: constraints.maxHeight > 280,
                  child: header(),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.65,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: _bookWheelState),
                      ChangeNotifierProvider.value(value: _chapterWheelState)
                    ],
                    child: BookChapterWheels(
                      feed: widget.feed,
                      constraints: constraints
                    )
                  ),
                ),
                LinearProgressIndicator(value: widget.feed.books.progressTo(_bookWheelState.item, _chapterWheelState.item)),
                footer(),
              ],
            );
          }
        ),
      )
    );
  }
}
