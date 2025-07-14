import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '/model/feed.dart';

class FeedCardBookChapter extends StatelessWidget {
  final Feed feed;
  const FeedCardBookChapter(this.feed);

  @override
  build(context) {
    // hypenation does not work well or look good, so stick with overflow ellipses
    bookChapterNoTip() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                feed.book.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          AutoSizeText(
            feed.chapter.toString(),
            maxLines: 1,
          ),
        ],
      );
    }

    // for Psalms 119 only
    bookChapterTip() {
      return Center(
        child: AutoSizeText(
          '${feed.book.name}\u00A0${feed.chapter}${feed.tip}',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: feed.hasTip ? bookChapterTip() : bookChapterNoTip(),
      ),
    );
  }
}
