@Tags(['screenshots'])
library;

// This script only generates screenshots.
// They are resized and moved to fastlane by external scripts.

import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../injectable.dart';
import 'helper.dart';

enum Platform { android, iOS }

enum Device {
  googlePixel3(true, 'google-pixel-3', Platform.android, Size(1080, 2160), density: 3),
  // name must be ipadPro129 to upload to 3rd-gen slot (13")
  iPadPro12(true, 'ipadPro129', Platform.iOS, Size(2048, 2732), density: 2, inches: 12.9),
  // iPadPro11(true, 'ipad-pro-11', Platform.iOS, Size(1668, 2388), density: 2, inches: 11),
  iPhoneXsMax(true, 'iphone-xs-max', Platform.iOS, Size(1242, 2688), density: 3, inches: 6.5);
  // iPhone8Plus(true, 'iphone-8-plus', Platform.iOS, Size(1242, 2208), density: 3, inches: 5.5);
  // These are not yet supported in fastlane...
  // iPhone16ProMax(true, 'iphone-16-pro-max', Platforms.iOS, Size(1320, 2868), density: 3, inches: 6.9),
  // iPhone16Pro(true, 'iphone-16-pro', Platforms.iOS, Size(1206, 2622), density: 3, inches: 6.3),

  const Device(this.enabled, this.name, this.platform, this.physicalSize, {required this.density, this.inches});

  final bool enabled;
  final String name;
  final Platform platform;
  final Size physicalSize;
  final double density;
  final double? inches;

  Size get logicalSize => physicalSize / density;
}

class Scenario {
  const Scenario(this.name, {this.brightness = Brightness.light, this.tapKey});

  final String name;
  final Brightness brightness;
  final String? tapKey;
}

final scenarios = {
  const Scenario('home'),
  const Scenario('bookChapterDialog', tapKey: 'ep2'),
  const Scenario('settings', tapKey: 'settingsIconButton'),
  const Scenario('home', brightness: Brightness.dark),
};

Future<void> main() async {
  await configureDependencies('golden');
  WidgetsApp.debugAllowBannerOverride = false; // hide the debug banner

  Helper.enableVerseScopes();
  Helper.initialiseFeeds();

  for (final device in Device.values.where((d) => d.enabled)) {
    for (final (index, scenario) in scenarios.indexed) {
      // seems to generate in background, even after await!?
      goldenTest(
        'screenshot',
        fileName: '${device.platform.name}/${device.name}_$index-${scenario.name}',
        pumpBeforeTest: (t) {
          t.platformDispatcher.platformBrightnessTestValue = scenario.brightness;
          return t.pumpAndSettle();
        },
        whilePerforming: (t) async {
          if (scenario.tapKey != null) await t.tap(find.byKey(Key(scenario.tapKey!)));
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
