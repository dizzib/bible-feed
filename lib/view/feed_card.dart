import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '../service/bible_reader_link_service.dart';
import '../service/feeds_service.dart';
import 'feed_card_body.dart';
import 'feed_card_semantics.dart';

class FeedCard extends WatchingWidget {
  final Feed feed;
  const FeedCard(this.feed);

  @override
  build(context) {
    watch(feed);
    final brls = watchIt<BibleReaderLinkService>();
    final feedsService = watchIt<FeedsService>();
    final state = feed.state;
    final isLastReadAndLinked = state.isRead && brls.isLinked && identical(feed, feedsService.lastModifiedFeed);
    final secondsToFade = Duration(seconds: isLastReadAndLinked ? 30 : 0);
    final opacity = state.isRead ? 0.25 : 1.0;
    final elevation = state.isRead ? 0.0 : 12.0;

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
