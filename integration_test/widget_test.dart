import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/list_wheel_state.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/view/book_chapter_dialog.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:bible_feed/view/feeds_view.dart';
import 'helper.dart';

extension Helper on WidgetTester {
  initialiseWidget(Widget widget) async {
    await pumpWidget(MaterialApp(home: widget));
  }
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final gospels = PghReadingLists().items[0];
  final matthew = gospels[0];

  testWidgets('BookChapterDialog', (WidgetTester t) async {
    sl.registerLazySingleton(() => BookListWheelState());
    sl.registerLazySingleton(() => ChapterListWheelState());
    await t.initialiseWidget(BookChapterDialog(Feed(gospels)));
    await t.scrollToLastChapter();
    await t.pump();
    for (int bookIndex = 0; bookIndex < gospels.count; bookIndex++) {
      expectText(gospels[bookIndex].name);
    }
    expectText(matthew.chapterCount.toString());
    await t.scrollToLastBook();
    await t.pump();
    final john = gospels[3];
    expectText(john.chapterCount.toString());
    expectNoText((john.chapterCount + 1).toString()); // matthew 22-28 should disappear
    expectNoText(matthew.chapterCount.toString());
  });

  testWidgets('FeedCard', (WidgetTester t) async {
    await t.initialiseWidget(FeedCard(Feed(gospels)));
    expectText(gospels.name);
    expectText(matthew.name);
    expectText('1');
  });

  testWidgets('FeedsView', (WidgetTester t) async {
    await t.initialiseWidget(FeedsView());
    expectChapters(1);
    for (var l in sl<ReadingLists>().items) {
      expectAtLeast1Text(l.name);
    }
  });
}
