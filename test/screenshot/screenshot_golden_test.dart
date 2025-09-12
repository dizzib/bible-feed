import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';

enum Devices {
  googlePixel3(density: 3, size: Size(1080, 2160)),
  iPhone8Plus(density: 3, size: Size(1242, 2208));

  const Devices({required this.density, required this.size});

  final double density;
  final Size size;

  Size get logicalSize => size / density;
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

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
        final feed = sl<Feeds>()[row * 2 + col];
        feed.setBookAndChapter(bookState[row][col], chapterState[row][col]);
        if (chapterReadState[row][col] == 1) feed.toggleIsRead();
      }
    }
  }

  setState();

  goldenTest(
    'screenshot',
    fileName: 'android',
    pumpBeforeTest: (t) {
      t.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      return t.pumpAndSettle();
    },
    whilePerforming: (t) async {
      await t.longPress(find.text('Epistles II'));
      await t.pumpAndSettle();
      return;
    },
    builder: () {
      return GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'android',
            constraints: BoxConstraints.tight(Devices.googlePixel3.logicalSize),
            child: AppBase(),
          ),
        ],
      );
    },
  );

  goldenTest(
    'screenshot ios',
    fileName: 'ios',
    pumpBeforeTest: (t) {
      t.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      return t.pumpAndSettle();
    },
    whilePerforming: (t) async {
      await t.tap(find.byKey(const Key('settingsIconButton')));
      await t.pumpAndSettle();
      return;
    },
    builder:
        () => GoldenTestGroup(
          children: [
            GoldenTestScenario(
              name: 'ios',
              constraints: BoxConstraints.tight(Devices.iPhone8Plus.logicalSize),
              child: AppBase(),
            ),
          ],
        ),
  );
}
