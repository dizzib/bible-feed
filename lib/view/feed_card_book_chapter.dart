import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '/model/feed.dart';

class FeedCardBookChapter extends StatelessWidget {
  const FeedCardBookChapter(this._feed);

  final Feed _feed;

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
                _feed.book.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          AutoSizeText(
            _feed.chapter.toString(),
            maxLines: 1,
          ),
        ],
      );
    }

    // for Psalms 119 only
    bookChapterTip() {
      return Center(
        child: AutoSizeText(
          '${_feed.book.name}\u00A0${_feed.chapter}${_feed.tip}',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _feed.hasTip ? bookChapterTip() : bookChapterNoTip(),
      ),
    );
  }
}
