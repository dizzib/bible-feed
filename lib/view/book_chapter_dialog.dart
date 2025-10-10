import 'dart:math';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../model/feed.dart';
import '../model/list_wheel_state.dart';
import 'book_chapter_dialog_footer.dart';
import 'book_chapter_dialog_wheels.dart';
import 'build_context_extension.dart';
import 'constants.dart';

class BookChapterDialog extends StatelessWidget {
  final Feed feed;

  BookChapterDialog(this.feed) {
    sl<BookListWheelState>().index = feed.bookIndex;
    sl<ChapterListWheelState>().index = feed.state.chapter - 1;
  }

  @override
  build(context) {
    withBackground(Widget child) => // fix 3.19 -> 3.22 background color regression
        Container(alignment: Alignment.center, color: context.colorScheme.surfaceContainerHigh, child: child);

    return LayoutBuilder(
      builder: (_, constraints) {
        final maxHeight = constraints.maxHeight * 1.8;
        final maxWidth = [300, constraints.maxWidth * 0.5].reduce(max).toDouble();
        final isVisible = constraints.maxHeight > 280;

        return Dialog(
          clipBehavior: Clip.hardEdge,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
            child: Column(
              children: [
                Visibility(
                  visible: isVisible,
                  child: withBackground(
                    Padding(
                      padding: Constants.defaultPadding,
                      child: Text(feed.readingList.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(child: BookChapterDialogWheels(feed.readingList)),
                withBackground(BookChapterDialogFooter(feed)),
              ],
            ),
          ),
        );
      },
    );
  }
}
