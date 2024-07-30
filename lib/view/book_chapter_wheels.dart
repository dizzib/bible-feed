import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/list_wheel.dart';
import '../view/wheel_state.dart';

class BookChapterWheels extends StatefulWidget {
  const BookChapterWheels({
    super.key,
    required this.feed,
    required this.constraints,
  });

  final Feed feed;
  final BoxConstraints constraints;

  @override
  State<BookChapterWheels> createState() => _BookChapterWheelsState();
}

class _BookChapterWheelsState extends State<BookChapterWheels> {
  late ListWheel<Book> _bookWheel;
  late ListWheel<int> _chapterWheel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var books = widget.feed.books;

    ListWheel<Book> bookWheel(BoxConstraints c) {
      return ListWheel<Book>(
        constraints: c,
        count: books.count,
        indexToItem: (index) => books[index],
        itemToString: (Book b) => b.name,
      );
    }

    ListWheel<int> chapterWheel(BoxConstraints c) {
      var bookWheelState = Provider.of<WheelState<Book>>(context);
      print('sbi:${bookWheelState.index}');
      return ListWheel<int>(
        constraints: c,
        count: books[bookWheelState.index].count,
        indexToItem: (index) => index + 1,
        itemToString: (int chapter) => chapter.toString(),
      );
    }

    _bookWheel = bookWheel(widget.constraints);
    _chapterWheel = chapterWheel(widget.constraints);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.constraints.maxWidth * 0.8,
          child: _bookWheel,
        ),
        Flexible(child: _chapterWheel),
      ],
    );
  }
}
