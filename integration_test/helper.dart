import 'package:bible_feed/view/app_base.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'injectable.dart';

expectBookAndChapter(String expectedBookName, int expectedChapter) {
  expectText('$expectedBookName $expectedChapter');
}

expectChapters(int expectedValue, {int count = 10}) {
  expect(find.textContaining(expectedValue.toString()), findsExactly(count));
}

// text helpers
expectAtLeast1Text(dynamic expected) => expectText(expected.toString(), matcher: findsAtLeast(1));
expectNoText(dynamic expected) => expectText(expected.toString(), matcher: findsNothing);
expectText(dynamic expected, {matcher = findsOneWidget}) => expect(find.textContaining(expected.toString()), matcher);

extension AppTestHelper on WidgetTester {
  initialiseApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    runApp(AppBase());
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
