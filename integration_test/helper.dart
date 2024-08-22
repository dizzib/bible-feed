import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/view/feed_card.dart';

expectBookAndChapter(String expectedBookName, int expectedChapter) {
  expectText(expectedBookName);
  expectChapters(expectedChapter, count:1);
}

expectChapters(int expectedValue, {int count = 10}) {
  expect(find.text(expectedValue.toString()), findsExactly(count));
}

// text helpers
expectAtLeast1Text(String expectedText) => expectText(expectedText, matcher:findsAtLeast(1));
expectNoText(String expectedText) => expectText(expectedText, matcher:findsNothing);
expectText(String expectedText, {matcher = findsOneWidget}) => expect(find.text(expectedText), matcher);

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
    expectText('All done!');
    await tap(find.text(text));
    await pumpAndSettle();
  }

  tapAllLists() async {
    var feedCards = find.byType(FeedCard).evaluate();
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
