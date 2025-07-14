import 'package:flutter/widgets.dart';
import '/model/bible_app.dart';
import '/model/feed.dart';

enum BibleAppKey { none, youVersion, weDevote }

class BibleAppService with ChangeNotifier {
  BibleAppService() : _linkedBibleAppKey = BibleAppKey.none;

  static final _bibleApps = {
    BibleAppKey.none: NoBibleApp(),
    BibleAppKey.youVersion: YouVersionBibleApp(),
    BibleAppKey.weDevote: WeDevoteBibleApp()
  };

  BibleAppKey _linkedBibleAppKey;

  List<BibleApp> get bibleAppList => _bibleApps.values.toList();
  bool get isLinked => _linkedBibleAppKey != BibleAppKey.none;
  BibleApp get linkedBibleApp => _bibleApps[_linkedBibleAppKey]!;
  int get linkedBibleAppIndex => bibleAppList.indexOf(linkedBibleApp);

  void launchLinkedBibleApp(Feed f) {
    if (isLinked && !f.isChapterRead) linkedBibleApp.launch(f);
  }

  set linkedBibleAppIndex(int idx) {
    if (idx == linkedBibleAppIndex) return;
    _linkedBibleAppKey = _bibleApps.keys.elementAt(idx);
    notifyListeners();
  }
}
