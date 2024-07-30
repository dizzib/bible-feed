import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/feed.dart';
import 'book_chapter_dialog.dart';

class FeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var feed = context.watch<Feed>();
    var book = feed.books.current;

    void showBookChapterDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: BookChapterDialog(feed: feed)
          );
        },
      );
    }

    Widget titleBar() {
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                feed.books.name,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.unfold_more),
            onPressed: showBookChapterDialog,
          ),
        ],
      );
    }

    Widget bookChapter(BoxConstraints c) {
      double getFontSize() { return (c.maxWidth < 300 || c.maxHeight < 80) ? 24 : 30; }
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AutoSizeText(
                    book.name,
                    style: TextStyle(fontSize: getFontSize()),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AutoSizeText(
                book.chapter.toString(),
                style: TextStyle(fontSize: getFontSize()),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
    }

    return Opacity(
      opacity: book.isChapterRead ? 0.2 : 1,
      child: Card(
        elevation: book.isChapterRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onLongPress: showBookChapterDialog,
          onTap: () { feed.toggleIsChapterRead(); },
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: constraints.maxHeight > 99,
                    child: titleBar()
                  ),
                  LinearProgressIndicator(value: feed.books.progress),
                  bookChapter(constraints),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
