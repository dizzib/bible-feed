import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/feed.dart';
import '../view/list_wheel.dart';

// known issues with various wheel pickers...
//
// - selector_wheel (https://github.com/AlexLomm/selector_wheel)
//    - non standard grab behaviour (see https://github.com/AlexLomm/selector_wheel/issues/2)
//    - poor performance on Moto E5 plus
//
// - wheel_picker (https://pub.dev/packages/wheel_picker)
//    - does not seem to rebuild as expected
//    - cannot set the width (https://github.com/stavgafny/wheel_picker/issues/4)

class BookChapterDialog extends StatefulWidget {
  const BookChapterDialog({ super.key, required this.feed, });

  final Feed feed;

  @override
  State<BookChapterDialog> createState() => _BookChapterDialogState();
}

class _BookChapterDialogState extends State<BookChapterDialog> {
  late Book _selectedBook;
  late int _selectedChapter;

  late ListWheel _chapterListWheel;

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

    Widget bookWheel(BoxConstraints c) {
      var books = widget.feed.books;
      var selectedBookIndex = books.indexOf(_selectedBook);
      return SizedBox(
        width: c.maxWidth * 0.8,
        child: ListWheel(
          constraints: c,
          count: books.count,
          convertIndexToValue: (index) { return books[index].name; },
          getSelectedItemIndex: () { return selectedBookIndex; },
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedBook = books[index];
              // if (_selectedChapter > _selectedBook.count) {
                // _selectedChapter = _selectedBook.count;
                // _chapterListWheel.selectItem(_selectedChapter - 1);
              // }
            });
          },
        ),
      );
    }

    Widget chapterWheel(BoxConstraints c) {
      _chapterListWheel = ListWheel(
          constraints: c,
          count: _selectedBook.count,
          convertIndexToValue: (index) { return (index + 1).toString(); },
          getSelectedItemIndex: () { return _selectedChapter - 1; },
          onSelectedItemChanged: (index) { setState(() {_selectedChapter = index + 1;}); },
        );
      return Flexible(child: _chapterListWheel);
    }

    Widget footer() {
      var f = widget.feed;
      var chaptersTo = f.books.chaptersTo(_selectedBook, _selectedChapter).toString();
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
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.65,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [ bookWheel(constraints), chapterWheel(constraints) ],
                  ),
                ),
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
