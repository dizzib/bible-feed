import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../model/feed.dart';
import '../manager/bible_reader_link_service.dart';
import '../manager/feeds_service.dart';
import 'feed_card_body.dart';
import 'feed_card_semantics.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  @override
  build(context) {
    watch(feed);
    final brls = watchIt<BibleReaderLinkService>();
    final isRead = feed.state.isRead;
    final isLastReadAndLinked = isRead && brls.isLinked && identical(feed, sl<FeedsService>().lastModifiedFeed);
    final secondsToFade = Duration(seconds: isLastReadAndLinked ? 30 : 0);
    final opacity = isRead ? 0.25 : 1.0;
    final elevation = isRead ? 0.0 : 12.0;

    return AnimatedOpacity(
      opacity: opacity,
      duration: secondsToFade,
      child: Card(
        elevation: elevation,
        clipBehavior: Clip.hardEdge,
        child: FeedCardSemantics(feed: feed, child: FeedCardBody(feed)),
      ),
    );
  }
}
