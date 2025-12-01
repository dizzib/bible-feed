import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:bible_feed/view/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

void expectBookAndChapter(String expectedBookName, int expectedChapter) =>
    expectText('$expectedBookName $expectedChapter');

void expectChapters(int expectedValue, {int count = 10}) =>
    expect(find.textContaining(expectedValue.toString()), findsExactly(count));

void expectNotInteractiveByKey(String value) => expect(find.byKey(Key(value)).hitTestable(), findsNothing);

// text helpers
dynamic expectAtLeast1Text(dynamic expected) => expectText(expected.toString(), matcher: findsAtLeast(1));
dynamic expectNoText(dynamic expected) => expectText(expected.toString(), matcher: findsNothing);
void expectText(dynamic expected, {matcher = findsOneWidget}) =>
    expect(find.textContaining(expected.toString()), matcher);

extension AppTestHelper on WidgetTester {
  Future dismissPopup() async {
    final barrierFinder = find.byWidgetPredicate((widget) => widget is ModalBarrier && widget.dismissible == true);
    if (barrierFinder.evaluate().isEmpty) return;
    await tap(barrierFinder.last); // tap top-most barrier
    await pumpAndSettle();
  }

  Future startApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(AppBase());
    await pumpAndSettle();
    expectChapters(1);
  }

  Future scrollToLastBook() async => await scrollToLastItem('book_wheel');
  Future scrollToLastChapter() async => await scrollToLastItem('chapter_wheel');

  Future scrollToLastItem(String value) async {
    await drag(find.byKey(Key(value)), const Offset(0, -999));
    // await pumpAndSettle(); // uncommenting breaks!?
  }

  Future setAllFeedsAsRead() async {
    for (final f in sl<FeedsManager>().feeds.where((f) => !f.state.isRead)) {
      f.toggleIsRead();
    }
    await pumpAndSettle();
  }

  Future tapAllDoneButton(String text) async {
    expectText('All done');
    await tapText(text);
  }

  Future tapAllLists() async {
    var feedCards = find.byType(Feed).evaluate();
    for (var el in feedCards) {
      await tapAt(getCenter(find.byWidget(el.widget)));
    }
    await pumpAndSettle();
  }

  Future tapAllDoneFab() async {
    await tapByKey('all_done_fab');
  }

  Future tapByKey(String value) async {
    await tap(find.byKey(Key(value)));
    await pumpAndSettle();
  }

  Future tapFab() async {
    await tap(find.byType(FloatingActionButton));
    await pumpAndSettle();
  }

  Future tapPopupAction() async {
    await tapByKey('popup_action');
  }

  Future tapText(String value) async {
    await tap(find.text(value));
    await pumpAndSettle();
  }
}
