import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/data/reading_lists.dart';
import 'package:bible_feed/model/book.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/model/list_wheel_state.dart';
import 'package:bible_feed/view/book_chapter_dialog.dart';
import 'package:bible_feed/view/feed_card.dart';
import 'package:bible_feed/view/feeds_view.dart';
import 'package:bible_feed/util/store.dart';
import '../test/model/_test_data.dart';
import 'helper.dart';

extension Helper on WidgetTester {
  initialiseWidget(Widget widget) async {
    await pumpWidget(MaterialApp(home:widget));
  }
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Store.init();

  testWidgets('BookChapterDialog', (WidgetTester t) async {
    di.registerSingleton(ListWheelState<Book>());
    di.registerSingleton(ListWheelState<int>());
    await t.initialiseWidget(BookChapterDialog(Feed(l2)));
    expectText(b0.name);
    expectText(b1.name);
    expectText(b2.name);
    expectText(l2.name);
    expectText('1');
    expectText('2');
    expectText('3');
    expectText('4');
    expectText('5');
    expectNoText('6');
  });

  testWidgets('FeedCard', (WidgetTester t) async {
    await t.initialiseWidget(FeedCard(Feed(l0)));
    expectText(l0.name);
    expectText(b0.name);
    expectText('1');
    expectNoText('2');
  });

  testWidgets('FeedsView', (WidgetTester t) async {
    di.registerSingleton(Feeds(readingLists));
    await t.initialiseWidget(FeedsView());
    expectChapters(1);
    for (var l in readingLists) { expectAtLeast1Text(l.name); }
  });
}
