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
    // accomodate small displays
    final double fontSize = (constraints.maxWidth < 200 || constraints.maxHeight < 200) ? 16 : 24;

    bookWheel() {
      return ListWheel<Book>(
        count: feed.books.count,
        indexToItem: (index) => feed.books[index],
        itemToString: (Book b) => b.name,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,  // without this, large text wraps and disappears
        ),
      );
    }

    chapterWheel() {
      return ListWheel<int>(
        count: Provider.of<WheelState<Book>>(context).item.count,
        indexToItem: (index) => index + 1,
        itemToString: (int chapter) => chapter.toString(),
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.8,
          child: bookWheel(),
        ),
        Flexible(child: chapterWheel()),
      ],
    );
  }
}
