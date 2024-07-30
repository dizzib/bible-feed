import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/list_wheel.dart';
import '../view/wheel_state.dart';

class BookChapterWheels extends StatelessWidget {
  const BookChapterWheels({
    super.key,
    required this.feed,
    required this.constraints,
  });

  final Feed feed;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    var books = feed.books;

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
      return ListWheel<int>(
        constraints: c,
        count: books[bookWheelState.index].count,
        indexToItem: (index) => index + 1,
        itemToString: (int chapter) => chapter.toString(),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.8,
          child: bookWheel(constraints),
        ),
        Flexible(child: chapterWheel(constraints)),
      ],
    );
  }
}
