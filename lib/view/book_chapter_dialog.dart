import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:selector_wheel/selector_wheel.dart';
import '../model/feed.dart';

class BookChapterDialog extends StatefulWidget {
  const BookChapterDialog({ super.key, required this.feed, });

  final Feed feed;

  @override
  State<BookChapterDialog> createState() => _BookChapterDialogState();
}

class _BookChapterDialogState extends State<BookChapterDialog> {
  late Book _selectedBook;
  late int _selectedChapter;

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.feed.books.current;
    _selectedChapter = _selectedBook.chapter;
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

    Widget wheels(BoxConstraints c) {
      var textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
      var t = Theme.of(context);

      Widget bookWheel() {
        var books = widget.feed.books;
        return SelectorWheel(
          width: c.maxWidth * 0.8,
          childCount: books.count,
          childHeight: 35 * textScaleFactor,
          selectedItemIndex: books.indexOf(_selectedBook),
          convertIndexToValue: (int index) {
            return SelectorWheelValue(
              label: books[index].name,
              index: index,
              value: books[index],);
          },
          onValueChanged: (SelectorWheelValue<Book> v) {
            setState(() {_selectedBook = v.value;});
          }
        );
      }

      Widget chapterWheel() {
        return SelectorWheel(
          childCount: _selectedBook.count,
          childHeight: 35 * textScaleFactor,
          width: c.maxWidth * 0.2,
          selectedItemIndex: _selectedChapter - 1,
          convertIndexToValue: (int index) {
            return SelectorWheelValue(
              label: '${1 + index}',
              index: index,
              value: 1 + index,);
          },
          onValueChanged: (SelectorWheelValue<int> v) {
            setState(() {_selectedChapter = v.value;});
          }
        );
      }

      return SizedBox(
        width: c.maxWidth,
        height: c.maxHeight * 0.65,
        child: Theme(
          data: ThemeData(
            colorScheme: t.colorScheme.copyWith(),
            textTheme: t.textTheme.copyWith(
              titleLarge: t.textTheme.titleLarge?.copyWith(
                fontSize: c.maxWidth < 200 ? 16 : 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [ bookWheel(), chapterWheel() ],
          ),
        ),
      );
    }

    Widget footer() {
      var f = widget.feed;
      var bks = f.books;
      var chaptersTo = bks.chaptersTo(_selectedBook, _selectedChapter).toString();
      var totalChapters = bks.totalChapters.toString();
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
              f.setBookAndChapter(_selectedBook, _selectedChapter);
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
                wheels(constraints),
                LinearProgressIndicator(value: widget.feed.books.progressTo(_selectedBook, _selectedChapter)),
                footer(),
              ],
            );
          }
        ),
      )
    );
  }
}
