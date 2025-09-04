import 'dart:io' show Platform;

import 'package:bible_feed/injectable.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/service/verse_scope_toggler_service.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  final b = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const screenshotsEnabled = true;

  setUp(() async {
    await configureDependencies();
    sl<VerseScopeTogglerService>().isEnabled = true; // enable verse scopes
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
        [0, 0],
      ];
      var chapterState = [
        [5, 12],
        [4, 2],
        [40, 119],
        [15, 17],
        [40, 7],
      ];
      var chapterReadState = [
        [0, 1],
        [0, 0],
        [1, 0],
        [0, 1],
        [1, 1],
      ];
      for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 2; col++) {
          var feed = sl<Feeds>()[row * 2 + col];
          feed.setBookAndChapter(bookState[row][col], chapterState[row][col]);
          if (chapterReadState[row][col] == 1) feed.toggleIsRead();
        }
      }
    }

    Future takeScreenshots(String name, List<Brightness> brightnessList) async {
      if (screenshotsEnabled == false) return;
      for (final (i, brightness) in brightnessList.indexed) {
        t.platformDispatcher.platformBrightnessTestValue = brightness;
        await t.pumpAndSettle();
        await b.takeScreenshot('${Platform.operatingSystem}/$i-${brightness.name}--$name');
      }
    }

    runApp(AppBase());
    await t.pumpAndSettle();

    setState();
    await takeScreenshots('0-feeds_view', [Brightness.light, Brightness.dark]);

    const feedName = 'Epistles II';
    final Finder f = find.text(feedName);
    expect(f, findsOneWidget);
    await t.longPress(f);
    await t.pumpAndSettle();
    expect(find.text(feedName), findsExactly(2));
    await takeScreenshots('1-book_chapter_dialog', [Brightness.light]);
  });
}
