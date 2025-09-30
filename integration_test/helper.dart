import 'package:bible_feed/view/app_base.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void expectBookAndChapter(String expectedBookName, int expectedChapter) =>
    expectText('$expectedBookName $expectedChapter');

void expectChapters(int expectedValue, {int count = 10}) =>
    expect(find.textContaining(expectedValue.toString()), findsExactly(count));

// text helpers
dynamic expectAtLeast1Text(dynamic expected) => expectText(expected.toString(), matcher: findsAtLeast(1));
dynamic expectNoText(dynamic expected) => expectText(expected.toString(), matcher: findsNothing);
void expectText(dynamic expected, {matcher = findsOneWidget}) =>
    expect(find.textContaining(expected.toString()), matcher);

extension AppTestHelper on WidgetTester {
  Future startApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(AppBase());
    await pumpAndSettle();
  }

  Future selectLastBookAndChapter(String feedName) async {
    await longPress(find.text(feedName));
    await pumpAndSettle();
    await scrollToLastBook();
    await scrollToLastChapter();
    await pumpAndSettle();
    await tap(find.text('Update'));
    await pumpAndSettle();
  }

  Future scrollToLastBook() async {
    await scrollToLastItem('book_wheel');
  }

  Future scrollToLastChapter() async {
    await scrollToLastItem('chapter_wheel');
  }

  Future scrollToLastItem(String keyVal) async {
    await drag(find.byKey(Key(keyVal)), const Offset(0, -999));
  }

  Future tapAllDoneButton(String text) async {
    expectText('All done!');
    await tap(find.text(text));
    await pumpAndSettle();
  }

  Future tapAllLists() async {
    var feedCards = find.byType(FeedCard).evaluate();
    for (var el in feedCards) {
      await tapAt(getCenter(find.byWidget(el.widget)));
    }
    await pumpAndSettle();
  }

  Future tapFab() async {
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  Future tapList(String bookName) async {
    await tap(find.text(bookName));
    await pumpAndSettle();
  }

  Future tapNo() async {
    await tapAllDoneButton('No');
  }

  Future tapYes() async {
    await tapAllDoneButton('Yes');
  }
}
