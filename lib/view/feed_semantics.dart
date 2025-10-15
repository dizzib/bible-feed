import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_link_manager.dart';
import '../model/feed.dart';

class FeedSemantics extends WatchingWidget {
  final Widget? child;
  final Feed feed;

  const FeedSemantics({required this.feed, required this.child});

  @override
  build(context) {
    watch(feed);
    final brlm = watchIt<BibleReaderLinkManager>();
    final state = feed.state;
    final isRead = state.isRead;

    final semanticsLabel = '${state.book.name} chapter ${state.chapter} is currently ${isRead ? 'read' : 'unread'}';
    final semanticsHint =
        'Tap to ${brlm.isLinked && !isRead ? 'open Bible reader and' : ''} mark as ${isRead ? 'unread' : 'read'}. Long press to change the book and chapter.';

    return Semantics(excludeSemantics: true, label: semanticsLabel, hint: semanticsHint, child: child);
  }
}
