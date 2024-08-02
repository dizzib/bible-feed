import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/feed.dart';
import '../view/list_wheel_state.dart';

class BookChapterDialogFooter extends StatelessWidget {
  final Feed feed;

  const BookChapterDialogFooter(this.feed);

  @override
  build(context) {
    var book = feed.books[Provider.of<ListWheelState<Book>>(context).index];
    var chapter = Provider.of<ListWheelState<int>>(context).index + 1;

    return Column(
      children: [
        LinearProgressIndicator(value: feed.books.progressTo(book, chapter)),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  '${feed.books.chaptersTo(book, chapter)} of ${feed.books.totalChapters}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ),
            TextButton(
              onPressed: () {
                feed.setBookAndChapter(book, chapter);
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
