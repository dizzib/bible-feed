import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/list_wheel.dart';
import '../view/list_wheel_state.dart';

class BookChapterWheels extends StatelessWidget {
  final Books books;
  final BoxConstraints constraints;

  const BookChapterWheels({
    super.key,
    required this.books,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: (constraints.maxWidth < 200 || constraints.maxHeight < 200) ? 16 : 23,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,  // without this, large text wraps and disappears
    );

    return Row(
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.8,
          child: ListWheel<Book>(
            count: books.count,
            indexToItem: (index) => books[index],
            itemToString: (Book b) => b.name,
            textStyle: textStyle,
          )
        ),
        Flexible(
          child: ListWheel<int>(
            count: Provider.of<ListWheelState<Book>>(context).item.count,
            indexToItem: (index) => index + 1,
            itemToString: (int chapter) => chapter.toString(),
            textStyle: textStyle,
          )
        ),
      ],
    );
  }
}
