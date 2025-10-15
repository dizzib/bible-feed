import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../model/feed.dart' as model;
import '../manager/bible_reader_link_manager.dart';
import '../manager/feeds_manager.dart';
import 'feed_body.dart';
import 'feed_semantics.dart';

class Feed extends WatchingWidget {
  final model.Feed feed;
  const Feed(this.feed);

  @override
  build(context) {
    watch(feed);
    final isLinked = watchIt<BibleReaderLinkManager>().isLinked;
    final isRead = feed.state.isRead;
    final isLastReadAndLinked = isRead && isLinked && identical(feed, sl<FeedsManager>().lastModifiedFeed);
    final secondsToFade = Duration(seconds: isLastReadAndLinked ? 30 : 0);
    final opacity = isRead ? 0.25 : 1.0;
    final elevation = isRead ? 0.0 : 12.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: secondsToFade,
      child: Card(
        elevation: elevation,
        clipBehavior: Clip.hardEdge,
        child: FeedSemantics(feed: feed, child: FeedBody(feed)),
      ),
    );
  }
}
