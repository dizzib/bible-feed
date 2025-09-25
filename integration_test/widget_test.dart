import 'package:bible_feed/injectable.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/service/chapter_split_service.dart';
import 'package:bible_feed/service/feed_store_service.dart';
import 'package:bible_feed/view/book_chapter_dialog.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:bible_feed/view/feeds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import 'helper.dart';

extension Helper on WidgetTester {
  Future<void> initialiseWidget(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
  }
}

void main() async {
  await configureDependencies();

  final gospels = sl<ReadingLists>()[0];
  final matthew = gospels[0];

  testWidgets('BookChapterDialog', (WidgetTester t) async {
    await t.initialiseWidget(
      BookChapterDialog(Feed(gospels, sl<ChapterSplitService>(), sl<FeedStoreService>().loadState(gospels))),
    );
    await t.scrollToLastChapter();
    await t.pump();
    for (int bookIndex = 0; bookIndex < gospels.count; bookIndex++) {
      expectText(gospels[bookIndex].name);
    }
    expectText(matthew.chapterCount);
    await t.scrollToLastBook();
    await t.pumpAndSettle();
    final john = gospels[3];
    expectText(john.chapterCount);
    expectNoText((john.chapterCount + 1)); // matthew 22-28 should disappear
    expectNoText(matthew.chapterCount);
  });

  testWidgets('FeedCard', (WidgetTester t) async {
    await t.initialiseWidget(
      FeedCard(Feed(gospels, sl<ChapterSplitService>(), sl<FeedStoreService>().loadState(gospels))),
    );
    expectText(gospels.name);
    expectBookAndChapter(matthew.name, 1);
  });

  testWidgets('FeedsView', (WidgetTester t) async {
    await t.initialiseWidget(Feeds());
    expectChapters(1);
    for (var l in sl<ReadingLists>()) {
      expectAtLeast1Text(l.name);
    }
  });
}
