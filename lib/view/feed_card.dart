import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/feed.dart';
import 'book_chapter_dialog.dart';

class FeedCard extends StatelessWidget {
  @override
  build(context) {
    var feed = context.watch<Feed>();
    var book = feed.current;

    showBookChapterDialog() => showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: BookChapterDialog(feed)
        );
      },
    );

    titleBar() =>
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                feed.readingList.name,
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

    bookChapter({required double fontSize}) =>
      Expanded(
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
                    style: TextStyle(fontSize: fontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AutoSizeText(
                feed.chapter.toString(),
                style: TextStyle(fontSize: fontSize),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );

    return Opacity(
      opacity: feed.isChapterRead ? 0.2 : 1,
      child: Card(
        elevation: feed.isChapterRead ? 0 : 12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onLongPress: showBookChapterDialog,
          onTap: feed.toggleIsChapterRead,
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: constraints.maxHeight > 99,
                    child: titleBar()
                  ),
                  LinearProgressIndicator(value: feed.progress),
                  bookChapter(
                    fontSize: (constraints.maxWidth < 300 || constraints.maxHeight < 80) ? 24 : 30
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
