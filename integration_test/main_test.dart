import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bible_feed/main.dart' as bible_feed;
import 'package:bible_feed/model/feed.dart';

void main() {
  final b = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const screenshotsEnabled = true;

  setUpAll(() =>
    Future(() async {
      WidgetsApp.debugAllowBannerOverride = false;  // hide the debug banner
      if (screenshotsEnabled == true) await b.convertFlutterSurfaceToImage();  // req'd for screenshots on android only
    })
  );

  testWidgets('main', (t) async {
    void setState() {
      var bookChapterState = [
      [0, 5], [1, 12],
      [4, 4], [6, 2],
      [0, 40], [0, 144],
      [0, 15], [5, 17],
      [0, 40], [0, 8]
      ];
      var chaptersReadState = [
        0, 1,
        0, 0,
        1, 1,
        0, 1,
        1, 0
      ];
      for (int i = 0; i < 10; i++) {
        var feed = bible_feed.App.feeds[i];
        feed.setBookAndChapter(bookChapterState[i][0], bookChapterState[i][1]);
        feed.isChapterRead = chaptersReadState[i] == 1 ? true : false;
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

    bible_feed.main();
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
