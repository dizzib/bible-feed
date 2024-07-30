import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../model/feed.dart';
import '../view/wheel_state.dart';

class BookChapterDialogFooter extends StatelessWidget {
  const BookChapterDialogFooter({ super.key, required this.feed, });
  final Feed feed;

  @override
  Widget build(BuildContext context) {
    var book = Provider.of<WheelState<Book>>(context).item;
    var chapter = Provider.of<WheelState<int>>(context).item;
    var chaptersTo = feed.books.chaptersTo(book, chapter).toString();
    var totalChapters = feed.books.totalChapters.toString();

    return Column(
      children: [
        LinearProgressIndicator(value: feed.books.progressTo(book, chapter)),
        Row(
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
