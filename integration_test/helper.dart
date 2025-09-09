import 'package:bible_feed/view/app_base.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'injectable.dart';

void expectBookAndChapter(String expectedBookName, int expectedChapter) {
  expectText('$expectedBookName $expectedChapter');
}

void expectChapters(int expectedValue, {int count = 10}) {
  expect(find.textContaining(expectedValue.toString()), findsExactly(count));
}

// text helpers
dynamic expectAtLeast1Text(dynamic expected) => expectText(expected.toString(), matcher: findsAtLeast(1));
dynamic expectNoText(dynamic expected) => expectText(expected.toString(), matcher: findsNothing);
void expectText(dynamic expected, {matcher = findsOneWidget}) => expect(find.textContaining(expected.toString()), matcher);

extension AppTestHelper on WidgetTester {
  Future<void> initialiseApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    runApp(AppBase());
    await pumpAndSettle();
  }

  Future<void> selectLastBookAndChapter(String feedName) async {
    await longPress(find.text(feedName));
    await pumpAndSettle();
    await scrollToLastBook();
    await scrollToLastChapter();
    await pumpAndSettle();
    await tap(find.text('Update'));
    await pumpAndSettle();
  }

  Future<void> scrollToLastBook() async {
    await scrollToLastItem('book_wheel');
  }

  Future<void> scrollToLastChapter() async {
    await scrollToLastItem('chapter_wheel');
  }

  Future<void> scrollToLastItem(String keyVal) async {
    await drag(find.byKey(Key(keyVal)), const Offset(0, -999));
  }

  Future<void> tapAllDoneButton(String text) async {
    expectText('All done!');
    await tap(find.text(text));
    await pumpAndSettle();
  }

  Future<void> tapAllLists() async {
    var feedCards = find.byType(FeedCard).evaluate();
    for (var el in feedCards) {
      await tapAt(getCenter(find.byWidget(el.widget)));
    }
    await pumpAndSettle();
  }

  Future<void> tapFab() async {
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  Future<void> tapList(String bookName) async {
    await tap(find.text(bookName));
    await pumpAndSettle();
  }

  Future<void> tapNo() async {
    await tapAllDoneButton('No');
  }

  Future<void> tapYes() async {
    await tapAllDoneButton('Yes');
  }
}
