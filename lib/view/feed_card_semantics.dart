import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/feed.dart';
import '../service/bible_reader_link_service.dart';

class FeedCardSemantics extends WatchingWidget {
  final Widget? child;
  final Feed feed;

  const FeedCardSemantics({required this.feed, required this.child});

  @override
  build(context) {
    watch(feed);
    final brs = watchIt<BibleReaderLinkService>();
    final state = feed.state;
    final isRead = state.isRead;

    final semanticsLabel = '${state.book.name} chapter ${state.chapter} is currently ${isRead ? 'read' : 'unread'}';
    final semanticsHint =
        'Tap to ${brs.isLinked && !isRead ? 'open Bible reader and' : ''} mark as ${isRead ? 'unread' : 'read'}. Long press to change the book and chapter.';

    return Semantics(excludeSemantics: true, label: semanticsLabel, hint: semanticsHint, child: child);
  }
}
