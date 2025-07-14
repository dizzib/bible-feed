import 'package:flutter/widgets.dart';
import '/model/bible_app.dart';

enum BibleAppKey { none, youVersion, weDevote }

class BibleAppService with ChangeNotifier {
  BibleAppService() : _bibleAppKey = BibleAppKey.none;

  static final _bibleApps = {
    BibleAppKey.none: NoBibleApp(),
    BibleAppKey.youVersion: YouVersionBibleApp(),
    BibleAppKey.weDevote: WeDevoteBibleApp()
  };

  BibleAppKey _bibleAppKey;

  List<BibleApp> get bibleAppList => _bibleApps.values.toList();
  bool get isLinked => _bibleAppKey != BibleAppKey.none;
  BibleApp get selectedBibleApp => _bibleApps[_bibleAppKey]!;
  int get selectedBibleAppIndex => bibleAppList.indexOf(selectedBibleApp);

  set selectedBibleAppIndex(int idx) {
    if (idx == selectedBibleAppIndex) return;
    _bibleAppKey = _bibleApps.keys.elementAt(idx);
    notifyListeners();
  }
}
