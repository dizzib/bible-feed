import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/reading_list.dart';
import '../view/list_wheel_state.dart';

class BookChapterDialogFooter extends StatelessWidget {
  final ReadingList readingList;
  final Function setBookAndChapter;

  const BookChapterDialogFooter(this.readingList, this.setBookAndChapter);

  @override
  build(context) {
    var book = readingList[Provider.of<ListWheelState<Book>>(context).index];
    var chapter = Provider.of<ListWheelState<int>>(context).index + 1;

    return Column(
      children: [
        LinearProgressIndicator(value: readingList.progressTo(book, chapter)),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  '${readingList.chaptersTo(book, chapter)} of ${readingList.totalChapters}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ),
            TextButton(
              onPressed: () {
                setBookAndChapter(book, chapter);
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
