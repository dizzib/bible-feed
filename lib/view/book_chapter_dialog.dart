import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/feed.dart';

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
  late FixedExtentScrollController _bookWheelController;
  late FixedExtentScrollController _chapterWheelController;

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
      var textStyle = TextStyle(
        fontSize: (c.maxWidth < 200 || c.maxHeight < 200) ? 16 : 24, // accomodate small displays
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,  // without this, large text wraps and disappears
      );

      // workaround bug in ListWheelScrollView where changing textStyle.fontSize -> itemExtent
      // renders badly. In this case let's jumpToItem on next frame
      Widget workaroundItemExtentBug({
        required void Function(Duration) postFrameCallback,
        required ListWheelScrollView child
      }) {
        return NotificationListener(
          onNotification: (SizeChangedLayoutNotification notification) {
            WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
            return true;  // cancel bubbling
          },
          child: SizeChangedLayoutNotifier(child: child)
        );
      }

      ListWheelScrollView makeListWheelScrollView({
        required Widget? Function(BuildContext _, int index) builder,
        required ScrollController controller,
        required void Function(int index) onSelectedItemChanged
      }) {
        return ListWheelScrollView.useDelegate(
          childDelegate: ListWheelChildBuilderDelegate(builder: builder),
          controller: controller,
          diameterRatio: 1.3,
          itemExtent: textStyle.fontSize! * 1.4 * MediaQuery.of(context).textScaler.scale(1),  // text size in device settings
          magnification: 1.1,
          onSelectedItemChanged: onSelectedItemChanged,
          overAndUnderCenterOpacity: 0.5,
          physics: const FixedExtentScrollPhysics(),
          useMagnifier: true,
        );
      }

      Widget bookWheel() {
        var books = widget.feed.books;
        var selectedBookIndex = books.indexOf(_selectedBook);
        _bookWheelController = FixedExtentScrollController(initialItem:selectedBookIndex);
        return SizedBox(
          width: c.maxWidth * 0.8,
          child: workaroundItemExtentBug(
            postFrameCallback: (_) { _bookWheelController.jumpToItem(selectedBookIndex); },
            child: makeListWheelScrollView(
              builder: (BuildContext _, int index) {
                if (index < 0 || index >= books.count) return null;
                return Text(books[index].name, style: textStyle);
              },
              controller: _bookWheelController,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedBook = books[index];
                  if (_selectedChapter > _selectedBook.count) {
                    _selectedChapter = _selectedBook.count;
                    _chapterWheelController.jumpToItem(_selectedChapter - 1);
                  }
                });
              },
            ),
          )
        );
      }

      Widget chapterWheel() {
        _chapterWheelController = FixedExtentScrollController(initialItem:_selectedChapter - 1);
        return Flexible(
          child: workaroundItemExtentBug(
            postFrameCallback: (_) { _chapterWheelController.jumpToItem(_selectedChapter - 1); },
            child: makeListWheelScrollView(
              builder: (BuildContext _, int index) {
                if (index < 0 || index >= _selectedBook.count) return null;
                return Text((index+1).toString(), style: textStyle);
              },
              controller: _chapterWheelController,
              onSelectedItemChanged: (index) {
                setState(() {_selectedChapter = index + 1;});
              },
            ),
          )
        );
      }

      return SizedBox(
        width: c.maxWidth,
        height: c.maxHeight * 0.65,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [ bookWheel(), chapterWheel() ],
        ),
      );
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
