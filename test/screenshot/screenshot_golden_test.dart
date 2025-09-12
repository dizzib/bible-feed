import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/model/feeds.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';

enum Devices {
  googlePixel3('google-pixel-3', Size(1080, 2160), density: 3),
  iPhone8Plus('iphone-8-plus', Size(1242, 2208), density: 3);

  const Devices(this.name, this.size, {required this.density});

  final String name;
  final Size size;
  final double density;

  Size get logicalSize => size / density;
}

class Scenario {
  const Scenario(this.name, {this.brightness = Brightness.light, this.gesture});

  final String name;
  final Brightness brightness;
  final Future<void> Function(WidgetTester)? gesture;
}

final scenarios = {
  const Scenario('home'),
  Scenario('bookChapterDialog', gesture: (t) async => await t.longPress(find.text('Epistles II'))),
  Scenario('settings', gesture: (t) async => await t.tap(find.byKey(const Key('settingsIconButton')))),
  const Scenario('home', brightness: Brightness.dark),
};

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

  for (final device in Devices.values) {
    for (final (index, scenario) in scenarios.indexed) {
      goldenTest(
        'screenshot',
        fileName: '${device.name}-$index-${scenario.name}',
        pumpBeforeTest: (t) {
          t.platformDispatcher.platformBrightnessTestValue = scenario.brightness;
          return t.pumpAndSettle();
        },
        whilePerforming: (t) async {
          if (scenario.gesture != null) await scenario.gesture!(t);
          await t.pumpAndSettle();
          return;
        },
        builder: () {
          return GoldenTestGroup(
            children: [
              GoldenTestScenario(
                name: '', // displayed on top of screenshot
                constraints: BoxConstraints.tight(device.logicalSize),
                child: AppBase(),
              ),
            ],
          );
        },
      );
    }
  }
}
