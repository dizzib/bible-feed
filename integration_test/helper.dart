import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/view/feed_card.dart';
import 'package:bible_feed/util/log.dart';

expectBookAndChapter(String expectedBookName, int expectedChapter) {
  expect(find.text(expectedBookName), findsOneWidget);
  expectChapters(expectedChapter, count:1);
}

expectChapters(int expectedValue, {int count = 10}) {
  expect(find.text(expectedValue.toString()), findsExactly(count));
}

expectNoText(String expectText) {
  expect(find.text(expectText), findsNothing);
}

expectText(String expectText) {
  expect(find.text(expectText), findsOneWidget);
}

extension AppTestHelper on WidgetTester {
  initialiseApp() async {
    await bible_feed.main();
    await pumpAndSettle();
  }

  selectLastBookAndChapter(String feedName) async {
    await longPress(find.text(feedName));
    await pumpAndSettle();
    await drag(find.byKey(const Key('book_wheel')), const Offset(0, -999));  // last book
    await drag(find.byKey(const Key('chapter_wheel')), const Offset(0, -999));  // last chapter
    await pumpAndSettle();
    await tap(find.text('Update'));
    await pumpAndSettle();
  }

  tapAllDoneButton(String text) async {
    expect(find.text('All done!'), findsOneWidget);
    await tap(find.text(text));
    await pumpAndSettle();
  }

  tapAllLists() async {
    var feedCards = find.byType(FeedCard).evaluate();
    feedCards.length.log();
    for (var el in feedCards) { await tapAt(getCenter(find.byWidget(el.widget))); }
    await pumpAndSettle();
  }

  tapFab() async {
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  tapList(String bookName) async {
    await tap(find.text(bookName));
    await pumpAndSettle();
  }

  tapNo() async {
    await tapAllDoneButton('No');
  }

  tapYes() async {
    await tapAllDoneButton('Yes');
  }
}
