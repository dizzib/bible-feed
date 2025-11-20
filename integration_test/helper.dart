import 'package:bible_feed/view/app_base.dart';
import 'package:bible_feed/view/feed.dart';
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

  Future scrollToLastBook() async => await scrollToLastItem('book_wheel');
  Future scrollToLastChapter() async => await scrollToLastItem('chapter_wheel');

  Future scrollToLastItem(String keyVal) async {
    await drag(find.byKey(Key(keyVal)), const Offset(0, -999));
    // await pumpAndSettle(); // uncommenting breaks!?
  }

  Future tapAllDoneButton(String text) async {
    expectText('All done!');
    await tap(find.text(text));
    await pumpAndSettle();
  }

  Future tapAllLists() async {
    var feedCards = find.byType(Feed).evaluate();
    for (var el in feedCards) {
      await tapAt(getCenter(find.byWidget(el.widget)));
    }
    await pumpAndSettle();
  }

  Future tapAllDoneFab() async {
    await tap(find.byKey(const Key('all_done_fab')));
    await pumpAndSettle();
  }

  Future tapCatchupFab() async {
    await tap(find.byKey(const Key('catchup_fab')));
    await pumpAndSettle();
  }

  Future tapFab() async {
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  Future tapIconButton(String key) async {
    await tap(find.byKey(Key(key)));
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
