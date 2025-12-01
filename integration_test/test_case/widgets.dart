import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/view/book_chapter_dialog.dart';
import 'package:bible_feed/view/feed.dart' as view;
import 'package:bible_feed/view/feeds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '_helper.dart';
import '../injectable.dart';

extension Helper on WidgetTester {
  Future initialiseWidget(Widget widget) async => await pumpWidget(MaterialApp(home: widget));
}

Future runWidgetTests() async {
  await configureDependencies(environment: 'integration_test');

  final gospels = sl<ReadingLists>()[0];
  final matthew = gospels[0];
  final state = sl<FeedStoreManager>().loadState(gospels);
  final feed = Feed(gospels, state);

  testWidgets('BookChapterDialog', (t) async {
    await t.initialiseWidget(BookChapterDialog(feed));
    for (Book b in gospels) {
      expectText(b.name);
    }
    await t.scrollToLastChapter();
    await t.pumpAndSettle();
    expectText(matthew.chapterCount, matcher: findsWidgets);
    await t.scrollToLastBook();
    await t.pumpAndSettle();
    final john = gospels[3];
    expectText(john.chapterCount);
    expectNoText((john.chapterCount + 1)); // matthew 22-28 should disappear
    expectNoText(matthew.chapterCount);
  });

  testWidgets('Feed', (t) async {
    await t.initialiseWidget(view.Feed(feed));
    expectText(gospels.name);
    expectBookAndChapter(matthew.name, 1);
  });

  testWidgets('Feeds', (t) async {
    await t.initialiseWidget(Feeds());
    expectChapters(1);
    for (final rl in sl<ReadingLists>()) {
      expectAtLeast1Text(rl.name);
    }
  });
}
