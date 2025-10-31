import 'package:alchemist/alchemist.dart';
import 'package:bible_feed/model/feed.dart';
import 'package:bible_feed/model/reading_lists.dart';
import 'package:bible_feed/manager/feed_store_manager.dart';
import 'package:bible_feed/view/app.dart';
import 'package:bible_feed/view/book_chapter_dialog.dart';
import 'package:bible_feed/view/settings.dart';
import 'package:bible_feed/view/sync.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../injectable.dart';
import 'helper.dart';

class Scenario {
  const Scenario(this.widget, this.constraints);
  final Widget widget;
  final List<Size> constraints;
}

final epistles2 = sl<ReadingLists>()[3];
final state = sl<FeedStoreManager>().loadState(epistles2);
final deviceConstraints = [const Size(360, 720), const Size(180, 360), const Size(834, 1194)];
final dialogConstraints = [const Size(300, 600), const Size(200, 300), const Size(500, 900)];

final scenarios = {
  'home': Scenario(App(), deviceConstraints),
  'book_chapter_dialog': Scenario(BookChapterDialog(Feed(epistles2, state)), dialogConstraints),
  'settings': Scenario(Settings(), deviceConstraints),
  'sync': Scenario(Sync(), deviceConstraints),
};

Future<void> main() async {
  await configureDependencies('golden');
  WidgetsApp.debugAllowBannerOverride = false; // hide the debug banner

  Helper.enableVerseScopes();
  Helper.initialiseFeeds();

  scenarios.forEach((name, scenario) {
    goldenTest(
      'Golden tests',
      fileName: name,
      builder: () {
        return GoldenTestGroup(
          children:
              scenario.constraints.map((constraint) {
                return GoldenTestScenario(
                  name: constraint.toString(),
                  constraints: BoxConstraints.tight(constraint),
                  child: MaterialApp(home: scenario.widget),
                );
              }).toList(),
        );
      },
    );
  });
}
