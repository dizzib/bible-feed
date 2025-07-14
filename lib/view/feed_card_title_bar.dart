import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/model/feed.dart';
import '/service/bible_app_service.dart';
import '/util/build_context.dart';
import 'book_chapter_dialog.dart';

class FeedCardTitleBar extends WatchingWidget {
  final Feed feed;
  const FeedCardTitleBar(this.feed);

  @override
  build(context) {
    watchIt<BibleAppService>();
    return Row(
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
        Row(
          children: [
            FutureBuilder<bool>(
                future: sl<BibleAppService>().selectedBibleApp.canLaunch(feed),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                    return GestureDetector(
                      // GestureDetector has no padding, unlike IconButton
                      onTap: () {
                        sl<BibleAppService>().selectedBibleApp.launch(feed);
                      },
                      child: const Icon(Icons.link),
                    );
                  } else {
                    return Container();
                  }
                }),
            IconButton(
              icon: const Icon(Icons.unfold_more),
              onPressed: () => context.showBlurBackgroundDialog(BookChapterDialog(feed)),
            ),
          ],
        ),
      ],
    );
  }
}
