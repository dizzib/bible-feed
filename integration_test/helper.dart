import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/view/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

expectBookAndChapter(String expectedBookName, int expectedChapter) {
  expectText(expectedBookName);
  expectChapters(expectedChapter, count: 1);
}

expectChapters(int expectedValue, {int count = 10}) {
  expect(find.text(expectedValue.toString()), findsExactly(count));
}

// text helpers
expectAtLeast1Text(String expectedText) => expectText(expectedText, matcher: findsAtLeast(1));
expectNoText(String expectedText) => expectText(expectedText, matcher: findsNothing);
expectText(String expectedText, {matcher = findsOneWidget}) => expect(find.text(expectedText), matcher);

extension AppTestHelper on WidgetTester {
  initialiseApp() async {
    await bible_feed.main();
    await pumpAndSettle();
  }

  selectLastBookAndChapter(String feedName) async {
    await longPress(find.text(feedName));
    await pumpAndSettle();
    await scrollToLastBook();
    await scrollToLastChapter();
    await pumpAndSettle();
    await tap(find.text('Update'));
    await pumpAndSettle();
  }

  scrollToLastBook() async {
    await scrollToLastItem('book_wheel');
  }

  scrollToLastChapter() async {
    await scrollToLastItem('chapter_wheel');
  }

  scrollToLastItem(String keyVal) async {
    await drag(find.byKey(Key(keyVal)), const Offset(0, -999));
  }

  tapAllDoneButton(String text) async {
    expectText('All done!');
    await tap(find.text(text));
    await pumpAndSettle();
  }

  tapAllLists() async {
    var feedCards = find.byType(FeedCard).evaluate();
    for (var el in feedCards) {
      await tapAt(getCenter(find.byWidget(el.widget)));
    }
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
