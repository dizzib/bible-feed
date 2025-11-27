@Tags(['screenshots'])
library;

// This script only generates screenshots.
// They are resized and moved to fastlane by external scripts.

import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/manager/catchup_setting_manager.dart';
import 'package:bible_feed/manager/feeds_manager.dart';
import 'package:bible_feed/manager/midnight_manager.dart';
import 'package:bible_feed/service/date_time_service.dart';
import 'package:bible_feed/service/platform_service.dart';
import 'package:bible_feed/service/store_service.dart';
import 'package:bible_feed/view/app_base.dart';
import 'package:df_log/df_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import '../../integration_test/helper.dart';
import '../injectable.dart';
import 'helper.dart';
import 'stub/stub_date_time_service.dart';
import 'stub/stub_midnight_manager.dart';

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
  const Scenario(this.name, {this.brightness = Brightness.light, this.setup, this.tapKey});

  final String name;
  final Brightness brightness;
  final Function()? setup;
  final String? tapKey;
}

final scenarios = {
  const Scenario('home'),
  const Scenario('bookChapterDialog', tapKey: 'ep2'),
  const Scenario('settings', tapKey: 'settingsIconButton'),
  const Scenario('catchup', setup: setupCatchup),
  const Scenario('allDone', setup: setupAllDone),
  const Scenario('share', tapKey: 'shareIconButton'),
  const Scenario('home', brightness: Brightness.dark),
};

void setupAllDone() {
  for (final f in sl<FeedsManager>().feeds.where((f) => !f.state.isRead)) {
    f.toggleIsRead();
  }
}

void setupCatchup() {
  (sl<DateTimeService>() as StubDateTimeService).advance1day();
  (sl<MidnightManager>() as StubMidnightManager).notify();
}

Future main() async {
  await configureDependencies('golden');
  WidgetsApp.debugAllowBannerOverride = false; // hide the debug banner

  Device? lastDevice;
  Helper.enableVerseScopes();

  for (final device in Device.values.where((d) => d.enabled)) {
    Log.info(device.name);
    final targetPlatform = device.platform == Platform.android ? TargetPlatform.android : TargetPlatform.iOS;
    for (final (index, scenario) in scenarios.indexed) {
      // seems to generate in background, even after await!?
      final filename = '${device.platform.name}/${device.name}_$index-${scenario.name}';
      await goldenTest(
        'screenshot',
        fileName: filename,
        pumpBeforeTest: (t) async {
          if (device != lastDevice) {
            Log.info('initialise environment for new device $device');
            await Helper.clearSharedPrefs();
            Helper.initialiseFeeds();
            lastDevice = device;
          }
          Log.info(filename);
          sl.unregister<PlatformService>();
          sl.registerSingleton(PlatformService(currentPlatform: targetPlatform));
          t.platformDispatcher.platformBrightnessTestValue = scenario.brightness;
          sl<CatchupSettingManager>().isEnabled = true;
          if (scenario.setup != null) scenario.setup!();
          await t.pumpAndSettle();
        },
        whilePerforming: (t) async {
          if (scenario.tapKey != null) await t.tapByKey(scenario.tapKey!);
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
