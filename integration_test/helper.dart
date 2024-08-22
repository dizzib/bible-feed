import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/view/feed_card.dart';

advanceManually(WidgetTester t) async {
  expect(find.text('All done!'), findsOneWidget);
  await t.tap(find.text('Yes'));
  await t.pumpAndSettle();
}

expectChapters(int expectedValue, {int count = 10}) {
  expect(find.text(expectedValue.toString()), findsExactly(count));
}

initialiseApp(WidgetTester t) async {
  await bible_feed.main();
  await t.pumpAndSettle();
}

markAllListsAsRead(WidgetTester t) async {
  var feedCards = find.byType(FeedCard).evaluate();
  for (var el in feedCards) { await t.tapAt(t.getCenter(find.byWidget(el.widget))); }
  await t.pumpAndSettle();
}

selectLastBookAndChapter(WidgetTester t, String feedName, String expectedBookName, int expectedChapter) async {
  await t.longPress(find.text(feedName));
  await t.pumpAndSettle();
  await t.drag(find.byKey(const Key('book_wheel')), const Offset(0, -999));  // last book
  await t.drag(find.byKey(const Key('chapter_wheel')), const Offset(0, -999));  // last chapter
  await t.pumpAndSettle();
  await t.tap(find.text('Update'));
  await t.pumpAndSettle();
  expect(find.text(expectedBookName), findsOneWidget);
  expectChapters(21, count:1);
}

