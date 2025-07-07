import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';
import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/feeds.dart';

void main() {
  final b = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const screenshotsEnabled = true;

  setUp(() async {
    WidgetsApp.debugAllowBannerOverride = false; // hide the debug banner
    if (screenshotsEnabled == true) await b.convertFlutterSurfaceToImage(); // req'd for screenshots on android only
  });

  testWidgets('generate_screenshots', (t) async {
    void setState() {
      var bookState = [
        [0, 1],
        [4, 6],
        [0, 0],
        [0, 5],
        [0, 0]
      ];
      var chapterState = [
        [5, 12],
        [4, 2],
        [40, 144],
        [15, 17],
        [40, 8]
      ];
      var chapterReadState = [
        [0, 1],
        [0, 0],
        [1, 1],
        [0, 1],
        [1, 0]
      ];
      for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 2; col++) {
          var feed = sl<Feeds>()[row * 2 + col];
          feed.setBookAndChapter(bookState[row][col], chapterState[row][col]);
          feed.isChapterRead = chapterReadState[row][col] == 1 ? true : false;
        }
      }
    }

    Future<void> takeLightAndDarkScreenshots(String name) async {
      if (screenshotsEnabled == false) return;
      String platform = (Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : ''));
      assert(platform.isNotEmpty);
      t.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await t.pumpAndSettle();
      await b.takeScreenshot('$platform/01-light--$name');
      t.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await t.pumpAndSettle();
      await b.takeScreenshot('$platform/02-dark--$name');
    }

    await bible_feed.main();
    await t.pumpAndSettle();

    setState();
    await takeLightAndDarkScreenshots('01-feeds_view');

    const feedName = 'Epistles II';
    final Finder f = find.text(feedName);
    expect(f, findsOneWidget);

    await t.longPress(f);
    await t.pumpAndSettle();
    expect(find.text(feedName), findsExactly(2));
    await takeLightAndDarkScreenshots('02-book_chapter_dialog');
  });
}
