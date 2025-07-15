import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';
import '/model/bible_app.dart';
import '/model/feed.dart';

enum BibleReaderKey { none, youVersion, weDevote }

class BibleReaderService with ChangeNotifier {
  BibleReaderService() {
    final fromStore = sl<SharedPreferences>().getString(_linkedBibleReaderStoreKey);
    _linkedBibleReaderKey = (fromStore == null) ? BibleReaderKey.none : BibleReaderKey.values.byName(fromStore);
  }

  static final _bibleApps = {
    BibleReaderKey.none: NoBibleReader(),
    BibleReaderKey.youVersion: YouVersionBibleReader(),
    BibleReaderKey.weDevote: WeDevoteBibleReader()
  };

  late BibleReaderKey _linkedBibleReaderKey;
  final _linkedBibleReaderStoreKey = 'linkedBibleReader';

  List<BibleReader> get bibleAppList => _bibleApps.values.toList();
  bool get isLinked => _linkedBibleReaderKey != BibleReaderKey.none;
  BibleReader get linkedBibleReader => _bibleApps[_linkedBibleReaderKey]!;
  int get linkedBibleReaderIndex => bibleAppList.indexOf(linkedBibleReader);

  void launchLinkedBibleReader(Feed f) {
    if (isLinked && !f.isChapterRead) linkedBibleReader.launch(f);
  }

  set linkedBibleReaderIndex(int idx) {
    if (idx == linkedBibleReaderIndex) return;
    _linkedBibleReaderKey = _bibleApps.keys.elementAt(idx);
    sl<SharedPreferences>().setString(_linkedBibleReaderStoreKey, _linkedBibleReaderKey.name);
    notifyListeners();
  }
}
